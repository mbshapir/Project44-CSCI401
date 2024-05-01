//
//  InteractivePollView.swift
//  Dough to Bread
//
//  Created by Shaoxiong Yuan on 3/27/24.
//

import SwiftUI

struct FinancialPollView: View {
    @State private var financialGoalsSelection: Set<String> = []
    @State private var financialChallenge: String = ""
    @State private var financeManagement: String = ""
    @State private var interestInFinancialLiteracy: Set<String> = []
    @State private var preferredLearningMethod: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("What are your financial goals?")) {
                    MultipleChoiceQuestion(options: [
                        "Save for retirement",
                        "Pay off debt",
                        "Purchase a home",
                        // Add all other options
                    ], selection: $financialGoalsSelection)
                }
                
                Section(header: Text("What is your biggest financial challenge right now?")) {
                    SingleChoiceQuestion(options: [
                        "Managing debt or loans",
                        "Budgeting and saving",
                        // Add all other options
                    ], selection: $financialChallenge)
                }
                
                Section(header: Text("How do you currently manage your finances?")) {
                    SingleChoiceQuestion(options: [
                        "I use a budgeting app or software",
                        "I keep a personal spreadsheet or ledger",
                        // Add all other options
                    ], selection: $financeManagement)
                }
                
                Section(header: Text("What areas of financial literacy are you most interested in learning more about?")) {
                    MultipleChoiceQuestion(options: [
                        "Budgeting and saving techniques",
                        "Investment strategies",
                        // Add all other options
                    ], selection: $interestInFinancialLiteracy)
                }
                
                Section(header: Text("How do you prefer to receive financial education and advice?")) {
                    SingleChoiceQuestion(options: [
                        "Online courses or webinars",
                        "One-on-one coaching or consulting",
                        // Add all other options
                    ], selection: $preferredLearningMethod)
                }
                
                Button("Submit Poll") {
                    // Handle the submission of poll data
                }
            }
            .navigationBarTitle("Financial Poll")
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

// Preview
struct FinancialPollView_Previews: PreviewProvider {
    static var previews: some View {
        FinancialPollView()
    }
}

