import SwiftUI
import FirebaseDatabase

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
    
    let totalTarget: Double = 50000
    
    private var databaseRef: DatabaseReference = Database.database().reference()
    
    func calculateTotalSavings() -> Double {
        return emergencyFund1 + emergencyFundMonths + retirementFund + collegeFund + realEstateTaxes + homeownerInsurance + repairsMaintenanceFee + replaceFurniture + carInsurance + carReplacement + disabilityInsurance + healthInsurance + doctor + dentist + optometrist + lifeInsurance + schoolTuitionSupplies + gifts + vacation + computerReplacement + tires + baby + other
    }
    
    func isTargetReached() -> Bool {
        return calculateTotalSavings() >= totalTarget
    }
    
    func submitData() {
            let totalSavings = calculateTotalSavings()
            let targetReached = isTargetReached()

            let data = [
                "totalSavings": totalSavings,
                "targetReached": targetReached,
                "timestamp": Int(Date().timeIntervalSince1970)
            ] as [String : Any]

        self.databaseRef.child("savingsResults").childByAutoId().setValue(data) { error, _ in
                if let error = error {
                    print("Error submitting data: \(error)")
                } else {
                    print("Data submitted successfully")
                }
            }
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
                    viewModel.submitData()
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
            TextField("1. Emergency Fund (1)", value: $viewModel.emergencyFund1, format: .number)
            TextField("2. Emergency Fund (Months)", value: $viewModel.emergencyFundMonths, format: .number)
            TextField("3. Retirement Fund", value: $viewModel.retirementFund, format: .number)
            TextField("4. College Fund", value: $viewModel.collegeFund, format: .number)
            TextField("5. Real Estate Taxes", value: $viewModel.realEstateTaxes, format: .number)
            TextField("6. Homeowner Insurance", value: $viewModel.homeownerInsurance, format: .number)
            TextField("7. Repairs/Maintenance Fee", value: $viewModel.repairsMaintenanceFee, format: .number)
            TextField("8. Replace Furniture", value: $viewModel.replaceFurniture, format: .number)
            TextField("9. Car Insurance", value: $viewModel.carInsurance, format: .number)
            TextField("10. Car Replacement", value: $viewModel.carReplacement, format: .number)
            TextField("11. Disability Insurance", value: $viewModel.disabilityInsurance, format: .number)
            TextField("12. Health Insurance", value: $viewModel.healthInsurance, format: .number)
            TextField("13. Doctor", value: $viewModel.doctor, format: .number)
            TextField("14. Dentist", value: $viewModel.dentist, format: .number)
            TextField("15. Optometrist", value: $viewModel.optometrist, format: .number)
            TextField("16. Life Insurance", value: $viewModel.lifeInsurance, format: .number)
            TextField("17. School Tuition/Supplies", value: $viewModel.schoolTuitionSupplies, format: .number)
            TextField("18. Gifts", value: $viewModel.gifts, format: .number)
            TextField("19. Vacation", value: $viewModel.vacation, format: .number)
            TextField("20. Computer Replacement", value: $viewModel.computerReplacement, format: .number)
            TextField("21. Tires", value: $viewModel.tires, format: .number)
            TextField("22. Baby", value: $viewModel.baby, format: .number)
            TextField("23. Other", value: $viewModel.other, format: .number)
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

#Preview {
    SavingsView()
}


