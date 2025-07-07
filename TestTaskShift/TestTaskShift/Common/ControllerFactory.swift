import Foundation

final class ControllerFactory {
    
    static func makeRegistrationController() -> RegistrationViewController {
        let viewModel = RegistrationViewModel()
        let controller = RegistrationViewController(viewModel: viewModel)
        controller.title = "Регистрация"
        
        return controller
    }
    
    static func makeMainController() -> MainViewController {
        let productProvider = ProductProvider()
        let viewModel = MainViewModel(productProvider: productProvider)
        let controller = MainViewController(viewModel: viewModel)
        controller.title = "Главный экран"
        
        return controller
    }
    
}
