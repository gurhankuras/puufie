import Combine
import Foundation

@MainActor
class SignupViewModel: ObservableObject {
    private let authService: AuthService
    private let validator: PasswordValidator

    init(authService: AuthService) {
        self.authService = authService
        self.validator = PasswordValidator()
        bindValidation()
    }

    // Existing
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var policyState: AsyncState<PasswordPolicy, String> = .idle
    @Published private(set) var latestPolicy: PasswordPolicy?
    @Published var state: AsyncState<String, String> = .idle
    @Published var passwordErrorMessages: [String] = []
    @Published private(set) var isPasswordValid: Bool = false

    // New fields
    @Published var firstName: String = ""  // Ad
    @Published var lastName: String = ""  // Soyad
    @Published var email: String = ""  // E-posta
    @Published var phone: String = ""  // Telefon numarası (local, no +)
    @Published var selectedDialCode: CountryDialCode = .init(
        regionCode: "TR",
        name: "Türkiye",
        dialCode: "+90"
    )
    @Published var marketingConsent: Bool = false  // Mantıklı ek bilgi (isteğe bağlı)

    var initials: String? {
        var i = ""
        let trimmedFirstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedLastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedFirstName.count >= 1 {
            i.append(trimmedFirstName.prefix(1).uppercased())
        }
        if trimmedLastName.count >= 1 {
            i.append(trimmedLastName.prefix(1).uppercased())
        }

        if i.isEmpty {
            return nil
        }
        return i
    }

    // Form validity (password + new fields)
    var canProceeedToSignUp: Bool {  // keep typo to avoid ripple renames
        return isPasswordValid
            && !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && !firstName.trimmingCharacters(in: .whitespacesAndNewlines)
                .isEmpty
            && !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && SignupValidators.isValidEmail(email)
        && SignupValidators.isValidPhone(
                countryCode: selectedDialCode.dialCode,
                phone: phone
            )
    }

    private func bindValidation() {
        // no bounce for instant validation (password only)
        Publishers.CombineLatest($password.removeDuplicates(), $latestPolicy)
            .map { [unowned self] password, policy in
                guard let policy else { return false }
                return self.validator.validate(password, policy: policy).isValid
            }
            .receive(on: RunLoop.main)
            .assign(to: &$isPasswordValid)

        // debounce for password error messages
        Publishers.CombineLatest(
            $password.removeDuplicates().dropFirst(),
            $latestPolicy
        )
        .debounce(for: .milliseconds(750), scheduler: RunLoop.main)
        .map { [unowned self] password, policy in
            guard let policy else { return [] }
            return self.validator.validate(password, policy: policy).errors
        }
        .receive(on: RunLoop.main)
        .assign(to: &$passwordErrorMessages)
    }

    // API
    func getLatestPasswordPolicy() async {
        policyState = .loading
        do {
            let policy = try await authService.getLatestPasswordPolicy()
            latestPolicy = policy
            policyState = .success(policy)
        } catch let apiError as APIError {
            if case .server(_, let object) = apiError {
                policyState = .error(object?.message ?? "")
                return
            }
            policyState = .error("Something went wrong.")
        } catch {
            policyState = .error("Unexpected error.")
        }
    }
    
    
    private func buildRequestFromSanitizedData() -> SignupRequest {
        return SignupRequest(
            username: username.trimmingCharacters(in: .whitespacesAndNewlines),
            password: password,
            firstName: firstName.trimmingCharacters(in: .whitespacesAndNewlines),
            lastName: lastName.trimmingCharacters(in: .whitespacesAndNewlines),
            email: email.trimmingCharacters(in: .whitespacesAndNewlines),
            countryCode: selectedDialCode.dialCode,
            phoneNumber: phone.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }

    func signUp() async {
        guard canProceeedToSignUp else {
            state = .error("Lütfen şifre ve form gereksinimlerini karşılayın.")
            return
        }
        state = .loading

        do {
            let request = buildRequestFromSanitizedData()
            let res = try await authService.signUp(with: request)
            state = .success(res.accessToken)
        } catch let apiError as APIError {
            if case .server(_, let object) = apiError {
                state = .error(object?.message ?? "")
                if let strings = object?.details?["errorMessages"]?.stringArray
                {
                    passwordErrorMessages = strings
                }
                return
            }
            state = .error("Something went wrong.")
        } catch {
            state = .error("Unexpected error.")
        }
    }
}
