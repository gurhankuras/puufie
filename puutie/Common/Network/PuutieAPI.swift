// APIBase.swift
import Foundation

public enum PuutieAPI {
    public protocol Namespace { static var base: [String] { get } }

    public struct Endpoint<NS: Namespace> {
        fileprivate let components: [String]
        public init(_ tail: [String] = []) { self.components = NS.base + tail }

        public var path: String { "/" + components.joined(separator: "/") }
        public var url: URL {
            var u = URL(string: AppConfig.shared.baseURL)!
            components.forEach { u.appendPathComponent($0) }
            return u
        }

        func url(queryItems: [URLQueryItem]) -> URL {
            var comps = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            comps.queryItems = queryItems
            return comps.url!
        }

        public static func segments(_ items: String...) -> Self { .init(items) }
        public static func segment(_ s: String) -> Self { .init([s]) }
    }

    public enum AuthNS: Namespace {
        public static let base = ["api", "auth"]
    }
    public enum UserNS: Namespace {
        public static let base = ["api", "user"]
    }
    public enum ForgotPasswordNS: Namespace {
        public static let base = ["api", "auth", "forgot-password"]
    }
    public enum AppVersionNS: Namespace {
        public static let base = ["api", "app-version"]
    }

    public typealias Auth = Endpoint<AuthNS>
    public typealias User = Endpoint<UserNS>
    public typealias ForgotPassword = Endpoint<ForgotPasswordNS>
    public typealias AppVersion = Endpoint<AppVersionNS>

    public enum HTTPMethod: String { case GET, POST, PUT, PATCH, DELETE, HEAD }

    public enum Body {
        case none
        case json(Encodable, encoder: JSONEncoder? = nil)
        case raw(Data, contentType: String)
        case formURLEncoded([String: String])

        public func apply(to req: inout URLRequest) throws {
            switch self {
            case .none:
                return
            case .json(let encodable, let encoder):
                let enc =
                    encoder
                    ?? {
                        let e = JSONEncoder()
                        e.dateEncodingStrategy = .iso8601
                        return e
                    }()
                do {
                    let data = try enc.encode(AnyEncodable(encodable))
                    req.httpBody = data
                    req.setValue(
                        "application/json",
                        forHTTPHeaderField: "Content-Type"
                    )
                } catch {
                    throw APIError.decoding
                }

            case .raw(let data, let type):
                req.httpBody = data
                req.setValue(type, forHTTPHeaderField: "Content-Type")
            case .formURLEncoded(let dict):
                let body = dict.map { k, v in
                    "\(k.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? k)=\(v.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? v)"
                }.joined(separator: "&")
                req.httpBody = Data(body.utf8)
                req.setValue(
                    "application/x-www-form-urlencoded; charset=utf-8",
                    forHTTPHeaderField: "Content-Type"
                )
            }
        }
    }

    public struct RequestOptions {
        public var method: HTTPMethod
        public var headers: [String: String] = [:]
        public var queryItems: [URLQueryItem] = []
        public var body: Body = .none
        public var timeout: TimeInterval = 30
        public var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy

        public init(
            method: HTTPMethod,
            headers: [String: String] = [:],
            queryItems: [URLQueryItem] = [],
            body: Body = .none,
            timeout: TimeInterval = 30,
            cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
        ) {
            self.method = method
            self.headers = headers
            self.queryItems = queryItems
            self.body = body
            self.timeout = timeout
            self.cachePolicy = cachePolicy
        }
    }

    public static func makeRequest<NS>(
        to endpoint: Endpoint<NS>,
        options: RequestOptions
    ) throws -> URLRequest {
        var url = endpoint.url
        if !options.queryItems.isEmpty {
            var comps = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            comps.queryItems = (comps.queryItems ?? []) + options.queryItems
            url = comps.url!
        }

        var req = URLRequest(
            url: url,
            cachePolicy: options.cachePolicy,
            timeoutInterval: options.timeout
        )
        req.httpMethod = options.method.rawValue

        var headers = ["Accept": "application/json"]
        options.headers.forEach { headers[$0.key] = $0.value }
        headers.forEach { req.setValue($0.value, forHTTPHeaderField: $0.key) }

        try options.body.apply(to: &req)
        return req
    }
}

public struct AnyEncodable: Encodable {
    private let encodeFunc: (Encoder) throws -> Void
    public init(_ value: Encodable) { self.encodeFunc = value.encode }
    public func encode(to encoder: Encoder) throws { try encodeFunc(encoder) }
}
