import SwiftUI
import FirebaseDatabase

struct FinancialPollView: View {
    @State private var financialGoalsSelection: Set<String> = []
    @State private var financialChallenge: String = ""
    @State private var financeManagement: String = ""
    @State private var interestInFinancialLiteracy: Set<String> = []
    @State private var preferredLearningMethod: String = ""
    @State private var isSubmitting = false
    
    let db = Database.database().reference()

    var body: some View {
        NavigationView {
            Form {
                // Update options for financial goals
                Section(header: Text("What are your financial goals?")) {
                    MultipleChoiceQuestion(options: [
                        "Save for retirement",
                        "Pay off debt",
                        "Purchase a home",
                        "Start or grow a business",
                        "Build an emergency fund",
                        "Invest in stocks or real estate",
                        "Other (Please specify)"
                    ], selection: $financialGoalsSelection)
                }
                
                // Update options for financial challenge
                Section(header: Text("What is your biggest financial challenge right now?")) {
                    SingleChoiceQuestion(options: [
                        "Managing debt or loans",
                        "Budgeting and saving",
                        "Understanding investment options",
                        "Preparing for retirement",
                        "Balancing business and personal finances",
                        "Navigating financial uncertainty due to job loss or reduced income",
                        "Other (Please specify)"
                    ], selection: $financialChallenge)
                }
                
                // Update options for finance management
                Section(header: Text("How do you currently manage your finances?")) {
                    SingleChoiceQuestion(options: [
                        "I use a budgeting app or software",
                        "I keep a personal spreadsheet or ledger",
                        "I mostly keep track in my head",
                        "I seek advice from financial professionals",
                        "I haven’t started managing my finances yet",
                        "Other (Please specify)"
                    ], selection: $financeManagement)
                }
                
                // Update options for financial literacy interest
                Section(header: Text("What areas of financial literacy are you most interested in learning more about?")) {
                    MultipleChoiceQuestion(options: [
                        "Budgeting and saving techniques",
                        "Investment strategies",
                        "Retirement planning",
                        "Tax planning and optimization",
                        "Understanding credit and debt management",
                        "Entrepreneurial finance"
                    ], selection: $interestInFinancialLiteracy)
                }
                
                // Update options for preferred learning method
                Section(header: Text("How do you prefer to receive financial education and advice?")) {
                    SingleChoiceQuestion(options: [
                        "Online courses or webinars",
                        "One-on-one coaching or consulting",
                        "Reading books and articles",
                        "Interactive workshops or seminars",
                        "Podcasts and videos",
                        "Financial apps and tools",
                        "Other (Please specify)"
                    ], selection: $preferredLearningMethod)
                }
                
                Button(action: {
                    isSubmitting = true
                    submitPoll()
                }) {
                    Text("Submit Poll")
                        .foregroundColor(isSubmitting ? .gray : .blue)
                        .disabled(isSubmitting) // Disable button when submitting
                }
                
            }
            .navigationBarTitle("Financial Poll")
        }
    }
    
    func submitPoll() {
            let pollData: [String: Any] = [
                "financialGoals": Array(financialGoalsSelection),
                "financialChallenge": financialChallenge,
                "financeManagement": financeManagement,
                "interestInFinancialLiteracy": Array(interestInFinancialLiteracy),
                "preferredLearningMethod": preferredLearningMethod
            ]

            // Write data to Firebase Realtime Database
            db.child("financial_polls").childByAutoId().setValue(pollData) { error, _ in
                if let error = error {
                    print("Error submitting poll: \(error.localizedDescription)")
                } else {
                    print("Poll submitted successfully")
                }
                isSubmitting = false
            }
        }
}

// Views for handling single and multiple-choice questions
struct SingleChoiceQuestion: View {
    let options: [String]
    @Binding var selection: String

    var body: some View {
        ForEach(options, id: \.self) { option in
            RadioButton(text: option, isSelected: selection == option) {
                selection = option
            }
        }
    }
}

struct MultipleChoiceQuestion: View {
    let options: [String]
    @Binding var selection: Set<String>

    var body: some View {
        ForEach(options, id: \.self) { option in
            CheckboxButton(text: option, isSelected: selection.contains(option)) {
                if selection.contains(option) {
                    selection.remove(option)
                } else {
                    selection.insert(option)
                }
            }
        }
    }
}

// Custom button views for radio buttons and checkboxes
struct RadioButton: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(isSelected ? .blue : .gray)
                Text(text)
            }
        }
        .foregroundColor(.primary)
    }
}

struct CheckboxButton: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "checkmark.square" : "square")
                    .foregroundColor(isSelected ? .blue : .gray)
                Text(text)
            }
        }
        .foregroundColor(.primary)
    }
}

#Preview {
    FinancialPollView()
}


