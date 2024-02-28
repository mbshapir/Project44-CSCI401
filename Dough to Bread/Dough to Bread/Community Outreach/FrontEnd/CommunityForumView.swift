//
//  CommunityForumView.swift
//  Dough to Bread
//
//  Created by Matthew Shapiro on 2/4/24.
//

import SwiftUI
import Firebase

struct CommunityForumView: View {
    @ObservedObject var viewModel = CommunityForum()
    
    var body: some View {
        NavigationView {
            List(viewModel.messages) { message in
                VStack(alignment: .leading) {
                    Text(message.text)
                        .padding()
                    Text(message.timestamp, style: .time)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .navigationBarTitle("Community Forum")
            .onAppear() {
                self.viewModel.fetchMessages()
            }
        }
    }
}

struct Message: Identifiable {
    let id: String
    let text: String
    let timestamp: Date
}

class ForumViewModel: ObservableObject {
    @Published var messages = [Message]()
    
    private var db = Firestore.firestore()
    
    func fetchMessages() {
        db.collection("communityMessages").order(by: "timestamp", descending: true).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.messages = documents.map { queryDocumentSnapshot -> Message in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let text = data["text"] as? String ?? ""
                let timestamp = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                return Message(id: id, text: text, timestamp: timestamp)
            }
        }
    }
    
    func sendMessage(text: String) {
        let newMessage = db.collection("communityMessages").document()
        newMessage.setData(["text": text, "timestamp": Timestamp(date: Date())])
    }
}

struct CommunityForumPage_Previews: PreviewProvider {
    static var previews: some View {
        CommunityForumView()
    }
}
