//

//

//

import SwiftUI

struct ReviewPopupView: View {
    @Binding var isPresented: Bool
    @State private var rating: Int = 5
    @State private var reviewText: String = ""
    var onSubmit: (Int, String) -> Void

    var body: some View {
        ZStack {

            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {}

                VStack(spacing: 24) {

                    Text("WRITE A REVIEW")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.top, 8)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Score:")
                            .foregroundColor(.secondary)

                        HStack(spacing: 8) {
                            ForEach(1...5, id: \.self) { star in
                                Image(systemName: star <= rating ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .onTapGesture {
                                        rating = star
                                    }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Review:")
                            .foregroundColor(.secondary)

                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $reviewText)
                                .frame(height: 100)
                                .padding(4)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color(.systemGray4), lineWidth: 1)
                                )

                            if reviewText.isEmpty {
                                Text("Excellent Service!")
                                    .foregroundColor(.gray.opacity(0.5))
                                    .padding(.top, 8)
                                    .padding(.leading, 8)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    HStack(spacing: 12) {
                        Button("Cancel") {
                            isPresented = false
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.blue, lineWidth: 1)
                        )

                        Button("Post") {
                            onSubmit(rating, reviewText)
                            isPresented = false
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                .padding(24)
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal, 40)
                .shadow(radius: 10)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isPresented)
    }
}

struct ReviewPopupExample: View {

    // MARK: Internal

    var body: some View {
        ZStack {

            VStack {
                Button("Show Review Popup") {
                    showReview = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }

            ReviewPopupView(isPresented: $showReview) { rating, review in
                print("Rating: \(rating), Review: \(review)")

            }
        }
    }

    // MARK: Private

    @State private var showReview = false

}
