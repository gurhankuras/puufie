import SwiftUI

struct PasswordTextField<Field: Hashable>: View {
    @Binding var text: String
    var focusedField: FocusState<Field?>.Binding
    let passwordCase: Field                 // hangi enum case’i “password”u temsil ediyor
    let placeholder: LocalizedStringKey
    var submitLabel: SubmitLabel = .go      // opsiyonel: login vs signup farklı olabilir

    @State private var isVisible = false

    var body: some View {
        HStack {
            Group {
                if isVisible {
                    TextField(
                        "",
                        text: $text,
                        prompt: Text(placeholder).foregroundColor(.lightAccent2)
                    )
                } else {
                    SecureField(
                        "",
                        text: $text,
                        prompt: Text(placeholder).foregroundColor(.lightAccent2)
                    )
                }
            }
            .textContentType(.password)
            .textInputAutocapitalization(.never)
            .focused(focusedField, equals: passwordCase)
            .submitLabel(submitLabel)

            Button {
                isVisible.toggle()
            } label: {
                Image(systemName: isVisible ? "eye" : "eye.slash")
                    .foregroundColor(isVisible ? .darkAccent2.opacity(0.8) : .lightAccent2)
            }
            .buttonStyle(.plain)
        }
        .appTextFieldStyle(field: passwordCase, focusedField: focusedField)
    }
}
