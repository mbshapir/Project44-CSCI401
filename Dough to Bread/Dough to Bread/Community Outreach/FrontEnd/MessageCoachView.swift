//
//  MessageCoachView.swift
//  Dough to Bread
//
//  Created by Matthew Shapiro on 2/4/24.
//

import SwiftUI

struct MessageCoachView: View {
    @ObservedObject var viewModel = MessageCoach() // Adjusted for clarity; ensure it matches your ViewModel
    @State private var subject = ""
    @State private var message = ""
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.black)
                        .padding(.all, 12)
                        .font(.system(size: 16))
                }
                .background(Color(hex: "597836"))
                .clipShape(Circle())
                .padding(.leading)

                Text("Message Coach")
                    .font(.custom("Poppins-SemiBold", size: 32))
                    .foregroundColor(Color.white)
                    .padding(.horizontal)
                    .background(Color(hex: "597836"))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(hex: "000000"), lineWidth: 2)
                    )
            }
            .offset(x: -10, y: 0)
            .padding(.top, 0)
            .padding(.bottom)

            // Input fields and Submit button
            VStack(spacing: 20) {
                TextField("Subject", text: $subject)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.custom("Poppins-SemiBold", size: 20))
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(hex: "000000"), lineWidth: 2)
                    )

                TextEditor(text: $message)
                    .font(.custom("Poppins-SemiBold", size: 20))
                    .padding()
                    .frame(height: 200)
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(hex: "000000"), lineWidth: 2)
                    )

                Button("Submit") {
                    submitMessage()
                }
                .font(.custom("Poppins-SemiBold", size: 26))
                .padding()
                .foregroundColor(.white)
                .background(Color(hex: "597836"))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(hex: "000000"), lineWidth: 2)
                )
            }
            .padding()
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }

    private func submitMessage() {
        if canSendMessageToday() {
            guard !subject.trimmingCharacters(in: .whitespaces).isEmpty && !message.trimmingCharacters(in: .whitespaces).isEmpty else {
                alertTitle = "Empty Fields"
                alertMessage = "Please enter both a subject and a message before submitting."
                showingAlert = true
                return
            }
            
            viewModel.submitMessage(subject: subject, message: message) { success in
                if success {
                    alertTitle = "Success"
                    alertMessage = "Your message has been sent successfully."
                    incrementMessageCount()
                    subject = ""
                    message = ""
                } else {
                    alertTitle = "Error"
                    alertMessage = "There was a problem sending your message. Please try again."
                }
                showingAlert = true
            }
        } else {
            alertTitle = "Message Limit Reached"
            alertMessage = "You can only send 5 messages per day."
            showingAlert = true
        }
    }

    private func canSendMessageToday() -> Bool {
        let userDefaults = UserDefaults.standard
        let today = Calendar.current.startOfDay(for: Date())
        let lastMessageDate = userDefaults.object(forKey: "lastMessageDate") as? Date ?? today
        let messageCount = userDefaults.integer(forKey: "messageCount")

        if Calendar.current.isDateInToday(lastMessageDate) {
            return messageCount < 5
        } else {
            userDefaults.set(0, forKey: "messageCount")
            userDefaults.set(today, forKey: "lastMessageDate")
            return true
        }
    }

    private func incrementMessageCount() {
        let userDefaults = UserDefaults.standard
        let messageCount = userDefaults.integer(forKey: "messageCount") + 1
        userDefaults.set(messageCount, forKey: "messageCount")
        if messageCount == 1 { // If it's the first message of the day, update the date
            userDefaults.set(Date(), forKey: "lastMessageDate")
        }
    }
}

struct MessageCoachView_Previews: PreviewProvider {
    static var previews: some View {
        MessageCoachView()
    }
}



