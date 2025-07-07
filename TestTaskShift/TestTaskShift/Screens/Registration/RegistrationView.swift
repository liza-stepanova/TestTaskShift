import UIKit

final class RegistrationView: UIView {
    
    private lazy var nameTextField = makeTextField()
    private lazy var secondNameTextField = makeTextField()
    private lazy var passwordTextField = makeTextField()
    private lazy var repeatPasswordTextField = makeTextField()
    
    private let birthDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Дата рождения:"
        return label
    }()
    
    private let birthDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        let calendar = Calendar.current
        let currentDate = Date()

        if let minDate = calendar.date(
            byAdding: .year,
            value: -120,
            to: currentDate
        ),
           let maxDate = calendar.date(
            byAdding: .year,
            value: -14,
            to: currentDate
           ) {
            datePicker.minimumDate = minDate
            datePicker.maximumDate = maxDate
            datePicker.date = maxDate 
        }

        
        return datePicker
    }()
    
    private let registrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Регистрация", for: .normal)
        button.layer.cornerRadius = 14
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        return button
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .red
        label.textAlignment = .center
        return label
    }()
    
    private let fieldsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RegistrationView {
    
    var name: String? { nameTextField.text }
    var secondName: String? { secondNameTextField.text }
    var birthDate: Date? { birthDatePicker.date }
    var password: String? { passwordTextField.text }
    var repeatPassword: String? { repeatPasswordTextField.text }
    
    func setRegistrationTarget(_ target: Any?, action: Selector) {
        registrationButton.addTarget(target, action: action, for: .touchUpInside)
    }
        
    func showValidationError(message: String) {
        errorLabel.text = message
        registrationButton.shake()
    }
    
    func hideValidationError() {
        errorLabel.text = ""
    }
    
    func setRegistrationEnabled(_ isEnabled: Bool) {
        registrationButton.isEnabled = isEnabled
        registrationButton.backgroundColor = isEnabled ? .systemBlue : .systemGray4
    }
    
    func observeTextFields(target: Any?, action: Selector) {
        [nameTextField, secondNameTextField, passwordTextField, repeatPasswordTextField].forEach {
            $0.addTarget(target, action: action, for: .editingChanged)
        }
    }
    
}

private extension RegistrationView {
    
    func makeTextField() -> UITextField {
        let textField = UITextField()
        textField.autocorrectionType = .no
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 8
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return textField
    }
    
    func setupViews() {
        setupFieldsStack()
        setupTextFields()
        configureLayout()
    }

    func setupTextFields() {
        nameTextField.placeholder = "Имя"
        
        secondNameTextField.placeholder = "Фамилия"
        
        passwordTextField.placeholder = "Пароль"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .none
        
        repeatPasswordTextField.placeholder = "Повтор пароля"
        repeatPasswordTextField.isSecureTextEntry = true
        repeatPasswordTextField.textContentType = .none
    }
    
    func setupFieldsStack() {
        fieldsStack.addArrangedSubview(nameTextField)
        fieldsStack.addArrangedSubview(secondNameTextField)

        let birthDateRow = UIStackView(arrangedSubviews: [birthDateLabel, birthDatePicker])
        birthDateRow.axis = .horizontal
        birthDateRow.distribution = .equalSpacing
        fieldsStack.addArrangedSubview(birthDateRow)

        fieldsStack.addArrangedSubview(passwordTextField)
        fieldsStack.addArrangedSubview(repeatPasswordTextField)

    }
    
    func configureLayout() {
        addSubview(fieldsStack)

        NSLayoutConstraint.activate([
            fieldsStack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            fieldsStack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            fieldsStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
        ])

        addSubview(registrationButton)
        registrationButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            registrationButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            registrationButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            registrationButton.heightAnchor.constraint(equalToConstant: 46),
            registrationButton.widthAnchor.constraint(equalToConstant: 200),
        ])
        
        addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            errorLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            errorLabel.bottomAnchor.constraint(equalTo: registrationButton.topAnchor, constant: -20),
        ])
    }
    
}
