//
//  Endpoints+Requests.swift
//  puutie
//
//  Created by Gurhan on 11/26/25.
//

// API+EndpointRequests.swift
import Foundation

public extension PuutieAPI.Endpoint {
    func request(_ method: PuutieAPI.HTTPMethod,
                 headers: [String: String] = [:],
                 queryItems: [URLQueryItem] = [],
                 body: PuutieAPI.Body = .none,
                 timeout: TimeInterval = 30,
                 cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy) throws -> URLRequest {
        let opts = PuutieAPI.RequestOptions(
            method: method,
            headers: headers,
            queryItems: queryItems,
            body: body,
            timeout: timeout,
            cachePolicy: cachePolicy
        )
        return try PuutieAPI.makeRequest(to: self, options: opts)
    }

    func get(queryItems: [URLQueryItem] = [], headers: [String:String] = [:]) throws -> URLRequest {
        try request(.GET, headers: headers, queryItems: queryItems)
    }
    func post(body: PuutieAPI.Body = .none, headers: [String:String] = [:]) throws -> URLRequest {
        try request(.POST, headers: headers, body: body)
    }
    func put(body: PuutieAPI.Body = .none, headers: [String:String] = [:]) throws -> URLRequest {
        try request(.PUT, headers: headers, body: body)
    }
    func patch(body: PuutieAPI.Body = .none, headers: [String:String] = [:]) throws -> URLRequest {
        try request(.PATCH, headers: headers, body: body)
    }
    func delete(headers: [String:String] = [:]) throws -> URLRequest {
        try request(.DELETE, headers: headers)
    }
}
