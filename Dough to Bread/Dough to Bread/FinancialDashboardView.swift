////
////  FinancialDashboardView.swift
////  Dough to Bread
////
////  Created by Shaoxiong Yuan on 3/27/24.
////
//
//import SwiftUI
//
//struct FinancialDashboardView: View {
//    // For simplicity, these are just example links and titles
//    let videoLinks = [
//        ("Financial Literacy - Video 1", "https://www.example.com/video1"),
//        ("Financial Literacy - Video 2", "https://www.example.com/video2")
//        // Add more links as needed
//    ]
//    
//    let textLinks = [
//        ("Understanding Your Taxes - Article", "https://www.example.com/article1"),
//        ("Saving for Retirement - Article", "https://www.example.com/article2")
//        // Add more links as needed
//    ]
//
//    var body: some View {
//        NavigationView {
//            List {
//                Section(header: Text("QuickBooks Integration")) {
//                    // This is a placeholder for the QuickBooks integration.
//                    Text("QuickBooks Data")
//                        .onTapGesture {
//                            // Implement QuickBooks authentication and data retrieval
//                        }
//                }
//                
//                Section(header: Text("Financial Literacy Videos")) {
//                    ForEach(videoLinks, id: \.1) { link in
//                        Link(link.0, destination: URL(string: link.1)!)
//                    }
//                }
//                
//                Section(header: Text("Financial Literacy Texts")) {
//                    ForEach(textLinks, id: \.1) { link in
//                        Link(link.0, destination: URL(string: link.1)!)
//                    }
//                }
//            }
//            .navigationBarTitle("Financial Dashboard")
//        }
//    }
//}
//
//struct FinancialDashboardView_Previews: PreviewProvider {
//    static var previews: some View {
//        FinancialDashboardView()
//    }
//}
//
