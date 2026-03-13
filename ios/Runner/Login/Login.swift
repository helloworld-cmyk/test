import SwiftUI

struct LoginView: View {
    let onLoginSuccess: (_ fullName: String, _ email: String) -> Void

    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""

    private let validEmail = "an.nguyen@example.com"
    private let validPassword = "An@123456"
    private let successFullName = "Nguyễn Văn An"

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.96, green: 0.97, blue: 1.0), Color.white],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 8) {
                        Image(systemName: "person.crop.circle.badge.checkmark")
                            .font(.system(size: 54, weight: .semibold))
                            .foregroundColor(.blue)
                            .padding(.bottom, 4)

                        Text("Welcome Back")
                            .font(.system(size: 28, weight: .bold))

                        Text("Sign in to continue")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 16)

                    VStack(spacing: 14) {
                        InputField(
                            title: "Email",
                            placeholder: "you@example.com",
                            text: $email,
                            systemImage: "envelope"
                        )

                        InputField(
                            title: "Password",
                            placeholder: "••••••••",
                            text: $password,
                            systemImage: "lock",
                            isSecure: true
                        )
                    }

                    HStack {
                        Spacer()
                        Button("Forgot password?") {}
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.blue)
                    }

                    Button(action: submitLogin) {
                        HStack {
                            Spacer()
                            Text("Sign In")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.vertical, 14)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .shadow(color: Color.blue.opacity(0.25), radius: 10, y: 6)
                    }

                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    HStack(spacing: 6) {
                        Text("Don’t have an account?")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                        Button("Sign up") {}
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.blue)
                    }
                    .padding(.bottom, 8)
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.08), radius: 24, y: 10)
                )
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
            }
        }
    }

    private func submitLogin() {
        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        guard normalizedEmail == validEmail, password == validPassword else {
            errorMessage = "Email hoặc mật khẩu không đúng"
            return
        }

        errorMessage = ""
        onLoginSuccess(successFullName, validEmail)
    }
}

private struct InputField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let systemImage: String
    var isSecure: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.gray)

            HStack(spacing: 10) {
                Image(systemName: systemImage)
                    .foregroundColor(.gray)
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .background(Color(red: 0.95, green: 0.96, blue: 0.98))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }
}
