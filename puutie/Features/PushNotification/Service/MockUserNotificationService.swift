//
//  MockUserNotificationService.swift
//  puutie
//
//  Created by Gurhan on 11/30/25.
//

import Foundation

final class MockUserNotificationService: UserNotificationProvider {
    /// Simulated delay in seconds for more realistic testing
    var simulatedDelay: TimeInterval = 0.5
    
    /// Whether to simulate errors
    var shouldSimulateError: Bool = false
    
    /// Error to throw when shouldSimulateError is true
    var simulatedError: Error?
    
    /// All available stub notifications
    private var allStubs: [UserNotificationDto] {
        UserNotificationDto.stubs
    }
    
    init(simulatedDelay: TimeInterval = 0.5, shouldSimulateError: Bool = false) {
        self.simulatedDelay = simulatedDelay
        self.shouldSimulateError = shouldSimulateError
    }
    
    func getUserNotifications(page: Int, size: Int) async throws
        -> PagedResponse<UserNotificationDto>
    {
        // Simulate network delay
        await Task.sleep(seconds: simulatedDelay)
        
        // Simulate error if configured
        if shouldSimulateError {
            throw simulatedError ?? NSError(
                domain: "MockUserNotificationService",
                code: 500,
                userInfo: [NSLocalizedDescriptionKey: "Simulated error"]
            )
        }
        
        // Calculate pagination
        let totalElements = allStubs.count
        let totalPages = max(1, Int(ceil(Double(totalElements) / Double(size))))
        let startIndex = page * size
        let endIndex = min(startIndex + size, totalElements)
        
        // Get paginated content
        let paginatedContent: [UserNotificationDto]
        if startIndex < totalElements {
            paginatedContent = Array(allStubs[startIndex..<endIndex])
        } else {
            paginatedContent = []
        }
        
        return PagedResponse(
            content: paginatedContent,
            page: page,
            size: size,
            totalElements: totalElements,
            totalPages: totalPages,
            first: page == 0,
            last: page >= totalPages - 1
        )
    }
}
