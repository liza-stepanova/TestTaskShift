import XCTest
@testable import TestTaskShift

final class RegistrationViewModelTests: XCTestCase {
    
    private var registrationViewModel: RegistrationViewModel!
    private var validBirthDate: Date!

    override func setUp() {
        super.setUp()
        
        registrationViewModel = RegistrationViewModel()
        let dateComponents = DateComponents(year: 2004, month: 3, day: 17)
        validBirthDate = Calendar.current.date(from: dateComponents)
    }
    
    override func tearDown() {
        registrationViewModel = nil
        validBirthDate = nil
        super.tearDown()
    }

    func testValidDataReturnsSuccess() {
        let data = UserRegistrationData(
            name: "Елизавета",
            secondName: "Степанова",
            birthDate: validBirthDate,
            password: "12345L",
            repeatPassword: "12345L"
        )

        let result = registrationViewModel.validate(data: data)

        switch result {
        case .success:
            XCTAssertTrue(true)
        case .failure(let error):
            XCTFail("Unexpected failure: \(error)")
        }
    }
    
    func testShortNameReturnsInvalidNameError() {
        let data = UserRegistrationData(
            name: "Е",
            secondName: "Степанова",
            birthDate: validBirthDate,
            password: "12345L",
            repeatPassword: "12345L"
        )

        let result = registrationViewModel.validate(data: data)

        switch result {
        case .failure(let error):
            XCTAssertEqual(error, .invalidName)
        default:
            XCTFail("Expected failure for short name")
        }
    }
    
    func testShortSecondNameReturnsInvalidSecondNameError() {
        let data = UserRegistrationData(
            name: "Елизавета",
            secondName: "С",
            birthDate: validBirthDate,
            password: "12345L",
            repeatPassword: "12345L"
        )

        let result = registrationViewModel.validate(data: data)

        switch result {
        case .failure(let error):
            XCTAssertEqual(error, .invalidSecondName)
        default:
            XCTFail("Expected failure for short second name")
        }
    }
    
    func testTooYoungBirthDateReturnsInvalidBirthDateError() {
        let tooYoungDate = Calendar.current.date(byAdding: .year, value: -10, to: Date())!

        let data = UserRegistrationData(
            name: "Елизавета",
            secondName: "Степанова",
            birthDate: tooYoungDate,
            password: "12345L",
            repeatPassword: "12345L"
        )

        let result = registrationViewModel.validate(data: data)

        switch result {
        case .failure(let error):
            XCTAssertEqual(error, .invalidBirthDate)
        default:
            XCTFail("Expected failure for too young age")
        }
    }

    func testWeakPasswordReturnsInvalidPasswordError() {
        let data = UserRegistrationData(
            name: "Елизавета",
            secondName: "Степанова",
            birthDate: validBirthDate,
            password: "123",
            repeatPassword: "123"
        )

        let result = registrationViewModel.validate(data: data)

        switch result {
        case .failure(let error):
            XCTAssertEqual(error, .invalidPassword)
        default:
            XCTFail("Expected failure for weak password")
        }
    }
    
    func testNonMatchingPasswordsReturnsPasswordsDoNotMatch() {
        let data = UserRegistrationData(
            name: "Елизавета",
            secondName: "Степанова",
            birthDate: validBirthDate,
            password: "12345L",
            repeatPassword: "123"
        )

        let result = registrationViewModel.validate(data: data)

        switch result {
        case .failure(let error):
            XCTAssertEqual(error, .passwordsDoNotMatch)
        default:
            XCTFail("Expected failure for mismatching passwords")
        }
    }

}
