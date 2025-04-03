import SwiftUI

struct InfoRowView: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
    }
} 