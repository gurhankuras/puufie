import SwiftUI

struct CountryCodeControl: View {
    @Binding var selected: CountryDialCode

    var body: some View {
        Menu {
            Picker("Ülke Kodu", selection: $selected) {
                ForEach(CountryDialCode.all) { item in
                    Text("\(item.flagEmoji) \(item.dialCode)  \(item.name)").tag(item)
                }
            }
        } label: {
            HStack(spacing: 8) {
                Text(selected.flagEmoji).font(.body)
                Text(selected.dialCode).font(.body.weight(.semibold))
                Image(systemName: "chevron.up.chevron.down")
                    .font(.footnote)
                    .opacity(0.6)
            }
            .frame(minWidth: 84)
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .background(Color.lightShade2)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .menuStyle(.borderlessButton)
    }
}

#Preview {
    struct Demo: View {
        @State private var code: CountryDialCode = .init(regionCode: "TR", name: "Türkiye", dialCode: "+90")
        var body: some View {
            VStack(spacing: 16) {
                CountryCodeControl(selected: $code)
                Text("Seçilen: \(code.flagEmoji) \(code.dialCode) – \(code.name)")
            }
            .padding()
        }
    }
    return Demo()
}
