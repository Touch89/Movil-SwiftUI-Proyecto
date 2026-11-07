import SwiftUI

struct LoginScreen: View {
    private enum Field {
        case username
        case password
    }

    let onLogin: () -> Void

    @State private var username = ""
    @State private var password = ""
    @State private var showsError = false
    @FocusState private var focusedField: Field?

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                AppLogo(size: 88)
                    .padding(.bottom, 24)

                Text("Inicia sesión")
                    .font(.system(size: 30, weight: .bold))
                    .tracking(-1.1)
                    .foregroundStyle(Theme.textPrimary)

                Text("Entra para explorar el catálogo")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Theme.textSecondary)
                    .padding(.top, 8)
                    .padding(.bottom, 30)

                VStack(spacing: 10) {
                    TextField("Usuario", text: $username)
                        .textContentType(.username)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .submitLabel(.next)
                        .focused($focusedField, equals: .username)
                        .onSubmit { focusedField = .password }
                        .loginFieldStyle()

                    SecureField("Contraseña", text: $password)
                        .textContentType(.password)
                        .submitLabel(.go)
                        .focused($focusedField, equals: .password)
                        .onSubmit(logIn)
                        .loginFieldStyle()
                }

                if showsError {
                    Text("Usuario o contraseña incorrectos.")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color(hex: 0xFF8A7A))
                        .padding(.top, 12)
                }

                PrimaryButton(
                    title: "Entrar",
                    systemImage: "arrow.right",
                    isFullWidth: true,
                    action: logIn
                )
                .padding(.top, 20)
            }
            .padding(.horizontal, 22)
            .padding(.top, 72)
            .padding(.bottom, 32)
        }
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.interactively)
        .background(AppBackground())
    }

    private func logIn() {
        if AuthService.isValid(username: username, password: password) {
            showsError = false
            focusedField = nil
            onLogin()
        } else {
            showsError = true
        }
    }
}

private extension View {
    func loginFieldStyle() -> some View {
        let shape = RoundedRectangle(cornerRadius: 13)

        return self
            .font(.system(size: 15, weight: .medium))
            .foregroundStyle(Theme.textPrimary)
            .padding(.horizontal, 15)
            .frame(minHeight: 50)
            .background(Color(hex: 0x13181F, opacity: 0.85), in: shape)
            .overlay {
                shape.strokeBorder(Color(hex: 0x7E9BB6, opacity: 0.18), lineWidth: 1)
            }
    }
}
