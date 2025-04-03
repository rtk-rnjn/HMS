import SwiftUI

struct SearchView: View {
    @State private var isSearching = false
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Home")
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)
                
                Button(action: {
                    isSearching = true
                }) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        Text("Search Doctors")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                // Rest of your home screen content here
                Spacer()
            }
            .navigationDestination(isPresented: $isSearching) {
                SearchResultsView(searchText: $searchText)
            }
        }
    }
}

struct SearchResultsView: View {
    @Binding var searchText: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            // Search header
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .padding(.leading)
                
                TextField("Search Doctors", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
            }
            .padding(.vertical, 8)
            
            // Search results
            List {
                if searchText.isEmpty {
                    Text("Start typing to search")
                        .foregroundColor(.gray)
                } else {
                    ForEach(1...5, id: \.self) { item in
                        Text("Search result \(item) for: \(searchText)")
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    SearchView()
} 