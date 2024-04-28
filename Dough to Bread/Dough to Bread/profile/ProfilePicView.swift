
import SwiftUI
import PhotosUI
import FirebaseStorage

struct ProfilePicView: View {
    @State var selectedImage: PhotosPickerItem? = nil
    @Binding var path: NavigationPath
    @State var uploaded = false
//    @State var profileImg: UIImage = UIImage(named: "Profile")!
    @State var profileImg: UIImage? = UIImage(named: "Profile")

    @State var showingAlert = false
    @State var alertMessage = "Failed"
    @Environment(\.dismiss)
    private var dismiss
    @EnvironmentObject var authviewModel : AuthViewModel

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Image("Background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Upload Photo")
                        .font(.title)
                        .fontWeight(.heavy)
                        .padding()
                    Text("Dough to Bread")
                        .foregroundStyle(.spotOnRed)
                        .fontWeight(.heavy)
//                    Image(uiImage: profileImg)
                    Image(uiImage: profileImg ?? UIImage(systemName: "photo")!) // 
                        .resizable()
                        .frame(width: 250, height: 250)
                    PhotosPicker(
                        selection: $selectedImage,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        Text("Select a photo")
                            .foregroundStyle(.spotOnRed)
                            .fontWeight(.heavy)
                            .padding(.bottom)
                    }
                    .onChange(of: selectedImage) { _, newItem in
                        Task {
                            // Retrieve selected asset in the form of Data
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                profileImg = UIImage(data: data) ?? UIImage(named: "Profile")!
                                print("here2")
                            }
                        }
                    }.alert(isPresented: $showingAlert) {
                        Alert(
                            title: Text("Try again."),
                            message: Text(alertMessage)
                        )
                    }
                    Text("Image selected: \(selectedImage != nil ? "Yes" : "No")")

                    if selectedImage != nil{
                        Button("Upload", action: {
                            // do something here
                            print("here1")
                            uploadPhoto()
                            dismiss()
                        }).foregroundStyle(.spotOnRed)
                    .fontWeight(.heavy)
                    .padding()
                    .background(in: .rect(cornerRadius: 20))
                    .frame(width: 300, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
                }
            }
            .navigationDestination(isPresented: $uploaded, destination: {
                FinancialPollView()
            })
            .onAppear(perform: {
                print(path)
                print(path.count)
            })
        }
    }
    
    func uploadPhoto() {
        print("Here")

        guard let selectedImage = selectedImage else { return }
        print("Here 6")
        Task {
            do {
                if let imageData = try await selectedImage.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: imageData) {
                        let storageRef = Storage.storage().reference()
                        let fileRef = storageRef.child("images/\(UUID().uuidString).jpg")

                        if let imageToUpload = uiImage.jpegData(compressionQuality: 0.8) {
                            fileRef.putData(imageToUpload, metadata: nil) { metadata, error in
                                if let error = error {
                                    print("Upload failed: \(error.localizedDescription)")
                                } else {
                                    print("Upload successful")
                                    fileRef.downloadURL { url, error in
                                        if let downloadURL = url {
                                            authviewModel.updateImageURL(imageURLString: downloadURL.absoluteString)
                                            print(downloadURL.absoluteString)

                                            // Call CreateLogin after updating the image URL
                                            Task {

                                                uploaded = try await authviewModel.CreateLogin(User: authviewModel.user)
                                                if uploaded == false{
                                                    showingAlert = true
                                                    alertMessage = "Duplicate email exists. Please try again with a different email."
                                                }else{
                                                    print("hello")
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            showingAlert = true
                            alertMessage = "Photo cannot be uploaded."
                        }
                    }
                }
            } catch {
                showingAlert = true
                alertMessage = "Error during image conversion: \(error)."

            }
        }
    }

}
