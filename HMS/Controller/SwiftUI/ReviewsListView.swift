import SwiftUI

struct ReviewsListView: View {

    // MARK: Internal

    let doctor: Staff

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(sortedReviews) { review in
                    ReviewRow(review: review)
                }
            }
            .padding(.vertical)
        }
        .background(Color(.systemGray6))
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Reviews")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: { sortOrder = .highest }) {
                        Label("Highest Rating", systemImage: "star.fill")
                    }
                    Button(action: { sortOrder = .lowest }) {
                        Label("Lowest Rating", systemImage: "star")
                    }
                    if sortOrder != .none {
                        Button(action: { sortOrder = .none }) {
                            Label("Clear Filter", systemImage: "xmark.circle")
                        }
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                        .foregroundColor(.primary)
                }
            }
        }
    }

    // MARK: Private

    @Environment(\.dismiss) private var dismiss
    @State private var reviews: [Review] = []

    @State private var sortOrder: SortOrder = .none

    private var sortedReviews: [Review] {
        switch sortOrder {
        case .highest:
            return reviews.sorted { $0.stars > $1.stars }
        case .lowest:
            return reviews.sorted { $0.stars < $1.stars }
        case .none:
            return reviews
        }
    }

}

enum SortOrder {
    case highest
    case lowest
    case none
}

struct ReviewRow: View {
    let review: Review

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(review.patientId)
                    .font(.callout)
                    .foregroundColor(.primary)

                Spacer()

                Text(review.createdAt.formatted(date: .numeric, time: .omitted))
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }

            Text(review.review)
                .font(.footnote)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 4) {
                Text(String(format: "%.1f", review.stars))
                    .font(.callout)
                    .foregroundColor(.primary)
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
