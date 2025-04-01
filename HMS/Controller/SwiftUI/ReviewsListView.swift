import SwiftUI

struct ReviewsListView: View {
    let doctor: Staff
    @Environment(\.dismiss) private var dismiss
    @State private var reviews: [Review] = [
        Review(
            patientId: "1",
            patientName: "Patient 1",
            doctorId: "1",
            rating: 4.5,
            comment: "Dashing through the snow. On a one horse open sleigh. Over the hills we go, laughing all the way.",
            date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        ),
        Review(
            patientId: "2",
            patientName: "Patient 1",
            doctorId: "1",
            rating: 4.0,
            comment: "Dashing through the snow. On a one horse open sleigh. Over the hills we go, laughing all the way.",
            date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date()
        ),
        Review(
            patientId: "3",
            patientName: "Patient 1",
            doctorId: "1",
            rating: 4.5,
            comment: "Dashing through the snow. On a one horse open sleigh. Over the hills we go, laughing all the way.",
            date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date()
        ),
        Review(
            patientId: "4",
            patientName: "Patient 1",
            doctorId: "1",
            rating: 4.5,
            comment: "Dashing through the snow. On a one horse open sleigh. Over the hills we go, laughing all the way.",
            date: Calendar.current.date(byAdding: .day, value: -4, to: Date()) ?? Date()
        ),
        Review(
            patientId: "5",
            patientName: "Patient 1",
            doctorId: "1",
            rating: 4.5,
            comment: "Dashing through the snow. On a one horse open sleigh. Over the hills we go, laughing all the way.",
            date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date()
        )
    ]
    
    @State private var sortOrder: SortOrder = .none
    
    private var sortedReviews: [Review] {
        switch sortOrder {
        case .highest:
            return reviews.sorted { $0.rating > $1.rating }
        case .lowest:
            return reviews.sorted { $0.rating < $1.rating }
        case .none:
            return reviews
        }
    }
    
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
                Text(review.patientName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(review.date.formatted(date: .numeric, time: .omitted))
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            Text(review.comment)
                .font(.system(size: 15))
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            
            HStack(spacing: 4) {
                Text(String(format: "%.1f", review.rating))
                    .font(.system(size: 16, weight: .semibold))
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