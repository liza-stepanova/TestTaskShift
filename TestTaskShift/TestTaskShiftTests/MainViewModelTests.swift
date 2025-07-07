import XCTest
@testable import TestTaskShift

final class MainViewModelTests: XCTestCase {
    
    private var mockProvider: MockProductProvider!
    private var viewModel: MainViewModel!
    
    override func setUp() {
        super.setUp()
        
        mockProvider = MockProductProvider()
        viewModel = MainViewModel(productProvider: mockProvider)
    }
    
    override func tearDown() {
        mockProvider = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testSuccessResponse_updatesProducts() {
        let expectedProducts = [
            Product(title: "Product 1", price: 10.0),
            Product(title: "Product 2", price: 20.0)
        ]
        mockProvider.resultToReturn = .success(expectedProducts)
        
        let expectation = XCTestExpectation(description: "Products updated")
        viewModel.onProductsUpdated = {
            expectation.fulfill()
        }

        viewModel.getProducts()
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(viewModel.products.count, 2)
        XCTAssertEqual(viewModel.products.first?.title, "Product 1")
    }
    
    func testFailureResponse_doesNotUpdateProductsOrCallCallback() {
        mockProvider.resultToReturn = .failure(.invalidData)
        
        let expectation = XCTestExpectation(description: "Products not updated")
        expectation.isInverted = true
        
        viewModel.onProductsUpdated = {
            expectation.fulfill()
        }
        
        viewModel.getProducts()
        
        wait(for: [expectation], timeout: 0.5)
        XCTAssertTrue(viewModel.products.isEmpty)
    }
    
}
