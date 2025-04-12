//

//

//

import SwiftUI

struct DoctorView: View {
    var doctor: Staff

    @State private var selectedDate: Date = Calendar.current.startOfDay(for: Date())
    @State private var selectedTimeSlot: Date = .init()
    @State private var showingBookingSuccess = false
    @State private var reviews: [Review] = []
    @Environment(\.presentationMode) var presentationMode

    let now: Date = .init()

    func timeSlots() -> [Date] {
        guard let startWorkingHour = doctor.workingHours?.startTime,
              let endWorkingHour = doctor.workingHours?.endTime else {
            return []
        }

        let calendar = Calendar.current

        let startComponents = calendar.dateComponents([.hour, .minute], from: startWorkingHour)
        let endComponents = calendar.dateComponents([.hour, .minute], from: endWorkingHour)

        let startWorkingDate = calendar.date(bySettingHour: startComponents.hour ?? 0,
                                             minute: startComponents.minute ?? 0,
                                             second: 0,
                                             of: selectedDate) ?? selectedDate

        let endWorkingDate = calendar.date(bySettingHour: endComponents.hour ?? 0,
                                           minute: endComponents.minute ?? 0,
                                           second: 0,
                                           of: selectedDate) ?? selectedDate

        let bookedTime: Set<Date> = Set(doctor.appointments.map { $0.startDate })

        var availableSlots: [Date] = []
        var currentSlot = startWorkingDate

        while currentSlot < endWorkingDate {
            if !bookedTime.contains(currentSlot) {
                availableSlots.append(currentSlot)
            }
            currentSlot = calendar.date(byAdding: .minute, value: 60, to: currentSlot) ?? currentSlot
        }

        return availableSlots
    }

    let customBlue: Color = .init(red: 0.27, green: 0.45, blue: 1.0)

    var dates: [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return (0..<14).compactMap { day in
            calendar.date(byAdding: .day, value: day, to: today)
        }
    }

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

                VStack(spacing: 12) {

                    VStack(spacing: 8) {
                        ZStack(alignment: .bottomTrailing) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .foregroundColor(Color("iconBlue"))

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

                    HStack {
                        Spacer()
                        VStack(spacing: 8) {
                            Image(systemName: "person.3.fill")
                                .font(.title2)
                                .foregroundColor(Color("iconBlue"))
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
                                .font(.title2)
                                .foregroundColor(Color("iconBlue"))
                            Text("\(doctor.yearOfExperience) yrs")
                                .font(.title3)
                                .fontWeight(.bold)
                            Text("Experience")
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

                VStack(alignment: .leading, spacing: 12) {
                    Text("Select Date")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        VStack(spacing: 10) {

                            HStack(spacing: 0) {
                                ForEach(dates, id: \.self) { date in
                                    let components = getDateComponents(date)
                                    Text(components.weekday)
                                        .font(.subheadline)
                                        .foregroundColor(Color(UIColor.systemGray))
                                        .frame(width: 45)
                                }
                            }

                            HStack(spacing: 0) {
                                ForEach(dates, id: \.self) { date in
                                    let components = getDateComponents(date)
                                    Button(action: {
                                        selectedDate = date
                                        _ = timeSlots()
                                    }) {
                                        Text(components.day)
                                            .font(.title3)
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

                VStack(alignment: .leading) {
                    Text("Available Time Slots")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        prepareTimeSlots()
                    }
                }

                Button(action: {
                    Task {
                        let patient = DataController.shared.patient
                        let startDate = mergeDateAndTime(selectedDate: selectedDate, selectedTimeSlot: selectedTimeSlot)!
                        let appointment = Appointment(
                            patientId: patient?.id ?? "",
                            doctorId: doctor.id,
                            doctor: doctor,
                            startDate: startDate,
                            endDate: startDate.addingTimeInterval(60 * 60), _status: .cancelled
                        )

                        let shortURL = await DataController.shared.razorpayBookAppointment(appointment)
                        DispatchQueue.main.async {
                            guard let url = URL(string: shortURL) else {
                                fatalError()
                            }
                            UIApplication.shared.open(url)
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

    func prepareTimeSlots() -> some View {
        HStack(spacing: 12) {
            ForEach(timeSlots(), id: \.self) { timeSlot in
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
                .font(.callout)
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

                VStack(alignment: .leading, spacing: 4) {
                    Text(review.patientId)
                        .font(.callout)

                    Text(review.createdAt.formatted(date: .numeric, time: .omitted))
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }

                Spacer()

                HStack(spacing: 4) {
                    Text(String(format: "%.1f", review.stars))
                        .font(.callout)
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
            }

            Text(review.review)
                .font(.subheadline)
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
