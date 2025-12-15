import Foundation

struct EmptyResponse: Decodable {}

protocol NetworkClientProtocol {
    func send<T: Decodable>(_ request: inout URLRequest) async throws -> T
    func send<T: Decodable>(
        _ request: URLRequest,
        completion: @escaping (Result<T, APIError>) -> Void
    )
}
