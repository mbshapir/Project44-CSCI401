//
//  CommunityForum.swift
//  Dough to Bread
//
//  Created by Matthew Shapiro on 2/17/24.
//

import Foundation
import Firebase

class ForumViewModel: ObservableObject {
    @Published var messages = [Message]()
    
    private var dbRef: DatabaseReference
    
    init() {
        self.dbRef = Database.database().reference(withPath: "communityMessages")
        fetchMessages()
    }
    
    func fetchMessages() {
        dbRef.queryOrdered(byChild: "timestamp").observe(.value, with: { snapshot in
            var newMessages: [Message] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let value = snapshot.value as? [String: AnyObject],
                   let text = value["text"] as? String,
                   let timestamp = value["timestamp"] as? Double {
                    let id = snapshot.key
                    let message = Message(id: id, text: text, timestamp: Date(timeIntervalSince1970: timestamp))
                    newMessages.append(message)
                }
            }
            self.messages = newMessages.reversed()
        })
    }
    
    func sendMessage(_ messageText: String) {
        // Check if the message text is empty
        guard !messageText.isEmpty else {
            print("Error: Message text is empty")
            return
        }
        
        let newMessageRef = dbRef.childByAutoId()
        let newMessageData: [String: Any] = [
            "text": messageText,
            "timestamp": Date().timeIntervalSince1970
        ]
        newMessageRef.setValue(newMessageData)
    }
}

struct Message: Identifiable {
    var id: String
    var text: String
    var timestamp: Date
}

