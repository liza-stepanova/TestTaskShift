import Foundation

enum GetProductError: Error {

    case invalidURL
    case invalidData
    case network(Error)

}
