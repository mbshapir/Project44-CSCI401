
import Foundation
import SwiftUI
import Firebase
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth

class AuthViewModel : UserModel, ObservableObject{
 
    

    @Published var user : Users
    var userImage: UIImage?
    
    
    func signIn(email em : String, password pw : String) async -> Bool {
        do {
            let userCredential = try await Auth.auth().signIn(withEmail: em, password: pw)
            let user = userCredential.user
            let backend = Database.database().reference()
            let userReference = backend.child("Users").child(user.uid)
            
            let _: Void = userReference.observeSingleEvent(of: .value, with: { snapshot in
                if snapshot.exists() {
                    if let userData = snapshot.value as? [String: Any] {
                        self.user.name = userData["name"] as! String
                        self.user.id = userData["id"] as! String
                        self.user.email = userData["email"] as! String
                        self.user.password = userData["password"] as! String
                        self.user.imageURL = userData["imageURL"] as! String
                    }
                    
                } else {
                    print("error.")
                }
                
                print(self.user.id)
                print(self.user.email)
                
            })
            //print(imageURL)
            
        } catch {
            print("Error: \(error.localizedDescription)")
            print("Error code: \((error as NSError).code)")
            print("Error domain: \((error as NSError).domain)")
            return true
        }
        
        return false
    }
    
    func CreateLogin(User user: Users) async throws -> Bool {
        print("New account being processed.")
        
        let backend = Database.database().reference()
        do {
            _ = try await Auth.auth().createUser(withEmail: user.email, password: user.password)
            let userUpdateData: [String: Any] = [
                "name": user.name,
                "email": user.email,
                "password": user.password,
                "id": user.id,
                "imageURL": user.imageURL
            ]
            if(user.name == "" && user.email == "" && user.password == ""){
                
                return false
            }
            _ = try await Auth.auth().signIn(withEmail: user.email, password: user.password)
            let userID = Auth.auth().currentUser?.uid
            
            
            try await backend.child("Users").child(userID!).setValue(userUpdateData)
            print("Account created")
            return true
        } catch {
            print("Failed to create account : \(error)")
            return false
        }
    }
    func updateUser(User user1: Users){
        user = user1
    }
    
    func updateImageURL(imageURLString: String) {
        user.imageURL = imageURLString
    }
    
    func verfiedLogin() async throws -> Bool {
        if Auth.auth().currentUser != nil {
            return true
        } else {
            return false
        }
    }
    
    func loadImage(from url: URL) async throws -> UIImage? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let image = UIImage(data: data) {
                return image
            } else {
                print("Failed to create image from data.")
                return nil
            }
        } catch {
            print("Error: \(error.localizedDescription)")
            return nil
        }
    }
    
    @MainActor
    func Logout()  async {
        do{
            _ = try Auth.auth().signOut()
            let newUser = Users(id: "", name: "", password: "", email: "", imageURL: "")
            self.user = newUser
        }catch {
            print("fail to log out ")
        }
    }
    
    
    init() {
        user = Users(id: "", name: "", password: "", email: "", imageURL: "")
    }
    
}

