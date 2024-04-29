//
//  CommunityForumView.swift
//  Dough to Bread
//
//  Created by Matthew Shapiro on 2/4/24.
//

import SwiftUI
import Firebase

struct CommunityForumView: View {
    @ObservedObject var viewModel = ForumViewModel()
    @State private var newMessageText = ""
    @State private var replyTexts: [String: String] = [:] // To store replies text for each message
    @State private var expandedMessageID: String? // To track which message's replies are shown
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false

    var body: some View {
        VStack(spacing: 0) {
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

                Text("Community Forum")
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

            VStack {
                List {
                    ForEach(viewModel.messages, id: \.id) { message in
                        MessageView(message: message,
                                    replyText: Binding<String>(
                                        get: { self.replyTexts[message.id] ?? "" },
                                        set: { self.replyTexts[message.id] = $0 }
                                    ),
                                    expandedMessageID: $expandedMessageID,
                                    sendMessage: viewModel.sendMessage,
                                    sendReply: { replyText in
                                        viewModel.sendReply(to: message.id, replyText: replyText)
                                        self.replyTexts[message.id] = "" // Clear reply text field after sending
                                    })
                    }

                }
                .listStyle(PlainListStyle()) // Optional: Removes list row separators
                
                HStack {
                    TextField("Enter your message here", text: $newMessageText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.custom("Poppins-SemiBold", size: 20))
                        .foregroundColor(.blue)
                        .padding(6)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: "000000"), lineWidth: 2)
                        )
                    
                    Button(action: {
                        viewModel.sendMessage(newMessageText)
                        newMessageText = ""
                    }) {
                        Text("Send")
                            .font(.custom("Poppins-SemiBold", size: 26))
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(hex: "000000"), lineWidth: 2)
                            )
                    }
                }
                .padding()
                .background(Color(hex: "597836"))
            }
            .onAppear() {
                self.viewModel.fetchMessages()
            }
        }
        .alert("Error", isPresented: $showAlert, presenting: viewModel.errorMessage) { errorMessage in
            Button("OK") {
                // Action when OK is pressed
                viewModel.errorMessage = nil // Clear error message after showing alert
            }
        } message: { errorMessage in
            Text(errorMessage)
        }
        .onChange(of: viewModel.errorMessage) {
            showAlert = viewModel.errorMessage != nil
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
}

struct MessageView: View {
    var message: Message
    @Binding var replyText: String
    @Binding var expandedMessageID: String?
    var sendMessage: (String) -> Void
    var sendReply: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(message.text)
                .padding()
                .font(.custom("Poppins-SemiBold", size: 20))
            Text("\(message.timestamp, style: .date) @ \(message.timestamp, style: .time)")
                .font(.custom("Poppins-SemiBold", size: 13))
                .foregroundColor(.gray)
            Button(action: {
                // Toggle the visibility of the replies
                expandedMessageID = (expandedMessageID == message.id) ? nil : message.id
            }) {
                Text("Reply (\(message.replies.count))")
                    .foregroundColor(.blue)
                    .font(.custom("Poppins-SemiBold", size: 13))
                    .padding(3)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color(hex: "000000"), lineWidth: 1.25)
                    )
            }
            .buttonStyle(PlainButtonStyle())
            // Display replies if this message's replies are expanded
            if expandedMessageID == message.id {
                TextField("Enter your reply here", text: $replyText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .padding()
                Button("Send Reply") {
                    sendReply(replyText)
                }
                .foregroundColor(.blue)
                .font(.custom("Poppins-SemiBold", size: 13))
                .padding(3)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(hex: "000000"), lineWidth: 2)
                )
                .buttonStyle(PlainButtonStyle())
                
                ForEach(message.replies.sorted(by: { $0.timestamp > $1.timestamp }), id: \.id) { reply in
                    VStack(alignment: .leading) {
                        Text(reply.text)
                            .font(.custom("Poppins-SemiBold", size: 16))
                            .padding([.leading, .top])
                            .offset(x: 20, y: 0)
                        Text("\(reply.timestamp, style: .date) @ \(reply.timestamp, style: .time)")
                            .font(.custom("Poppins-SemiBold", size: 12))
                            .foregroundColor(.gray)
                            .offset(x: 37, y: 0)
                    }
                }
            }
        }
    }
}

struct CommunityForumView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityForumView()
    }
}

