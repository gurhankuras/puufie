//
//  ApiError+toUserErrorMessage.swift
//  puutie
//
//  Created by Gurhan on 11/29/25.
//

import Foundation
extension APIError {
    func toUserMessage() -> String {
        switch self {
        case .server(_, let object):
            return object?.message ?? "Something went wrong."
        case .unauthorized:
            return "Unauthorized. Please login again."
        case .decoding:
            return "Failed to parse response."
        case .transport(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidURL, .unknown:
            return "Something went wrong."
        }
    }
}


