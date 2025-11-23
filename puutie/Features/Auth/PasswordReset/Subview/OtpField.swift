//
//  OtpField.swift
//  puutie
//
//  Created by Gurhan on 11/19/25.
//

import SwiftUI

struct OTPView: View {
    @Binding var code: String
    @FocusState private var isKeyboardFocused: Bool


    private let length = 6

    // Kod için filtreli binding (sadece rakam ve max 6 karakter)
    private var codeBinding: Binding<String> {
        Binding(
            get: { code },
            set: { newValue in
                let digitsOnly = newValue.filter { $0.isNumber }
                code = String(digitsOnly.prefix(length))
            }
        )
    }

    var body: some View {
        VStack(spacing: 24) {
            Text("reset_password.otp.prompt")
                .font(.headline)
            ZStack {
                // Bu TextField gerçek input’u alıyor (gizli)
                TextField("", text: codeBinding)
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .focused($isKeyboardFocused)
                    .foregroundColor(.clear)
                    .accentColor(.clear)
                    .disableAutocorrection(true)
                    .frame(width: 0, height: 0)
                    .opacity(0.01)

                HStack(spacing: 12) {
                    ForEach(0..<length, id: \.self) { index in
                                            otpBox(at: index)
                                        }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    isKeyboardFocused = true
                }
            }
            Rectangle().fill(.clear)
                .frame(height: 30)

            /*
            Button("reset_password.otp.verify") {
                action(code)
            }
            .disabled(code.count < length)
            .foregroundStyle(code.count < length ?  .lightAccent2 : .accent2)
            .font(.title3.weight(.semibold))
             */
        }
        .padding()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isKeyboardFocused = true
            }
        }
    }
    
        @ViewBuilder
        private func otpBox(at index: Int) -> some View {
            let char = character(at: index)
            let isActive = (index == code.count) && isKeyboardFocused && code.count < length
            
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isActive ? Color.blue : Color.gray.opacity(0.6),
                            lineWidth: isActive ? 2 : 1.5)
                    .frame(width: 40, height: 50)
                
                if let char = char {
                    Text(String(char))
                        .font(.title2)
                } else if isActive {
                    CursorView()
                        .offset(x: -6)
                } else {
                    Text("") // boş kutu
                }
            }
        }

    private func character(at index: Int) -> Character? {
        guard index < code.count else { return nil }
        let stringIndex = code.index(code.startIndex, offsetBy: index)
        return code[stringIndex]
    }
}


fileprivate struct CursorView: View {
    @State private var visible = true
    
    var body: some View {
        Rectangle()
            .fill(Color.blue)
            .frame(width: 2, height: 28)
            .opacity(visible ? 1 : 0)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.4).repeatForever()) {
                    visible.toggle()
                }
            }
    }
}

struct OTPView_Previews: PreviewProvider {

    static var previews: some View {
        OTPView(code: .constant("345633"))
    }

}
