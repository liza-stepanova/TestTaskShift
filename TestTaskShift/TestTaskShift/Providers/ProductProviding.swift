import Foundation

protocol ProductProviding {
    
    typealias GetProductResult = Result<[Product], GetProductError>
    
    func fetchProducts(completion: @escaping (GetProductResult) -> Void)
    
}
