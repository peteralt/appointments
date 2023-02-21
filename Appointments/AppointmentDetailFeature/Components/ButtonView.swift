import SwiftUI

struct ButtonView: View {
    var title: String
    var didTap: () -> Void
    var color: Color
    
    var body: some View {
        Button(action: {
            didTap()
        }) {
            Text(title)
                .padding(.horizontal, 32)
                .padding(.vertical, 8)
                .fixedSize()
                .foregroundColor(Color.white)
                .font(.caption.weight(.heavy))
        }
        .background {
            RoundedRectangle(cornerRadius: 100)
                .fill(color)
        }
    }
}

#if DEBUG
struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(title: "Title", didTap: {}, color: .red)
    }
}
#endif
