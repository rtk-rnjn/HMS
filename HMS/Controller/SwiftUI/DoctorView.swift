//
//  DoctorView.swift
//  HMS
//
//  Created by RITIK RANJAN on 28/03/25.
//

import SwiftUI

struct DoctorView: View {
    var doctor: Staff
    @State private var selectedDate: Date = Calendar.current.startOfDay(for: Date())
    @State private var selectedTimeSlot: String?
    @State private var isNewVisit = true
    @State private var additionalNotes = ""

    let now: Date = .init()

    var timeSlots: [[Date]] {
        let now = Date()
        return [
            [9, 10].map { now.addingTimeInterval(60 * 60 * Double($0)) },
            [13, 14].map { now.addingTimeInterval(60 * 60 * Double($0)) },
            [17, 18].map { now.addingTimeInterval(60 * 60 * Double($0)) }
        ]
    }

    // Custom colors to maintain consistency
    let customBlue: Color = .init(red: 0.27, green: 0.45, blue: 1.0) // Matches the profile section blue

    // Get next 14 days
    var dates: [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return (0..<14).compactMap { day in
            calendar.date(byAdding: .day, value: day, to: today)
        }
    }

    // Format date components
    func getDateComponents(_ date: Date) -> (weekday: String, day: String) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")

        formatter.dateFormat = "EEE"
        let weekday = formatter.string(from: date).prefix(1).uppercased()

        formatter.dateFormat = "d"
        let day = formatter.string(from: date)

        return (weekday, day)
    }

    var body: some View {
        ScrollView {
            VStack {
                // Doctor Profile Section
                VStack(spacing: 12) {
                    // Profile Card
                    VStack(spacing: 8) {
                        ZStack(alignment: .bottomTrailing) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .foregroundColor(Color(UIColor.systemGray4))

                            Circle()
                                .fill(Color.blue)
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Image(systemName: "camera.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: 16))
                                )
                        }
                        .padding(.bottom, 4)

                        Text(doctor.fullName)
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text(doctor.specialization)
                            .font(.body)
                            .foregroundColor(.blue)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)

                    // Stats Section
                    HStack {
                        Spacer()
                        VStack(spacing: 8) {
                            Image(systemName: "person.3.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.blue)
                            Text("0")
                                .font(.title3)
                                .fontWeight(.bold)
                            Text("Patients")
                                .font(.subheadline)
                                .foregroundColor(Color(UIColor.systemGray))
                        }
                        Spacer()
                        Divider()
                            .frame(height: 40)
                        Spacer()
                        VStack(spacing: 8) {
                            Image(systemName: "clock.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.blue)
                            Text("\(doctor.yearOfExperience) yrs")
                                .font(.title3)
                                .fontWeight(.bold)
                            Text("Experience")
                                .font(.subheadline)
                                .foregroundColor(Color(UIColor.systemGray))
                        }
                        Spacer()
                        Divider()
                            .frame(height: 40)
                        Spacer()
                        VStack(spacing: 8) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.blue)
                            Text("4.8")
                                .font(.title3)
                                .fontWeight(.bold)
                            Text("Rating")
                                .font(.subheadline)
                                .foregroundColor(Color(UIColor.systemGray))
                        }
                        Spacer()
                    }
                    .padding(.vertical, 20)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                }
                .padding(.horizontal)

                // Date Selection
                VStack(alignment: .leading, spacing: 12) {
                    Text("Select Date")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.horizontal)

                    // Calendar View
                    ScrollView(.horizontal, showsIndicators: false) {
                        VStack(spacing: 10) {
                            // Weekday headers
                            HStack(spacing: 0) {
                                ForEach(dates, id: \.self) { date in
                                    let components = getDateComponents(date)
                                    Text(components.weekday)
                                        .font(.system(size: 15))
                                        .foregroundColor(Color(UIColor.systemGray))
                                        .frame(width: 45)
                                }
                            }

                            // Date buttons
                            HStack(spacing: 0) {
                                ForEach(dates, id: \.self) { date in
                                    let components = getDateComponents(date)
                                    Button(action: {
                                        selectedDate = date
                                    }) {
                                        Text(components.day)
                                            .font(.system(size: 20))
                                            .frame(width: 40, height: 40)
                                            .background(
                                                Circle()
                                                    .fill(Calendar.current.isDate(selectedDate, inSameDayAs: date) ? customBlue : Color.clear)
                                            )
                                            .foregroundColor(Calendar.current.isDate(selectedDate, inSameDayAs: date) ? .white : .primary)
                                    }
                                    .frame(width: 45)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                // Time Slots
                VStack(alignment: .leading) {
                    Text("Available Time Slots")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            Text("HELP ME")
                        }
                        .padding(.horizontal)
                    }
                }

                // Visit Type
                VStack(alignment: .leading) {
                    Text("Visit Type")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.horizontal)

                    VStack(spacing: 10) {
                        Button(action: {
                            isNewVisit = true
                        }) {
                            HStack {
                                Image(systemName: isNewVisit ? "largecircle.fill.circle" : "circle")
                                    .foregroundColor(customBlue)
                                Text("New Visit")
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        }

                        Button(action: {
                            isNewVisit = false
                        }) {
                            HStack {
                                Image(systemName: !isNewVisit ? "largecircle.fill.circle" : "circle")
                                    .foregroundColor(customBlue)
                                Text("Follow-up")
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal)
                }

                // Additional Notes Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Additional Notes")
                        .font(.title3)
                        .foregroundColor(.primary)
                        .fontWeight(.semibold)

                    TextEditor(text: $additionalNotes)
                        .frame(height: 150)
                        .scrollContentBackground(.hidden)
                        .background(Color.white)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(UIColor.systemGray5), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                }
                .padding(.horizontal)

                // Continue Button
                Button(action: {
                    // Handle continue action
                }) {
                    Text("Continue")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(customBlue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.top)
            }
            .padding(.vertical)
        }
        .background(Color(UIColor.systemGray6))
    }
}
