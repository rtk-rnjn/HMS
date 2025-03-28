//
//  AppointmentView.swift
//  HMS
//
//  Created by RITIK RANJAN on 28/03/25.
//

import SwiftUI

struct AppointmentView: View {
    weak var delegate: AppointmentHostingController?

    var appointments: [Appointment] = []
    @State private var currentDate: Date = Date()
    
    var body: some View {
        ScrollViewReader { scrollView in
            List {
                ForEach(sortedDates, id: \..self) { date in
                    Section(header: headerView(for: date)) {
                        appointmentList(for: date)
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if let today = sortedDates.first(where: { Calendar.current.isDate($0, inSameDayAs: currentDate) }) {
                        scrollView.scrollTo(today, anchor: .top)
                    }
                }
            }
        }
    }

    private func appointmentList(for date: Date) -> some View {
        ForEach(groupedAppointments[date] ?? []) { appointment in
            AppointmentRow(appointment: appointment, isPast: date < Calendar.current.startOfDay(for: currentDate))
                .id(appointment.id)
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }

    private var groupedAppointments: [Date: [Appointment]] {
        Dictionary(grouping: appointments, by: { Calendar.current.startOfDay(for: $0.date) })
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

}

struct AppointmentRow: View {
    var appointment: Appointment
    var isPast: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(appointment.reason)
                .font(.headline)
            Text(appointment.doctorName ?? "Unknown Doctor")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(appointment.date, style: .time)
                .font(.caption)
                .foregroundColor(.blue)
        }
        .padding(.vertical, 8)
        .opacity(isPast ? 0.5 : 1.0)
    }
}
