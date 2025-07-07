import Foundation

final class MockProductProvider: ProductProviding {
    
    var resultToReturn: GetProductResult?
    
    func fetchProducts(completion: @escaping (GetProductResult) -> Void) {
        if let result = resultToReturn {
            completion(result)
        }
    }

}
