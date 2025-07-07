import Foundation

final class ProductProvider: ProductProviding {
    
    func fetchProducts(completion: @escaping (GetProductResult) -> Void) {
        guard let url = URL(string: "https://fakestoreapi.com/products") else {
            return completion(.failure(.invalidURL))
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(.network(error)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.invalidData))
                    return
                }
                
                do {
                    let products = try JSONDecoder().decode([Product].self, from: data)
                    completion(.success(products))
                } catch {
                    completion(.failure(.invalidData))
                }
            }.resume()
        }
    }
    
}
