////
////  FinancialLiteracyModuleView.swift
////  Dough to Bread
////
////  Created by Shaoxiong Yuan on 2/7/24.
////
//
//import SwiftUI
//
//
//struct FinancialLiteracyModuleView: View {
//    @ObservedObject var viewModel: FinancialLiteracyModule
//
//    var body: some View {
//        NavigationView {
//            // Use ZStack as the root container
//            ZStack(alignment: .topLeading) {
//                // This VStack will be for the background image and the back button
//                VStack(alignment: .leading, spacing: 0) {
//                    HStack {
//                        Button(action: {
//                            viewModel.goBack()
//                        }) {
//                            Image(systemName: "arrow.left")
//                                .foregroundColor(.black)
//                                .padding(16) // Ensures the button is easily tappable
//                                .offset(x: 21, y: 50)
//                                .font(.system(size: 37))
//                            
//                        }
//                        Spacer()
//                    }
//                    Spacer() // Pushes the HStack to the top of the screen
//                }
//                .background(
//                    Image("Circles")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 300, height: 300)
//                        .opacity(1) // Use full opacity to ensure the image is visible
//                        .offset(x: -135, y: -340) // Adjust as needed
//                )
//                .edgesIgnoringSafeArea(.all) // Ensure the background extends to the edges
//                
//                // This VStack will be for the rest of your buttons, spaced apart
//                VStack(spacing: 100) {
//                    Spacer().frame(height: 30) // Adjust for spacing
//
//                    NavigationLink(destination: InteractiveCoursesView()) {
//                        Text("Interactive Courses")
//                            .foregroundColor(.black)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.white)
//                            .cornerRadius(10)
//                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2))
//                    }
//                    .buttonStyle(FigmaButtonStyle(backgroundColor: .white, foregroundColor: .black, borderColor: .gray))
//
//                    NavigationLink(destination: QuizzesView()) {
//                        Text("Quizzes")
//                            .foregroundColor(.black)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.white)
//                            .cornerRadius(10)
//                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2))
//                    }
//                    .buttonStyle(FigmaButtonStyle(backgroundColor: .white, foregroundColor: .black, borderColor: .gray))
//
//                    NavigationLink(destination: ProgressTrackingView()) {
//                        Text("Progress Tracking")
//                            .foregroundColor(.black)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.white)
//                            .cornerRadius(10)
//                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2))
//                    }
//                    .buttonStyle(FigmaButtonStyle(backgroundColor: .white, foregroundColor: .black, borderColor: .gray))
//                    
//                    Spacer()
//                }
//                .padding(.top, 44) // Adjust this padding to ensure that VStack starts below the navigation bar area
//            }
//            .background(Color(hex: "FFFFFF")) // Set the overall background color
//            .navigationTitle("Financial Literacy Modules")
//            .navigationBarHidden(true)
//        }
//    }
//}
//
//
//
//struct FinancialLiteracyModuleView_Previews: PreviewProvider {
//    static var previews: some View {
//        FinancialLiteracyModuleView(viewModel: FinancialLiteracyModule())
//    }
//}
//
