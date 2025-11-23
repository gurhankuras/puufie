struct Empty: Equatable {}

enum AsyncState<Value, Failure> {
    case idle
    case loading
    case success(Value)
    case error(Failure)
}

// Sadece Failure == String iken errorMessage kullanılabilir
extension AsyncState where Failure == String {
    var errorMessage: String? {
        guard case .error(let msg) = self else { return nil }
        return msg
    }
}

// Her durumda: sadece error case’i var mı diye bakar
extension AsyncState {
    var hasError: Bool {
        if case .error = self { return true }
        return false
    }
}

// Equatable desteği: hem Value hem Failure Equatable ise
extension AsyncState: Equatable where Value: Equatable, Failure: Equatable {}

// success(Void) için: .success yazabil
extension AsyncState where Value == Void {
    static var success: AsyncState {
        .success(())
    }
}

// success(Empty()) için: .success yazabil
extension AsyncState where Value == Empty {
    static var success: AsyncState {
        .success(.init())
    }
}
