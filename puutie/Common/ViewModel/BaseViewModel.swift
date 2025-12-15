//
//  BaseViewModel.swift
//  puutie
//
//  Created by Gurhan on 11/29/25.
//


protocol BaseViewModel: AnyObject {
    func handleError<T>(_ error: Error, state: inout AsyncState<T, String>)
}

extension BaseViewModel {
    func handleError<T>(_ error: Error, state: inout AsyncState<T, String>) {
        if let apiError = error as? APIError {
            state = .error(apiError.toUserMessage())
        } else {
            state = .error("Unexpected error.")
        }
    }
}
