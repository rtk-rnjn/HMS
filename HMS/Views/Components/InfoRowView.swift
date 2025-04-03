import SwiftUI

struct InfoRowView: View {
    let title: String
    let value: String
    let icon: String
    
    init(title: String, value: String, icon: String = "circle.fill") {
        self.title = title
        self.value = value
        self.icon = icon
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(Color(.systemGray))
                .font(.system(size: 18))
            Text(title)
                .foregroundColor(Color(.systemGray))
                .font(.system(size: 17))
            Spacer()
            Text(value)
                .foregroundColor(.primary)
                .font(.system(size: 17))
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    InfoRowView(title: "Sample", value: "Value", icon: "person.fill")
        .padding()
} 