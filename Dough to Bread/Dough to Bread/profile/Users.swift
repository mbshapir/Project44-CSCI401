
import Foundation
import SwiftUI



struct Users : Identifiable {
    var id: String
    var name : String
    var password : String
    var email : String
    var imageURL : String
}


protocol UserModel{
    func CreateLogin(User user: Users) async throws -> Bool
    func verfiedLogin() async throws -> Bool
   
}
