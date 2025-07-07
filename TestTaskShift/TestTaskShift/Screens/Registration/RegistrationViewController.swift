import UIKit

final class RegistrationViewController: UIViewController {
    
    private lazy var registrationView = RegistrationView()
    private let viewModel: RegistrationViewModel
    
    init(viewModel: RegistrationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = registrationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
}

private extension RegistrationViewController {
    
    func navigateToMainScreen() {
        let mainVC = ControllerFactory.makeMainController()
        
        navigationController?.pushViewController(mainVC, animated: true)
    }
    
    func setupBindings() {
        registrationView.setRegistrationTarget(self, action: #selector(handleRegistration))
        registrationView.observeTextFields(target: self, action: #selector(inputsDidChange))
        registrationView.setRegistrationEnabled(false)
        addKeyboardDismissGesture()
    }
    
    func addKeyboardDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func handleRegistration() {
        let data = UserRegistrationData(
            name: registrationView.name ?? "",
            secondName: registrationView.secondName ?? "",
            birthDate: registrationView.birthDate ?? Date(),
            password: registrationView.password ?? "",
            repeatPassword: registrationView.repeatPassword ?? ""
        )
        
        registrationView.hideValidationError()
        
        switch viewModel.validate(data: data) {
            case .success(()):
            viewModel.saveNameToStorage(data.name)
            navigateToMainScreen()
        case .failure(let error):
            registrationView.showValidationError(message: error.localizedDescription)
        }
    }
    
    @objc func inputsDidChange() {
        let name = registrationView.name ?? ""
        let secondName = registrationView.secondName ?? ""
        let password = registrationView.password ?? ""
        let repeatPassword = registrationView.repeatPassword ?? ""

        let fieldsFilled = !name.isEmpty &&
        !secondName.isEmpty &&
        !password.isEmpty &&
        !repeatPassword.isEmpty

        registrationView.setRegistrationEnabled(fieldsFilled)
    }
    
}
