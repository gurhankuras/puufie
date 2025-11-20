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
        let url = Endpoints.url(Endpoints.appVersion.version)
            .appending(queryItems: queries)
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let response: RemoteAppVersionResponse = try await client.send(request)
        return response
    }
}
