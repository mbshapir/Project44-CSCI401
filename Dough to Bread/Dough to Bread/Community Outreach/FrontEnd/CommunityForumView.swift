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
    @Environment(\.presentationMode) var presentationMode

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
                List(viewModel.messages) { message in
                    VStack(alignment: .leading) {
                        Text(message.text)
                            .padding()
                        Text(message.timestamp, style: .time)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
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
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
}

struct CommunityForumView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityForumView()
    }
}

