//
//  CommunityOutreachLandingView.swift
//  Dough to Bread
//
//  Created by Matthew Shapiro on 2/4/24.
//

import SwiftUI


//NOTE: Used AI to help me with getting the desired colors from figma mockup

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue:  Double(b) / 255, opacity: Double(a) / 255)
    }
}

// Custom Button Style to match your Figma mockup
struct FigmaButtonStyle: ButtonStyle {
    var backgroundColor: Color
    var foregroundColor: Color
    var borderColor: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(hex: "D9D9D9"))
            .foregroundColor(foregroundColor)
            .font(.custom("Poppins-SemiBold", size: 22)) // Customize this font as per your mockup
            .overlay(RoundedRectangle(cornerRadius: 4).stroke(borderColor, lineWidth: 2))
            .cornerRadius(10)
            .padding(.horizontal, 40)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct CommunityOutreachLandingView: View {
    @ObservedObject var viewModel: CommunityOutreachLanding

    var body: some View {
        NavigationView {
            // Use ZStack as the root container
            ZStack(alignment: .topLeading) {
                // This VStack will be for the background image and the back button
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Button(action: {
                            viewModel.goBack()
                        }) {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.black)
                                .padding(16) // Ensures the button is easily tappable
                                .offset(x: 21, y: 50)
                                .font(.system(size: 37))
                            
                        }
                        Spacer()
                    }
                    Spacer() // Pushes the HStack to the top of the screen
                }
                .background(
                    Image("Circles")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .opacity(1) // Use full opacity to ensure the image is visible
                        .offset(x: -135, y: -340) // Adjust as needed
                )
                .edgesIgnoringSafeArea(.all) // Ensure the background extends to the edges
                
                // This VStack will be for the rest of your buttons, spaced apart
                VStack(spacing: 100) {
                    Spacer().frame(height: 0) // Adjust for spacing

                    NavigationLink(destination: ScheduleCoachingView()) {
                        Text("Schedule Coaching")
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2))
                    }
                    .buttonStyle(FigmaButtonStyle(backgroundColor: .white, foregroundColor: .black, borderColor: .gray))

                    NavigationLink(destination: MessageCoachView()) {
                        Text("Message Coach")
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2))
                    }
                    .buttonStyle(FigmaButtonStyle(backgroundColor: .white, foregroundColor: .black, borderColor: .gray))

                    NavigationLink(destination: CommunityForumView()) {
                        Text("Community Forum")
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2))
                    }
                    .buttonStyle(FigmaButtonStyle(backgroundColor: .white, foregroundColor: .black, borderColor: .gray))
                    
                    Spacer()
                }
                .padding(.bottom, 20) // Adjust this padding to ensure that VStack starts below the navigation bar area
            }
            .background(Color(hex: "FFFFFF")) // Set the overall background color
            .navigationTitle("Community Outreach")
            .navigationBarHidden(false)
        }
    }
}



struct CommunityOutreachLandingView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityOutreachLandingView(viewModel: CommunityOutreachLanding())
    }
}
