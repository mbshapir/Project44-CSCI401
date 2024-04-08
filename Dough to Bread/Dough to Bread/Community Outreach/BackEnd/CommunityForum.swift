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
    @Published var errorMessage: String? //track error message state
    
    private var dbRef: DatabaseReference
    
    let badWords: Set<String> = ["fuck", "shit", "bitch", "kys", "damn", "bullshit", "whore", "wanker", "motherfuck", "motherfucker", "dickhead"] // library of bad words

    
    init() {
        self.dbRef = Database.database().reference(withPath: "communityMessages")
        fetchMessages()
    }
    
    func fetchMessages() {
        dbRef.queryOrdered(byChild: "timestamp").observe(.value, with: { snapshot in
            var newMessages: [Message] = []
            let group = DispatchGroup() // Use a dispatch group to handle asynchronous fetching of replies

            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let value = snapshot.value as? [String: AnyObject],
                   let text = value["text"] as? String,
                   let timestamp = value["timestamp"] as? Double {
                    let id = snapshot.key
                    var message = Message(id: id, text: text, timestamp: Date(timeIntervalSince1970: timestamp))

                    // Check if the message has replies
                    if let repliesSnapshot = value["replies"] as? [String: AnyObject] {
                        group.enter() // Enter the group before fetching replies
                        var replies: [Message] = []
                        for (replyId, replyValue) in repliesSnapshot {
                            if let replyDict = replyValue as? [String: AnyObject],
                               let replyText = replyDict["text"] as? String,
                               let replyTimestamp = replyDict["timestamp"] as? Double {
                                let reply = Message(id: replyId, text: replyText, timestamp: Date(timeIntervalSince1970: replyTimestamp))
                                replies.append(reply)
                            }
                        }
                        message.replies = replies
                        group.leave() // Leave the group after fetching replies
                    }

                    newMessages.append(message)
                }
            }
            
            group.notify(queue: .main) {
                self.messages = newMessages.reversed() // Update messages once all replies are fetched
            }
        })
    }

    func containsBadWords(_ text: String) -> Bool {
        let words = text.lowercased().split(separator: " ").map(String.init)
        return words.contains(where: { badWords.contains($0) })
    }
    
    func sendMessage(_ messageText: String) {
        // Check if the message text is empty
        guard !messageText.isEmpty else {
            self.errorMessage = "Error: Message text is empty"
            return
        }
        
        guard !containsBadWords(messageText) else{
            self.errorMessage = "Error: Cannot Upload Vulgar Message"
            return
        }
        
        let newMessageRef = dbRef.childByAutoId()
        let newMessageData: [String: Any] = [
            "text": messageText,
            "timestamp": Date().timeIntervalSince1970
        ]
        newMessageRef.setValue(newMessageData)
    }
    
    
    func sendReply(to messageId: String, replyText: String) {
        guard !replyText.isEmpty else {
            self.errorMessage = "Error: Reply text is empty"
            return
        }
        
        guard !containsBadWords(replyText) else{
            self.errorMessage = "Error: Cannot Upload Vulgar Reply"
            return
        }
        
        let replyRef = dbRef.child(messageId).child("replies").childByAutoId()
        let replyData: [String: Any] = [
            "text": replyText,
            "timestamp": Date().timeIntervalSince1970
        ]
        replyRef.setValue(replyData)
    }
}


struct Message: Identifiable {
    var id: String
    var text: String
    var timestamp: Date
    var replies: [Message] = [] //same structure as og messages for replies
}


