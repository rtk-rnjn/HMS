//
//  AppointmentView.swift
//  HMS
//
//  Created by RITIK RANJAN on 28/03/25.
//

import SwiftUI

struct AppointmentView: View {

    // MARK: Internal

    weak var delegate: AppointmentHostingController?

    var appointments: [Appointment] = []

    var body: some View {
        ScrollViewReader { scrollView in
            List {
                ForEach(sortedDates, id: \..self) { date in
                    Section(header: headerView(for: date)) {
                        ForEach(groupedAppointments[date] ?? [], id: \.id) { appointment in
                            AppointmentCard(appointment: appointment)
                                .onTapGesture {
                                    delegate?.showAppointmentDetails(appointment)
                                }
                        }
                    }
                }
            }
            .listRowSeparator(.hidden)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if let today = sortedDates.first(where: { Calendar.current.isDate($0, inSameDayAs: currentDate) }) {
                        scrollView.scrollTo(today, anchor: .top)
                    }
                }
            }
        }
    }

    // MARK: Private

    @State private var currentDate: Date = .init()

    private var groupedAppointments: [Date: [Appointment]] {
        Dictionary(grouping: appointments, by: { Calendar.current.startOfDay(for: $0.startDate) })
    }

    private var sortedDates: [Date] {
        groupedAppointments.keys.sorted()
    }

    private func headerView(for date: Date) -> some View {
        let isPast = date < Calendar.current.startOfDay(for: currentDate)
        return Text(formattedDate(date))
            .font(.headline)
            .foregroundColor(
                Calendar.current.isDate(date, inSameDayAs: currentDate) ? .red : (isPast ? .gray : .primary)
            )
            .fontWeight(Calendar.current.isDate(date, inSameDayAs: currentDate) ? .bold : .regular)
            .opacity(isPast ? 0.5 : 1.0)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
}

struct AppointmentRow: View {
    var appointment: Appointment
    var isPast: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(appointment.doctor?.fullName ?? "Unknown Doctor")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(appointment.startDate, style: .time)
                .font(.caption)
                .foregroundColor(.blue)
        }
        .padding(.vertical, 8)
        .opacity(isPast ? 0.5 : 1.0)
    }
}
