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
        NavigationView {
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
//            .background(Color(hex: "000000"))
            .navigationBarTitle("Community Forum", displayMode: .inline)
            
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                            .font(.system(size: 20))
                            .offset(x: 5, y: 16)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Community Forum")
                        .font(.custom("Poppins-SemiBold", size: 34))
                        .foregroundColor(Color.white)
                        .padding()
                        .background(Color(hex: "597836"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: "000000"), lineWidth: 2)
                        )
                        .padding(.top, 28)
                }
            }
            .onAppear() {
                self.viewModel.fetchMessages()
            }
        }
    }
}

struct CommunityForumView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityForumView()
    }
}
