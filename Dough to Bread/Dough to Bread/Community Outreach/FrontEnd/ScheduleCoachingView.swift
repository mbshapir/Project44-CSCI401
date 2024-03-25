//
//  ScheduleCoachingView.swift
//
//  Created by Matthew Shapiro on 2/4/24.
//

import SwiftUI

struct ScheduleCoachingView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isLoading = true // State to track loading

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Exit")
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.black)
                        .padding(.all, 12)
                        .font(.system(size: 16))
                }
                .background(Color(hex: "597836"))
                .clipShape(Circle())
                .padding(.leading)

                Text("Schedule Coaching")
                    .font(.custom("Poppins-SemiBold", size: 32))
                    .foregroundColor(Color.white)
                    .padding(.horizontal)
                    .background(Color(hex: "597836"))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(hex: "000000"), lineWidth: 2)
                    )
            }
            .offset(x: -10, y: 0)
            .padding(.top, 0)
            .padding(.bottom)

            // Use ZStack to overlay the loading indicator on the WebView
            ZStack {
                WebView(urlString: "https://calendly.com/omar-muhammad", isLoading: $isLoading)
                    .edgesIgnoringSafeArea(.all)
                
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5, anchor: .center)
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .offset(x: 0, y: 0)
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
}

// Preview Provider
struct ScheduleCoachingView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleCoachingView()
    }
}


