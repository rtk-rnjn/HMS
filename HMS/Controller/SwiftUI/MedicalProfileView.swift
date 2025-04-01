import SwiftUI

struct MedicalProfileView: View {

    // MARK: Lifecycle

    init(patient: Binding<Patient?>, onComplete: (() -> Void)? = nil) {
        _patient = patient
        self.onComplete = onComplete
        // Initialize state with patient data if available
        if let patient = patient.wrappedValue {
            _selectedBloodGroup = State(initialValue: patient.bloodGroup)
            _height = State(initialValue: patient.height > 0 ? String(patient.height) : "")
            _weight = State(initialValue: patient.weight > 0 ? String(patient.weight) : "")
            _allergies = State(initialValue: patient.allergies.joined(separator: ", "))
            _disorders = State(initialValue: patient.disorders?.joined(separator: ", ") ?? "")
        }
    }

    // MARK: Internal

    @Binding var patient: Patient?

    var onComplete: (() -> Void)?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 40) {
                // Blood Type Section
                VStack(alignment: .leading, spacing: 20) {
                    Text("Blood Type")
                        .font(.system(size: 20, weight: .semibold))

                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(orderedBloodGroups, id: \.self) { group in
                            Button(action: {
                                selectedBloodGroup = group
                            }) {
                                Text(group.rawValue)
                                    .font(.system(.body, design: .rounded))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 48)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(selectedBloodGroup == group ? Color.blue : Color(.systemGray6))
                                    )
                                    .foregroundColor(selectedBloodGroup == group ? .white : .primary)
                            }
                        }
                    }
                }

                // Height Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Height")
                        .font(.system(size: 20, weight: .semibold))

                    HStack {
                        TextField("Enter your height", text: $height)
                            .keyboardType(.numberPad)
                            .font(.system(.body))
                        Text("cm")
                            .foregroundColor(.secondary)
                            .font(.system(.body))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                }

                // Weight Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Weight")
                        .font(.system(size: 20, weight: .semibold))

                    HStack {
                        TextField("Enter your weight", text: $weight)
                            .keyboardType(.numberPad)
                            .font(.system(.body))
                        Text("kg")
                            .foregroundColor(.secondary)
                            .font(.system(.body))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                }

                // Allergies Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Allergies (Optional)")
                        .font(.system(size: 20, weight: .semibold))

                    ZStack(alignment: .topLeading) {
                        if allergies.isEmpty {
                            Text("List any allergies you have, separated by commas")
                                .foregroundColor(Color(.placeholderText))
                                .font(.system(.body))
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                        }
                        TextEditor(text: $allergies)
                            .frame(height: 120)
                            .scrollContentBackground(.hidden)
                            .background(Color(.systemGray6))
                            .cornerRadius(16)
                            .padding(.horizontal, 4)
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                }

                // Disorders Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Disorders (Optional)")
                        .font(.system(size: 20, weight: .semibold))

                    ZStack(alignment: .topLeading) {
                        if disorders.isEmpty {
                            Text("List any disorders or chronic conditions, separated by commas")
                                .foregroundColor(Color(.placeholderText))
                                .font(.system(.body))
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                        }
                        TextEditor(text: $disorders)
                            .frame(height: 120)
                            .scrollContentBackground(.hidden)
                            .background(Color(.systemGray6))
                            .cornerRadius(16)
                            .padding(.horizontal, 4)
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                }
            }
            .padding(24)
        }
        .navigationTitle("Medical Profile")
        .navigationBarTitleDisplayMode(.large)
        .safeAreaInset(edge: .bottom) {
            Button(action: {
                if var patient {
                    patient.bloodGroup = selectedBloodGroup ?? .aNegative
                    patient.height = Int(height) ?? 0
                    patient.weight = Int(weight) ?? 0
                    patient.allergies = allergies.isEmpty ? [] : allergies.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                    patient.disorders = disorders.isEmpty ? nil : disorders.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                    self.patient = patient

                    // Call the completion handler only
                    onComplete?()
                }
            }) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(16)
            }
            .padding(24)
            .background(Color.white)
        }
    }

    // MARK: Private

    @Environment(\.dismiss) private var dismiss

    @State private var selectedBloodGroup: BloodGroup?
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var allergies: String = ""
    @State private var disorders: String = ""

    // Define the order of blood groups to match the screenshot
    private let orderedBloodGroups: [BloodGroup] = [
        .aPositive, .aNegative, .bPositive,
        .bNegative, .abPositive, .abNegative,
        .oPositive, .oNegative, .oh,
        .na
    ]

    // Create columns for the blood group grid
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

}
