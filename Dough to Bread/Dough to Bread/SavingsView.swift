//
//  EmergencyCalculatorView.swift
//  Dough to Bread
//
//  Created by Shaoxiong Yuan on 3/26/24.
//

import SwiftUI

// ViewModel to handle logic and data storage
class SavingsViewModel: ObservableObject {
    @Published var emergencyFund1: Double = 1000
    @Published var emergencyFundMonths: Double = 0 // Assuming a monetary value for simplicity
    @Published var retirementFund: Double = 0
    @Published var collegeFund: Double = 0
    @Published var realEstateTaxes: Double = 0
    @Published var homeownerInsurance: Double = 0
    @Published var repairsMaintenanceFee: Double = 0
    @Published var replaceFurniture: Double = 0
    @Published var carInsurance: Double = 0
    @Published var carReplacement: Double = 0
    @Published var disabilityInsurance: Double = 0
    @Published var healthInsurance: Double = 0
    @Published var doctor: Double = 0
    @Published var dentist: Double = 0
    @Published var optometrist: Double = 0
    @Published var lifeInsurance: Double = 0
    @Published var schoolTuitionSupplies: Double = 0
    @Published var gifts: Double = 0
    @Published var vacation: Double = 0
    @Published var computerReplacement: Double = 0
    @Published var tires: Double = 0
    @Published var baby: Double = 0
    @Published var other: Double = 0
    
    // Placeholder for total target.
    let totalTarget: Double = 50000
    
    // Function to calculate total savings
    func calculateTotalSavings() -> Double {
        return emergencyFund1 + emergencyFundMonths + retirementFund + collegeFund + realEstateTaxes + homeownerInsurance + repairsMaintenanceFee + replaceFurniture + carInsurance + carReplacement + disabilityInsurance + healthInsurance + doctor + dentist + optometrist + lifeInsurance + schoolTuitionSupplies + gifts + vacation + computerReplacement + tires + baby + other
    }
    
    // Function to check if total savings meet the target
    func isTargetReached() -> Bool {
        return calculateTotalSavings() >= totalTarget
    }
}

// Main View
struct SavingsView: View {
    @StateObject private var viewModel = SavingsViewModel()
    @State private var showResults = false
    
    var body: some View {
        NavigationView {
            Form {
                savingsInputSection
                
                if showResults {
                    resultsSection
                }
                
                Button("Submit") {
                    showResults = true
                }
                .foregroundColor(.blue)
            }
            .navigationBarTitle("Savings Calculator")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    var savingsInputSection: some View {
        Section(header: Text("Savings Input")) {
            TextField("Emergency Fund (1)", value: $viewModel.emergencyFund1, format: .number)
            // Repeat for all fields...
            TextField("Vacation", value: $viewModel.vacation, format: .number)
            TextField("Computer Replacement", value: $viewModel.computerReplacement, format: .number)
            // Add other fields here...
        }
    }
    
    var resultsSection: some View {
        Section(header: Text("Results")) {
            Text("Total Saved: \(viewModel.calculateTotalSavings(), specifier: "%.2f")")
            Text("Target: \(viewModel.totalTarget, specifier: "%.2f")")
            Text("Target Reached: \(viewModel.isTargetReached() ? "Yes" : "No")")
        }
    }
}

// Preview
struct SavingsView_Previews: PreviewProvider {
    static var previews: some View {
        SavingsView()
    }
}

