extension Collection {
    @discardableResult
    func concurrentMap<T>(
        _ transform: @escaping (Element) async throws -> T
    ) async rethrows -> [T] {
        try await withThrowingTaskGroup(of: (offset: Int, element: T).self) { group in
            for (offset, element) in enumerated() {
                group.addTask { try await (offset, transform(element)) }
            }

            var result = [T?](repeating: nil, count: count)
            while let transformed = try await group.next() {
                result[transformed.offset] = transformed.element
            }
            return result.compactMap { $0 }
        }
    }
}
