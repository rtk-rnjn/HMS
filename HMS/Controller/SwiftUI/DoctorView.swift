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
    @State private var selectedTimeSlot: Date = .init()
    @State private var showingBookingSuccess = false
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
        )
    ]
    @Environment(\.presentationMode) var presentationMode

    let now: Date = .init()

    var timeSlots: [Date] {
        return [
            Calendar.current.date(bySettingHour: 11, minute: 0, second: 0, of: now)!,
            Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: now)!,
            Calendar.current.date(bySettingHour: 13, minute: 0, second: 0, of: now)!
        ]
    }

    // Custom colors to maintain consistency
    let customBlue: Color = .init(red: 0.27, green: 0.45, blue: 1.0) // Matches the profile section blue

    // Get next 14 days
    var dates: [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return (1..<15).compactMap { day in
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
                        prepareTimeSlots()
                    }
                }

                // Continue Button
                Button(action: {
                    Task {
                        let startDate = mergeDateAndTime(selectedDate: selectedDate, selectedTimeSlot: selectedTimeSlot)!
                        let appointment = Appointment(
                            patientId: "",
                            doctorId: doctor.id,
                            doctor: doctor,
                            startDate: startDate,
                            endDate: startDate.addingTimeInterval(60 * 60)
                        )

                        let created = await DataController.shared.bookAppointment(appointment)
                        if created {
                            DataController.createEvent(appointment: appointment)
                            showingBookingSuccess = true
                        } else {
                            print("Failed to book appointment")
                        }
                    }
                }) {
                    Text("Book Appointment")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(customBlue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.top)

                // Reviews Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Reviews")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        NavigationLink(destination: ReviewsListView(doctor: doctor)) {
                            Text("See All")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal)
                    
                    ForEach(reviews.prefix(3)) { review in
                        ReviewCard(review: review)
                    }
                }
                .padding(.top, 24)
            }
            .padding(.vertical)
        }
        .background(Color(UIColor.systemGray6))
        .alert("Booking Confirmed", isPresented: $showingBookingSuccess) {
            Button("OK") {
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("You have confirmed your booking")
        }
    }

    // Prepare time slots
    func prepareTimeSlots() -> some View {
        HStack(spacing: 12) {
            ForEach(timeSlots, id: \.self) { timeSlot in
                prepareTimeSlot(timeSlot: timeSlot)
            }
        }
        .padding(.horizontal)
    }

    func prepareTimeSlot(timeSlot: Date) -> some View {
        Button(action: {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            selectedTimeSlot = timeSlot
        }) {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"

            return Text(formatter.string(from: timeSlot))
                .font(.system(size: 16))
                .fontWeight(.semibold)
                .frame(width: 100, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(selectedTimeSlot == timeSlot ? customBlue : Color.white)
                )
                .foregroundColor(selectedTimeSlot == timeSlot ? .white : .primary)
        }
    }

    func mergeDateAndTime(selectedDate: Date, selectedTimeSlot: Date) -> Date? {
        let calendar = Calendar.current

        let dateComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: selectedTimeSlot)

        return calendar.date(from: DateComponents(
            year: dateComponents.year,
            month: dateComponents.month,
            day: dateComponents.day,
            hour: timeComponents.hour
        ))
    }
}

struct ReviewCard: View {
    let review: Review
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                // Patient name and date
                VStack(alignment: .leading, spacing: 4) {
                    Text(review.patientName)
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text(review.date.formatted(date: .numeric, time: .omitted))
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Rating
                HStack(spacing: 4) {
                    Text(String(format: "%.1f", review.rating))
                        .font(.system(size: 16, weight: .semibold))
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
            }
            
            // Review text
            Text(review.comment)
                .font(.system(size: 15))
                .foregroundColor(.secondary)
                .lineLimit(3)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .padding(.horizontal)
    }
}
