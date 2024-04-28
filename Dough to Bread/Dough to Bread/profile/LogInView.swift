
import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseAuth

struct LogInView: View {
    @State private var path = NavigationPath()
    @EnvironmentObject var authViewModel : AuthViewModel
    @State var Signin: Bool = false
    let backend = Database.database().reference()
    @State private var isSignUpActive = false
    @State private var ProfileViewActive = false
    @State var email = "";
    @State var Password = "";
    @State var showingAlert = false
    @State var Action : Int? = 0
    @State var imageURL: String = "https://firebasestorage.googleapis.com:443/v0/b/spoton-d3fb4.appspot.com/o/images%2FDB6B423E-5EFF-4725-9E4A-071934A81E43.jpg?alt=media&token=e2ffc8ad-9e7e-41ad-b4ad-87442d1ef6a6"

    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Image("Background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    VStack{
                        Text("Welcome!")
                            .font(.title)
                            .padding()
                        HStack(spacing:1){
                            Text("Dough to Bread")
                        }
                        .foregroundStyle(.spotOnRed)
                        .fontWeight(.heavy)
                        .font(.title)

                    }
                    TextField("email", text: $email)
                        .padding()
                        .background(.tertiary, in: .rect(cornerRadius: 20))
                        .frame(width: 300, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .autocapitalization(.none)
                    SecureField("Password", text: $Password)
                        .padding()
                        .background(.tertiary, in: .rect(cornerRadius: 20))
                        .frame(width: 300, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .autocapitalization(.none)
                    Button("Sign In", action: {
                        // do something here
                        Task{
                        
                            ProfileViewActive = true
                        }
                    })
                    .foregroundStyle(.white)
                    .fontWeight(.heavy)
                    .padding()
                    .background(.spotOnRed, in: .rect(cornerRadius: 20))
                    .frame(width: 300, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

                    HStack {
                        Text("Don't have an account?")
                        Button("Sign Up", action: {
                            isSignUpActive = true
                        })
                        .navigationDestination(isPresented: $isSignUpActive, destination: {
                            CreateAccountView(path: $path).environmentObject(authViewModel)
                        })
                        .foregroundStyle(.spotOnRed)
                        .fontWeight(.heavy)
                    }
                    .padding()
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Try Again"), message: Text("Wrong password."), dismissButton: .default(Text("OK")))
                    }
                }
            }
            .onAppear(perform: {
                print(path)
                print(path.count)
            })
        }
    }
    
    func uploadImage() async {
        if let url = URL(string: imageURL) {
            // Use the 'url' variable for further operations
            print("URL created: \(url)")
            do {
                if let image = try await authViewModel.loadImage(from: url) {
          
                        authViewModel.userImage = image
                        print("Image Loaded.")
                    
                }
            } catch {
                print("Error loading image: \(error)")
            }
        } else {
            print("Invalid URL")
        }

    }
}


extension ShapeStyle where Self == Color {
    static var spotOnRed: Color {
        Color(uiColor: UIColor(rgb: 0xc597836))
    }
    
    static var cardinal: Color {
        Color(uiColor: UIColor(rgb: 0x990000))
    }
    
    static var gold: Color {
        Color(uiColor: UIColor(rgb: 0xFFCC00))
    }
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")
       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
    
}
