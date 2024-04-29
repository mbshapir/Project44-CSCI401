
import SwiftUI

struct CreateAccountView: View {
    @Binding var path: NavigationPath
    @EnvironmentObject var authviewModel : AuthViewModel
    
    @State var Name = "";
    @State var email = "";
    @State var Password = "";
    @State var PasswordConfirm = "";
    @State var showAlert = false
    @State var nextPage = false
    @State var alertMessage = "Failed"
    @State var picloaded : Bool = false
    @Environment(\.dismiss)
    private var dismiss
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack{
                Image("Background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    Text("Sign Up")
                        .fontWeight(.heavy)
                        .font(.title)
                        .padding()
                    Text("Dough to Bread")
                        .foregroundStyle(.spotOnRed)
                        .fontWeight(.heavy)
                    TextField("Name", text: $Name)
                        .padding()
                        .background(.tertiary, in: .rect(cornerRadius: 20))
                        .frame(width: 300, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    TextField("email", text: $email)
                        .padding()
                        .background(.tertiary, in: .rect(cornerRadius: 20))
                        .frame(width: 300, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .autocapitalization(.none)
                    SecureField("Password", text: $Password)
                        .padding()
                        .background(.tertiary, in: .rect(cornerRadius: 20))
                        .frame(width: 300, height: 60, alignment: .center)
                        .autocapitalization(.none)
                    SecureField("Password Confirmation", text: $PasswordConfirm)
                        .padding()
                        .background(.tertiary, in: .rect(cornerRadius: 20))
                        .frame(width: 300, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .autocapitalization(.none)
                    
                    Button("Next", action: {
                        Task{
                            if(Name != "" && Password != "" && email != "")
                            {
                                if (Password == PasswordConfirm) {

                                    if (Password.count >= 6){
                                        
                                        
                                        let newUser = Users(id: UUID().uuidString, name: Name, password: Password, email: email, imageURL: "hello")
                                        authviewModel.updateUser(User: newUser)
                                        nextPage = true
                                        
                                        
                                    }else{
                                        showAlert = true
                                        alertMessage = "Password has to be at least 6 characters."
                                    }

                                }else{
                                    showAlert = true
                                    alertMessage = "Password confirmation does not match."
                                }

                            }else{
                                showAlert = true
                                alertMessage = "Cannot leave field empty."
                            }
                        }
                    })
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Try again."),
                            message: Text(alertMessage)
                        )
                    }
                    .navigationDestination(isPresented: $nextPage, destination: {
                        ProfilePicView(path: $path).environmentObject(authviewModel)
                    })

                    .foregroundStyle(.white)
                    .fontWeight(.heavy)
                    .padding()
                    .background(.spotOnRed, in: .rect(cornerRadius: 20))
                    .frame(width: 300, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
            }
            
        }
        .onAppear(perform: {
            print(path)
            print(path.count)
        })
      
    }
}
