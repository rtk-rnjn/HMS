//
//  PaymentDetailView.swift
//  HMS
//
//  Created by RITIK RANJAN on 03/04/25.
//

import SwiftUI

struct PaymentDetailView: View {

    // MARK: Internal

    let invoice: RazorpayPaymentlinkResponse

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Payment Status Card
                PaymentStatusCard(invoice: invoice)
                    .opacity(showStatusCard ? 1 : 0)
                    .offset(y: showStatusCard ? 0 : 20)

                // Payment Details Section
                PaymentDetailsSection(invoice: invoice)
                    .opacity(showPaymentInfo ? 1 : 0)
                    .offset(y: showPaymentInfo ? 0 : 20)

                // Appointment Details Section
                AppointmentDetailsSection(invoice: invoice)
                    .opacity(showAppointmentInfo ? 1 : 0)
                    .offset(y: showAppointmentInfo ? 0 : 20)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Payment Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            animateContent()
        }
    }

    // MARK: Private

    @Environment(\.dismiss) private var dismiss

    // Animation states
    @State private var showStatusCard = false
    @State private var showPaymentInfo = false
    @State private var showAppointmentInfo = false

    // Haptic feedback generators
    @State private var impactFeedback: UIImpactFeedbackGenerator = .init(style: .medium)
    @State private var selectionFeedback: UISelectionFeedbackGenerator = .init()

    private func animateContent() {
        // Staggered animation for content appearance
        withAnimation(.easeOut(duration: 0.3)) {
            showStatusCard = true
        }

        withAnimation(.easeOut(duration: 0.3).delay(0.2)) {
            showPaymentInfo = true
        }

        withAnimation(.easeOut(duration: 0.3).delay(0.4)) {
            showAppointmentInfo = true
        }
    }
}

// Payment Status Card
struct PaymentStatusCard: View {

    // MARK: Internal

    let invoice: RazorpayPaymentlinkResponse

    var body: some View {
        VStack(spacing: 16) {
            // Status Icon with spring animation
            Circle()
                .fill(statusColor.opacity(0.1))
                .frame(width: 64, height: 64)
                .overlay(
                    Image(systemName: statusIcon)
                        .font(.title)
                        .foregroundColor(statusColor)
                        .scaleEffect(showAmount ? 1 : 0)
                        .rotationEffect(.degrees(showAmount ? 0 : -180))
                )
                .scaleEffect(isPressed ? 0.95 : 1.0)

            // Amount with fade animation
            Text(String(format: "₹%.2f", Double(invoice.amountPaid) / 100.0))
                .font(.largeTitle)
                .opacity(showAmount ? 1 : 0)
                .scaleEffect(showAmount ? 1 : 0.9)

            // Status with slide animation
            Text(invoice.payments.first?.status.capitalized ?? "Unknown")
                .font(.headline)
                .foregroundColor(statusColor)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(statusColor.opacity(0.1))
                .cornerRadius(20)
                .opacity(showStatus ? 1 : 0)
                .offset(y: showStatus ? 0 : 10)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                showAmount = true
            }
            withAnimation(.easeOut(duration: 0.3).delay(0.3)) {
                showStatus = true
            }
        }
    }

    // MARK: Private

    @State private var isPressed = false
    @State private var showAmount = false
    @State private var showStatus = false

    private var statusColor: Color {
        if invoice.payments.first?.status == "captured" {
            return Color("successBlue")
        } else if invoice.payments.first?.status == "refunded" {
            return Color("errorBlue")
        }
        return .gray
    }

    private var statusIcon: String {
        if invoice.payments.first?.status == "captured" {
            return "checkmark.circle.fill"
        } else if invoice.payments.first?.status == "refunded" {
            return "arrow.counterclockwise.circle.fill"
        }
        return "questionmark.circle.fill"
    }
}

// Payment Details Section
struct PaymentDetailsSection: View {

    // MARK: Internal

    let invoice: RazorpayPaymentlinkResponse

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Payment Information")
                .font(.headline)

            VStack(spacing: 16) {
                DetailRow(
                    title: "Payment ID",
                    value: "#\(invoice.id)",
                    isSelected: selectedRow == "Payment ID"
                )
                .onTapGesture { selectedRow = "Payment ID" }

                DetailRow(
                    title: "Date & Time",
                    value: invoice.createdAt.formatted(),
                    isSelected: selectedRow == "Date & Time"
                )
                .onTapGesture { selectedRow = "Date & Time" }

                DetailRow(
                    title: "Payment Method",
                    value: invoice.payments.first?.method.capitalized ?? "Unknown",
                    isSelected: selectedRow == "Payment Method"
                )
                .onTapGesture { selectedRow = "Payment Method" }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
    }

    // MARK: Private

    @State private var selectedRow: String?

}

// Appointment Details Section
struct AppointmentDetailsSection: View {

    // MARK: Internal

    let invoice: RazorpayPaymentlinkResponse

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Appointment Information")
                .font(.headline)

            VStack(spacing: 16) {
                DetailRow(
                    title: "Doctor ID",
                    value: invoice.notes.doctorId,
                    isSelected: selectedRow == "Doctor ID"
                )
                .onTapGesture { selectedRow = "Doctor ID" }

                DetailRow(
                    title: "Patient ID",
                    value: invoice.notes.patientId,
                    isSelected: selectedRow == "Patient ID"
                )
                .onTapGesture { selectedRow = "Patient ID" }

                DetailRow(
                    title: "Start Time",
                    value: invoice.notes.startDate.formatted(),
                    isSelected: selectedRow == "Start Time"
                )
                .onTapGesture { selectedRow = "Start Time" }

                DetailRow(
                    title: "End Time",
                    value: invoice.notes.endDate.formatted(),
                    isSelected: selectedRow == "End Time"
                )
                .onTapGesture { selectedRow = "End Time" }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
    }

    // MARK: Private

    @State private var selectedRow: String?

}

// Detail Row Component
struct DetailRow: View {
    let title: String
    let value: String
    var isSelected: Bool

    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(width: 100, alignment: .leading)

            Text(value)
                .font(.subheadline)
                .multilineTextAlignment(.leading)

            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, isSelected ? 8 : 0)
        .background(isSelected ? Color.blue.opacity(0.1) : Color.clear)
        .cornerRadius(8)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}
