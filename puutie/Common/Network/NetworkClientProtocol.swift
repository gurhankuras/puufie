//
//  NetworkClientProtocol.swift
//  puutie
//
//  Created by Gurhan on 11/18/25.
//

import Foundation

struct EmptyResponse: Decodable {}

protocol NetworkClientProtocol {
    func send<T: Decodable>(_ request: URLRequest) async throws -> T
}

final class NetworkClient: NetworkClientProtocol {
    func send<T: Decodable>(_ request: URLRequest) async throws -> T {
        var req = request
        
        let language = Locale.current.language.languageCode?.identifier
        req.setValue(
            language,
            forHTTPHeaderField: "Accept-Language"
        )
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let (data, response) = try await URLSession.shared.data(
                for: req
            )

            guard let http = response as? HTTPURLResponse else {
                throw APIError.unknown
            }

            // 2xx değilse server error
            guard (200..<300).contains(http.statusCode) else {
                let errorBody = try? JSONDecoder().decode(
                    ApiErrorObject.self,
                    from: data
                )
                throw APIError.server(
                    statusCode: http.statusCode,
                    body: errorBody
                )
            }
            // handle http status code 204 no response
            if http.statusCode == 204 && T.self == EmptyResponse.self {
                return EmptyResponse() as! T
            }
            guard let result = try? JSONDecoder().decode(T.self, from: data)
            else {
                throw APIError.decoding
            }
            return result

        } catch let apiError as APIError {
            throw apiError
        } catch {
            throw APIError.transport(error)
        }
    }
}
