//
//  ApiErrorObject.swift
//  puutie
//
//  Created by Gurhan on 11/18/25.
//

/*
 {
 "timestamp": "2025-11-18T17:27:35.503167Z",
 "status": 500,
 "path": "/api/auth/login",
 "traceId": "12b764bd-6cb0-4227-b94e-4936efb6d1a3",
 "type": "INTERNAL",
 "code": "INTERNAL_ERROR",
 "message": "An unexpected internal error occurred.",
 "details": {}
 }
 */

struct ApiErrorObject: Decodable {
    let timestamp: String
    let status: Int
    let path: String
    let traceId: String
    let type: String
    let code: String
    let message: String
}
