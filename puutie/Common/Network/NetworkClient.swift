//
//  NetworkClient.swift
//  puutie
//
//  Created by Gurhan on 11/28/25.
//

import Foundation

final class NetworkClient: NetworkClientProtocol {

    private let urlSession: URLSession
    private let requestAuthorizer: RequestAuthorizing
    private let decoder: JSONDecoder
    private let onUnauthorized: (() -> Void)?

    init(
        urlSession: URLSession = .shared,
        requestAuthorizer: RequestAuthorizing,
        decoder: JSONDecoder = makeJSONDecoder(),
        onUnauthorized: (() -> Void)? = nil
    ) {
        self.urlSession = urlSession
        self.requestAuthorizer = requestAuthorizer
        self.decoder = decoder
        self.onUnauthorized = onUnauthorized
    }

    func send<T: Decodable>(_ request: inout URLRequest) async throws -> T {

        if request.cachePolicy == .useProtocolCachePolicy {
            // ok
        } else {
            request.cachePolicy = .useProtocolCachePolicy
        }

        // Accept-Language (varsa)
        if let language = Locale.current.language.languageCode?.identifier {
            request.setValue(language, forHTTPHeaderField: "Accept-Language")
        }

        // Yetkilendirme
        requestAuthorizer.authorize(&request)

        do {
            let (data, response) = try await urlSession.data(for: request)

            guard let http = response as? HTTPURLResponse else {
                throw APIError.unknown
            }

            // 401 özel eşleme
            if http.statusCode == 401 {
                // 401 hatası yakalandığında kullanıcıyı logout yap
                onUnauthorized?()
                throw APIError.unauthorized
            }

            // 🔽 304: cached gövdeyi kullan
            if http.statusCode == 304 {
                // request ile eşleşen cached response'u al
                if let cached = URLCache.shared.cachedResponse(for: request) {
                    do {
                        // Burada cached.response normalde eski 200 cevabıdır
                        return try decoder.decode(T.self, from: cached.data)
                    } catch {
                        throw APIError.decoding
                    }
                } else {
                    // Cache yoksa bu bir tutarsızlık; sunucu body göndermedi
                    throw APIError.unknown
                }
            }

            // 2xx dışı HTTP → server
            guard (200..<300).contains(http.statusCode) else {
                let errorBody = try? decoder.decode(
                    ApiErrorObject.self,
                    from: data
                )
                throw APIError.server(
                    statusCode: http.statusCode,
                    body: errorBody
                )
            }

            // 204 No Content veya boş gövde
            if http.statusCode == 204 || data.isEmpty {
                if T.self == EmptyResponse.self {
                    return EmptyResponse() as! T
                }
                // bazı 200'ler de boş dönebilir; decode etmeyi denemeyelim
                throw APIError.decoding
            }

            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                print(error)
                throw APIError.decoding
            }

        } catch let apiError as APIError {
            throw apiError
        } catch {
            // URLSession hatalarını tek yerden sar
            throw APIError.transport(error)
        }
    }
}

extension NetworkClient {
    func send<T: Decodable>(
        _ request: URLRequest,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        Task {
            do {
                var mutableRequest = request
                let result: T = try await send(&mutableRequest)
                completion(.success(result))
            } catch let error as APIError {
                completion(.failure(error))
            } catch {
                completion(.failure(.unknown))
            }
        }
    }
}
