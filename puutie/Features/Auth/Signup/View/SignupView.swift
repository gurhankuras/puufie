import SwiftUI

enum SignupFields {
    case username
    case password
    case firstName
    case lastName
    case email
    case countryCode
    case phone
}

struct SignupView: View {
    @StateObject private var viewModel: SignupViewModel = AppContainer.shared
        .buildSignupViewModel()
    @EnvironmentObject var appManager: AppFlowCoordinator
    @EnvironmentObject var router: NavigationRouter
    @FocusState private var focusedField: SignupFields?

    var body: some View {
        ZStack {
            LinearGradient.appBackground
                .ignoresSafeArea()

            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 24) {
                        Spacer(minLength: 40)

                        VStack(alignment: .leading, spacing: 20) {
                            headerSection
                            HStack {
                                Spacer(minLength: 0)
                                AvatarView(
                                    initials: viewModel.initials,
                                    url: nil,
                                    size: .init(width: 80, height: 80)
                                )
                                Spacer(minLength: 0)
                            }

                            // --- NEW FIELDS START ---
                            nameRow
                            emailTextField
                            phoneRow
                            usernameTextField
                            // --- NEW FIELDS END ---

                            PasswordTextField(
                                text: $viewModel.password,

                                focusedField: $focusedField,
                                passwordCase: .password,
                                placeholder: "login.password.placeholder"
                            )
                            PasswordPolicyErrorView(
                                messages: viewModel.passwordErrorMessages
                            )

                            marketingConsentToggle
                            signUpButton
                        }
                        .customCard()
                        .padding(.horizontal, 24)

                        Spacer(minLength: 20)
                    }
                    .frame(maxWidth: .infinity)
                }
                .scrollDismissesKeyboard(.interactively)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    router.pop()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("login.title")
                    }
                    .foregroundColor(.lightShade2)
                }
            }
        }
        .errorDialog(state: $viewModel.state)
        .navigationBarBackButtonHidden(true)
        .onChange(of: viewModel.state) { newValue in
            if case .success(_) = newValue {
                appManager.checkAuthAndRoute()
                router.pop()
            }
        }
        .task {
            await viewModel.getLatestPasswordPolicy()
        }
    }

    // MARK: - Sections

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("login.new_user.sign_up")
                .font(.title2.weight(.semibold))
                .foregroundColor(.lightShade2)

            Text("sign_up.subtitle")
                .font(.subheadline)
                .foregroundColor(.lightAccent2)
        }
    }

    // NEW: Name row (Ad, Soyad)
    private var nameRow: some View {
        HStack(spacing: 12) {
            TextField(
                "",
                text: $viewModel.firstName,
                prompt: Text("sign_up.first_name.placeholder")
                    .foregroundColor(.lightAccent2)
            )
            .textContentType(.givenName)
            .textInputAutocapitalization(.words)
            .focused($focusedField, equals: .firstName)
            .submitLabel(.next)
            .onSubmit { focusedField = .lastName }
            .appTextFieldStyle(field: .firstName, focusedField: $focusedField)

            TextField(
                "",
                text: $viewModel.lastName,
                prompt: Text("sign_up.last_name.placeholder")
                    .foregroundColor(.lightAccent2)
            )
            .textContentType(.familyName)
            .textInputAutocapitalization(.words)
            .focused($focusedField, equals: .lastName)
            .submitLabel(.next)
            .onSubmit { focusedField = .email }
            .appTextFieldStyle(field: .lastName, focusedField: $focusedField)
        }
    }

    // NEW: Email
    private var emailTextField: some View {
        TextField(
            "",
            text: $viewModel.email,
            prompt: Text("sign_up.email.placeholder")
                .foregroundColor(.lightAccent2)
        )
        .keyboardType(.emailAddress)
        .autocorrectionDisabled(true)
        .textInputAutocapitalization(.never)
        .textContentType(.emailAddress)
        .focused($focusedField, equals: .email)
        .submitLabel(.next)
        .onSubmit { focusedField = .countryCode }
        .appTextFieldStyle(field: .email, focusedField: $focusedField)
    }

    // NEW: Country code + phone (inline)
    private var phoneRow: some View {
        HStack(spacing: 12) {
            CountryCodeControl(selected: $viewModel.selectedDialCode)
            TextField(
                "",
                text: $viewModel.phone,
                prompt: Text("sign_up.phone.placeholder")
                    .foregroundColor(.lightAccent2)
            )
            .keyboardType(.numberPad)
            .textContentType(.telephoneNumber)
            .focused($focusedField, equals: .phone)
            .submitLabel(.next)
            .onSubmit { focusedField = .username }
            .appTextFieldStyle(field: .phone, focusedField: $focusedField)
        }
    }

    private var usernameTextField: some View {
        TextField(
            "",
            text: $viewModel.username,
            prompt: Text("login.username.placeholder")
                .foregroundColor(.lightAccent2)
        )
        .textContentType(.username)
        .textInputAutocapitalization(.never)
        .focused($focusedField, equals: .username)
        .submitLabel(.next)
        .onSubmit { focusedField = .password }
        .appTextFieldStyle(
            field: .username,
            focusedField: $focusedField
        )
    }

    private var marketingConsentToggle: some View {
        Toggle(isOn: $viewModel.marketingConsent) {
            Text("sign_up.marketing_consent")
                .foregroundColor(.lightAccent2)
                .font(.footnote)
        }
        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
        .padding(.top, 4)
    }

    private var signUpButton: some View {
        Button("sign_up.button.label") {
            Task { await viewModel.signUp() }
        }
        .padding(.top, 8)
        .longButtonStyle(isDisabled: !viewModel.canProceeedToSignUp)
    }
}

#Preview { SignupView() }
