//
//  AsyncState.swift
//  puutie
//
//  Created by Gurhan on 11/19/25.
//

struct Empty: Equatable {}

enum AsyncState<T> {
    case idle
    case loading
    case success(T)
    case error(String)

    var errorMessage: String? {
        guard case .error(let msg) = self else { return nil }
        return msg
    }
}

extension AsyncState {
    var hasError: Bool {
        errorMessage != nil
    }
}

extension AsyncState: Equatable where T: Equatable {}

extension AsyncState where T == Void {
    static var success: AsyncState { .success(()) }
}
extension AsyncState where T == Empty {
    static var success: AsyncState { .success(.init()) }
}
