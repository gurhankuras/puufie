//
//  ApiError.swift
//  puutie
//
//  Created by Gurhan on 11/18/25.
//

enum APIError: Error {
    case invalidURL
    case transport(Error)
    case server(statusCode: Int, body: ApiErrorObject?)
    case decoding
    case unauthorized
    case unknown
}
