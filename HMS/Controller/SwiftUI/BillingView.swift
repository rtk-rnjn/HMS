//
//  BillingView.swift
//  HMS
//
//  Created by RITIK RANJAN on 03/04/25.
//

import SwiftUI

struct BillingView: View {

    // MARK: Internal

    weak var delegate: BillingHostingController?
    var invoices: [RazorpayPaymentlinkResponse] = []

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack {
                    Text("Recent Payments")
                        .font(.headline)
                        .fontWeight(.semibold)

                    Spacer()
                }
                .padding(.horizontal)

                // Invoice List
                LazyVStack(spacing: 12) {
                    ForEach(invoices) { invoice in
                        InvoiceCard(invoice: invoice)
                            .padding(.horizontal)
                            .onTapGesture {
                                // Trigger haptic feedback
                                impactFeedback.prepare()
                                impactFeedback.impactOccurred(intensity: 0.5)
                                selectedInvoice = invoice
                            }
                    }
                }
                .padding(.bottom)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Billing")
        .navigationBarTitleDisplayMode(.large)
        .sheet(item: $selectedInvoice) { invoice in
            NavigationView {
                PaymentDetailView(invoice: invoice)
            }
        }
    }

    // MARK: Private

    @State private var selectedInvoice: RazorpayPaymentlinkResponse?

    // Haptic feedback generator
    @State private var impactFeedback: UIImpactFeedbackGenerator = .init(style: .medium)

    private var totalRevenue: Double {
        invoices.filter { $0.payments.first?.status == "captured" }
            .reduce(0) { $0 + Double($1.amountPaid) / 100.0 }
    }

    private var totalRefunds: Double {
        abs(invoices.filter { $0.payments.first?.status == "refunded" }
            .reduce(0) { $0 + Double($1.amountPaid) / 100.0 })
    }

    // Summary Cards View
    private var summaryCardsView: some View {
        HStack(spacing: 15) {
            // Total Revenue Card
            SummaryCardView(
                title: "Total Revenue",
                amount: totalRevenue,
                icon: "indianrupee.circle.fill",
                color: .blue
            )

            // Total Refunds Card
            SummaryCardView(
                title: "Total Refunds",
                amount: totalRefunds,
                icon: "arrow.counterclockwise.circle.fill",
                color: .red
            )
        }
        .padding(.horizontal)
        .padding(.top, 5)
    }
}

// Summary Card View
struct SummaryCardView: View {
    let title: String
    let amount: Double
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Card Header with icon
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)

                Spacer()
            }

            Spacer()

            // Amount
            Text(String(format: "₹%.2f", amount))
                .font(.title2)
                .fontWeight(.bold)

            // Title
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(height: 140)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct InvoiceCard: View {
    let invoice: RazorpayPaymentlinkResponse

    var body: some View {
        HStack(spacing: 16) {
            // Wallet Icon
            Image(systemName: "wallet.pass.fill")
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 40, height: 40)
                .background(Color.blue.opacity(0.1))
                .clipShape(Circle())

            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text("Appointment Done #\(invoice.id)")
                    .font(.body)

                Text(invoice.createdAt.formatted(date: .omitted, time: .shortened))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Amount and Status
            VStack(alignment: .trailing, spacing: 4) {
                Text(String(format: "₹%.2f", Double(invoice.amountPaid) / 100.0))
                    .font(.body)

                Text(invoice.payments.first?.status == "captured" ? "Completed" : "Refunded")
                    .font(.subheadline)
                    .foregroundColor(invoice.payments.first?.status == "captured" ? .green : .red)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Sample Data
extension BillingView {
    static let sampleInvoices: [RazorpayPaymentlinkResponse] = [
        RazorpayPaymentlinkResponse(
            id: "pay_123456",
            amountPaid: 45800, // ₹458.00
            notes: RazorpayNotes(
                doctorId: "doc_1",
                patientId: "pat_1",
                endDate: Date(),
                startDate: Date()
            ),
            payments: [
                RazorpayPayment(
                    amount: 45800,
                    createdAt: Date().timeIntervalSince1970,
                    method: "card",
                    status: "captured"
                )
            ],
            _createdAt: Date().timeIntervalSince1970
        ),
        RazorpayPaymentlinkResponse(
            id: "pay_123458",
            amountPaid: 8900, // ₹89.00
            notes: RazorpayNotes(
                doctorId: "doc_3",
                patientId: "pat_3",
                endDate: Date(),
                startDate: Date()
            ),
            payments: [
                RazorpayPayment(
                    amount: 8900,
                    createdAt: Date().timeIntervalSince1970,
                    method: "card",
                    status: "refunded"
                )
            ],
            _createdAt: Date().timeIntervalSince1970 - 7200 // 2 hours ago
        ),
        RazorpayPaymentlinkResponse(
            id: "pay_123459",
            amountPaid: 6500, // ₹65.00
            notes: RazorpayNotes(
                doctorId: "doc_4",
                patientId: "pat_4",
                endDate: Date(),
                startDate: Date()
            ),
            payments: [
                RazorpayPayment(
                    amount: 6500,
                    createdAt: Date().timeIntervalSince1970,
                    method: "card",
                    status: "captured"
                )
            ],
            _createdAt: Date().timeIntervalSince1970 - 10800 // 3 hours ago
        )
    ]
}
