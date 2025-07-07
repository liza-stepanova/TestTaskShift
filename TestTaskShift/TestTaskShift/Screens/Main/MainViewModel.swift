import Foundation

final class MainViewModel {
    
    private let productProvider: ProductProviding
    private(set) var products: [Product] = []
    
    var onProductsUpdated: (() -> Void)?
    
    init(productProvider: ProductProviding) {
        self.productProvider = productProvider
    }
    
    func getProducts() {
        productProvider.fetchProducts { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let products):
                self.products = products
                DispatchQueue.main.async {
                    self.onProductsUpdated?()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
