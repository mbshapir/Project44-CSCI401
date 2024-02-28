//
//  CommunityForum.swift
//  Dough to Bread
//
//  Created by Matthew Shapiro on 2/17/24.
//

import Foundation
import Firebase

class CommunityForum: ObservableObject {
    @Published var messages = [ForumMessage]()
    
    private var db = Firestore.firestore()
    
    init() {
        self.fetchMessages()
    }
    
    func fetchMessages() {
        db.collection("forum").order(by: "timestamp", descending: false)
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                self.messages = documents.map { queryDocumentSnapshot -> ForumMessage in
                    let data = queryDocumentSnapshot.data()
                    let timestamp = data["timestamp"] as? Timestamp
                    let text = data["text"] as? String ?? ""
                    let date = timestamp?.dateValue() ?? Date()
                    return ForumMessage(id: queryDocumentSnapshot.documentID, text: text, timestamp: date)
                }
            }
    }
    
    func sendMessage(_ messageText: String) {
        let newMessage = ForumMessage(text: messageText, timestamp: Date())
        var ref: DocumentReference? = nil
        ref = db.collection("forum").addDocument(data: [
            "text": newMessage.text,
            "timestamp": newMessage.timestamp
        ]) { error in
            if let err = error {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
}

struct ForumMessage: Identifiable {
    var id: String = UUID().uuidString
    var text: String
    var timestamp: Date
}
