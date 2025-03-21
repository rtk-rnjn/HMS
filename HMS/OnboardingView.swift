//
//  OnboardingView.swift
//  HMS
//
//  Created by Dhruvi on 20/03/25.
//
import Foundation
import SwiftUI

struct PatientOnboardingItem {
    var imageName: String
    var title: String?
    var description: String
}

struct OnboardingView: View {
    weak var delegate: OnBoardingHostingController?

    private let onboardingData: [PatientOnboardingItem] = [
        .init(imageName: "patientWelcomeImage", title: "Your Health Simplified!", description: "Book appointments, track your medical records, and get health tips!"),
        .init(imageName: "patientDoctorSearchImage", title: nil, description: "Match Symptoms to Specialists!"),
        .init(imageName: "patientAppointmentImage", title: nil, description: "Book an Appointment With Just A Tap!"),
        .init(imageName: "patientRecordsImage", title: nil, description: "Store and View Your Medical Records!"),
        .init(imageName: "patientTipsImage", title: nil, description: "Stay Up-to-Date With All Alerts!")
        ]
    @State private var currentPageIndex: Int = 0
    @State private var isOnboardingComplete: Bool = false

    private var isLastPage: Bool {
        currentPageIndex == onboardingData.count - 1
    }

    var body: some View {
        NavigationStack {
            VStack {
                TabView(selection: $currentPageIndex) {
                    ForEach(onboardingData.indices, id: \.self) { index in
                        VStack {
                            Spacer()
                            if let title = onboardingData[index].title {
                                Text(title)
                                    .font(.title)
                                    .fontWeight(.bold)
                            }
                            Text(onboardingData[index].description)
                                .font(.title3)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.bottom, 20)

                            Image(onboardingData[index].imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)

                           .padding(.top, 10)
                           .allowsHitTesting(false)
                            Spacer()
                        }
                        .padding()
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                HStack {
                   ForEach(0..<onboardingData.count, id: \.self) { i in
                       Circle()
                           .frame(width: 8, height: 8)
                           .foregroundColor(i == currentPageIndex ? .blue : .gray.opacity(0.5))
                   }
               }.padding(.bottom)
            }
            // MARK: - Next and Get Started Button
            Button(action: {
                if isLastPage {
                    isOnboardingComplete = true
                } else {
                    withAnimation {
                        currentPageIndex += 1
                    }
                }
            }) {
                Text(isLastPage ? "Get Started!" : "Next")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.bottom, 40)
        }
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    isOnboardingComplete = true
                    delegate?.onboardingComplete()
                }) {
                    Text("Skip")
                        .foregroundColor(.blue)
                }
            }
        }
        .navigationDestination(isPresented: $isOnboardingComplete) {
       //     HelloScreen()
        }
    }
}
