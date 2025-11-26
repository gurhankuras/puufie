//
//  AppVersionService.swift
//  puutie
//
//  Created by Gurhan on 11/20/25.
//
import Foundation

public class AppVersionService {
    
    private let client: NetworkClientProtocol
    
    init(client: NetworkClientProtocol) {
        self.client = client
    }
    
    func getVersionInfo() async throws -> RemoteAppVersionResponse {
        let platform = "iOS"
        let version = Bundle.main.shortVersionString ?? ""
        
        let queries = [
            URLQueryItem(name: "platform", value: platform),
            URLQueryItem(name: "version", value: version),
        ]
        
        var request = try PuutieAPI.AppVersion.version.get(queryItems: queries)
        let response: RemoteAppVersionResponse = try await client.send(&request)
        return response
    }
}
