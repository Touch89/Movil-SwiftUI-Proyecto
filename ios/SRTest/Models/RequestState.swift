enum RequestState<Value> {
    case loading
    case failure(message: String)
    case success(Value)

    var value: Value? {
        if case .success(let value) = self { return value }
        return nil
    }

    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
}
