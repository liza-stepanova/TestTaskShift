import Foundation

final class RegistrationViewModel {
    
    enum ValidationError: LocalizedError {
        case invalidName
        case invalidSecondName
        case invalidBirthDate
        case invalidPassword
        case passwordsDoNotMatch
        
        var errorDescription: String? {
            switch self {
            case .invalidName:
                return "Имя должно быть не менее 2х символов"
            case .invalidSecondName:
                return "Фамилия должна быть не менее 2х символов"
            case .invalidBirthDate:
                return "Вы должны быть старше 14 лет"
            case .invalidPassword:
                return "Пароль должен содержать минимум 6 символов: хотя бы одну заглавную букву и одну цифру."
            case .passwordsDoNotMatch:
                return "Пароли не совпадают"
            }
        }
    }
    
    func validate(data: UserRegistrationData) -> Result<Void, ValidationError> {
        guard data.name.count >= 2 else {
            return .failure(.invalidName)
        }
        guard data.secondName.count >= 2 else {
            return .failure(.invalidSecondName)
        }
        guard isValidAge(data.birthDate) else {
            return .failure(.invalidBirthDate)
        }
        guard isValidPassword(data.password) else {
            return .failure(.invalidPassword)
        }
        guard data.password == data.repeatPassword else {
            return .failure(.passwordsDoNotMatch)
        }
        
        return .success(())
    }
    
    func saveNameToStorage(_ name: String) {
        UserDefaults.standard.set(name, forKey: "userName")
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        let uppercase = CharacterSet.uppercaseLetters
        let digits = CharacterSet.decimalDigits
        return password.rangeOfCharacter(from: uppercase) != nil &&
        password.rangeOfCharacter(from: digits) != nil &&
        password.count >= 6
    }
    
    private func isValidAge(_ birthDate: Date) -> Bool {
        let calendar = Calendar.current
        let now = Date()
            
        let ageComponents = calendar.dateComponents(
            [.year],
            from: birthDate,
            to: now
        )
        guard let age = ageComponents.year else { return false }
            
        return age >= 14 && age <= 120
    }
    
}
