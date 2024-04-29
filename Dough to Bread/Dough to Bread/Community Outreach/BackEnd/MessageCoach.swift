//
//  MessageCoach.swift
//  Dough to Bread
//
//  Created by Matthew Shapiro on 3/25/24.
//

import FirebaseDatabase

class MessageCoach: ObservableObject {
    private var ref: DatabaseReference = Database.database().reference()
    
    func submitMessage(subject: String, message: String, completion: @escaping (Bool) -> Void) {
        let messageRef = self.ref.child("coachMessages").childByAutoId()
        
        let submission = [
            "subject": subject,
            "message": message,
            "timestamp": ServerValue.timestamp()
        ] as [String : Any]
        
        messageRef.setValue(submission) { error, _ in
            if let error = error {
                print("Error submitting message: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Message submitted successfully.")
                completion(true)
            }
        }
    }
}



