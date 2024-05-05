import SwiftUI

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
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

let primaryGreen = Color(hex: "86C232") // Adjust the hex value as needed
let backgroundGray = Color(hex: "F5F5F5") // Adjust the hex value as needed
let textFieldBorderGray = Color(hex: "E2E2E2") // Adjust the hex value as needed


// Custom Button Style to match Figma mockup
struct FigmaButtonStyle: ButtonStyle {
    var backgroundColor: Color
    var foregroundColor: Color
    var borderColor: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(borderColor, lineWidth: 2))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct ContentView: View {
    @State private var housing: String = ""
    @State private var utilities: String = ""
    @State private var food: String = ""
    @State private var transportation: String = ""
    @State private var clothing: String = ""
    @State private var medical: String = ""
    @State private var charity: String = ""
    @State private var additionalExpenses: [String: String] = [:]
    @State private var newCategoryName: String = ""
    
    @State private var income: String = ""
    @State private var totalExpenses: Double = 0
    @State private var suggestions: String = ""
    @State private var expenseAnalysis: [String: Double] = [:]
    
    // Color scheme from the provided image.
    let backgroundColor = Color.white
    let primaryColor = Color.green
    let textColor = Color.black
    let secondaryTextColor = Color.gray
    let textFieldBackgroundColor = Color.gray.opacity(0.2)
    let pieChartColors = [
        Color.red, Color.green, Color.blue,
        Color.orange, Color.purple, Color.yellow,
        Color.pink, Color.gray, Color.cyan,
        Color.indigo, Color.brown
    ]
    let darkGreen = Color(red: 30 / 255, green: 130 / 255, blue: 76 / 255)
       let lightGreen = Color(red: 140 / 255, green: 198 / 255, blue: 63 / 255)
       let inputFieldBackground = LinearGradient(gradient: Gradient(colors: [Color.white, Color(red: 240 / 255, green: 240 / 255, blue: 240 / 255)]), startPoint: .top, endPoint: .bottom)
       let inputFieldTextColor = primaryGreen
       let buttonTextColor = Color.white

    var body: some View {
        NavigationView {
            ZStack {
                backgroundGray.edgesIgnoringSafeArea(.all)
                
                Form {
                    Section(header: Text("Income").foregroundColor(textColor)) {
                        TextField("Monthly Income", text: $income).keyboardType(.decimalPad)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(5)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
                    }
                    
                    Section(header: Text("Monthly Expenses").foregroundColor(textColor)) {
                        MonthlyExpenseTextField(category: "Housing", value: $housing)
                        MonthlyExpenseTextField(category: "Utilities", value: $utilities)
                        MonthlyExpenseTextField(category: "Food", value: $food)
                        MonthlyExpenseTextField(category: "Transportation", value: $transportation)
                        MonthlyExpenseTextField(category: "Clothing", value: $clothing)
                        MonthlyExpenseTextField(category: "Medical", value: $medical)
                        MonthlyExpenseTextField(category: "Charity", value: $charity)
                        ForEach(additionalExpenses.keys.sorted(), id: \.self) { key in
                            MonthlyExpenseTextField(category: key, value: Binding(get: { self.additionalExpenses[key] ?? "" }, set: { self.additionalExpenses[key] = $0 }))
                        }
                        AddCategoryView(newCategoryName: $newCategoryName, additionalExpenses: $additionalExpenses)
                    }

                    
                    Section {
                        Button("Calculate Total Expenses") {
                            self.sumExpenses()
                        }
                        .buttonStyle(FigmaButtonStyle(backgroundColor: Color(hex: "#D9D9D9"),foregroundColor: Color.white, borderColor: Color.clear))
                    }
                    
                    Section(header: Text("Total Expenses").foregroundColor(textColor)) {
                        Text("$\(self.totalExpenses, specifier: "%.2f")")
                    }
                    
                    if !self.suggestions.isEmpty {
                        Section(header: Text("Suggestions for Potential Savings").foregroundColor(secondaryTextColor)) {
                            Text(self.suggestions)
                        }
                    }
                    
                    if !self.expenseAnalysis.isEmpty {
                        Section(header: Text("Expense Distribution").foregroundColor(textColor)) {
                            PieChartView(data: self.sortedChartData(), colors: self.pieChartColors)
                                .frame(height: 300)
                        }
                        Section(header: Text("Expense Key").foregroundColor(textColor)) {
                            PieChartKeyView(data: self.expenseAnalysis, colors: self.pieChartColors)
                        }
                    }
                }
                .navigationBarTitle("Budget Tracker", displayMode: .inline).navigationBarItems(leading: Button("Back", action: {})).navigationBarColor(backgroundColor: primaryGreen, textColor: .white)
                
            }
            .modifier(NavigationBarModifier(backgroundColor: UIColor(primaryGreen), textColor: UIColor.white))
        }
    }

    private func sumExpenses() {
        let incomeVal = Double(income) ?? 0
        let housingE = Double(housing) ?? 0
        let utilitiesE = Double(utilities) ?? 0
        let foodE = Double(food) ?? 0
        let transportationE = Double(transportation) ?? 0
        let clothingE = Double(clothing) ?? 0
        let medicalE = Double(medical) ?? 0
        let charityE = Double(charity) ?? 0
        let additionalE = additionalExpenses.values.compactMap(Double.init).reduce(0, +)
        
        totalExpenses = housingE + utilitiesE + foodE + transportationE + clothingE + medicalE + charityE + additionalE
        
        suggestions = ""
        if totalExpenses > incomeVal {
            suggestions += "Your expenses exceed your income. Consider reducing non-essential expenses.\n"
        } else {
            suggestions += "You are within your budget. Great job!\n"
        }
        
        let essentials = housingE + foodE + utilitiesE + medicalE
        if essentials > 0.5 * incomeVal {
            suggestions += "Essential expenses are more than 50% of your income. Consider finding ways to reduce these costs.\n"
        }
        
        if incomeVal - totalExpenses < 0.2 * incomeVal {
            suggestions += "Consider increasing your savings to at least 20% of your income.\n"
        }
        
        if incomeVal > 0 {
            let savings = max(incomeVal - totalExpenses, 0) // Ensure savings is not negative
            let total = max(incomeVal, totalExpenses) // Use the larger of income or total expenses to scale percentages
            expenseAnalysis = [
                "Savings": (savings / total) * 100,
                "Housing": (housingE / total) * 100,
                "Utilities": (utilitiesE / total) * 100,
                "Food": (foodE / total) * 100,
                "Transportation": (transportationE / total) * 100,
                "Clothing": (clothingE / total) * 100,
                "Medical": (medicalE / total) * 100,
                "Charity": (charityE / total) * 100
            ]
            
            for (key, value) in additionalExpenses {
                if let doubleValue = Double(value) {
                    expenseAnalysis[key] = (doubleValue / total) * 100
                }
            }
            
            // Sort if needed, depending on how you want to display the data.
            expenseAnalysis = expenseAnalysis.sorted(by: { $0.value > $1.value }).reduce(into: [String: Double]()) { (result, element) in
                result[element.key] = element.value
            }
        }
    }


    private func sortedChartData() -> [(String, Double)] {
        expenseAnalysis.sorted { $0.value > $1.value }.map { ($0.key, $0.value) }
    }

}
struct PrimaryButtonStyle: ButtonStyle {
    var backgroundColor: Color = primaryGreen
    var foregroundColor: Color = .white
    var borderColor: Color = textFieldBorderGray

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(borderColor, lineWidth: 1))
            .shadow(radius: 2)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
    }
}

// Custom TextField modifier to match your design mockup
struct CustomTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(RoundedRectangle(cornerRadius: 5).stroke(textFieldBorderGray, lineWidth: 1))
            .shadow(radius: 1)
    }
}

// Apply the custom modifier to TextFields
extension View {
    func customTextFieldStyle() -> some View {
        self.modifier(CustomTextFieldModifier())
    }
}


// Custom Navigation Bar Color
extension UINavigationController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.standardAppearance.backgroundColor = UIColor(primaryGreen)
    }
}

// Use this extension to change the color of the navigation bar
extension View {
    func navigationBarColor(backgroundColor: Color, textColor: Color) -> some View {
        let uiBackgroundColor = UIColor(backgroundColor)
        let uiTextColor = UIColor(textColor)
        return self.modifier(NavigationBarModifier(backgroundColor: uiBackgroundColor, textColor: uiTextColor))
    }
}


struct NavigationBarModifier: ViewModifier {
    var backgroundColor: UIColor
    var textColor: UIColor

    func body(content: Content) -> some View {
        content
            .onAppear {
                let coloredAppearance = UINavigationBarAppearance()
                coloredAppearance.configureWithOpaqueBackground()
                coloredAppearance.backgroundColor = backgroundColor
                coloredAppearance.titleTextAttributes = [.foregroundColor: textColor]
                coloredAppearance.largeTitleTextAttributes = [.foregroundColor: textColor]
                
                UINavigationBar.appearance().standardAppearance = coloredAppearance
                UINavigationBar.appearance().compactAppearance = coloredAppearance
                UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
            }
    }
}



// Implementations of PieChartView, PieChartKeyView, and PieChartSliceView...

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct PieChartView: View {
    var data: [(String, Double)] // Data type remains as an array of tuples
    var colors: [Color] = [Color.red, Color.green, Color.blue, Color.orange, Color.purple, Color.yellow, Color.pink, Color.gray, Color.cyan, Color.indigo, Color.brown]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<data.count, id: \.self) { index in
                    let startAngle = angle(at: index, in: data.map { $0.1 })
                    let endAngle = angle(at: index + 1, in: data.map { $0.1 })
                    PieChartSliceView(startAngle: startAngle, endAngle: endAngle, color: colors[index % colors.count])
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private func angle(at index: Int, in data: [Double]) -> Angle {
        let total = data.reduce(0, +)
        let start = data.prefix(index).reduce(0, +) / total
        return .degrees(start * 360)
    }
}

struct PieChartKeyView: View {
    var data: [String: Double]
    var colors: [Color] = [Color.red, Color.green, Color.blue, Color.orange, Color.purple, Color.yellow, Color.pink, Color.gray, Color.cyan, Color.indigo, Color.brown]

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(data.sorted(by: { $0.value > $1.value }), id: \.key) { key, value in
                HStack {
                    Circle()
                        .fill(colors[data.keys.sorted(by: { data[$0]! > data[$1]! }).firstIndex(of: key)! % colors.count])
                        .frame(width: 10, height: 10)
                    Text("\(key): \(value, specifier: "%.2f")%")
                }
            }
        }
    }
}

struct PieChartSliceView: View {
    var startAngle: Angle
    var endAngle: Angle
    var color: Color

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                let radius = min(geometry.size.width, geometry.size.height) / 2
                path.move(to: center)
                path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            }
            .fill(color)
        }
    }
}

struct MonthlyExpenseTextField: View {
    var category: String
    @Binding var value: String

    var body: some View {
        TextField(category, text: $value)
            .keyboardType(.decimalPad).customTextFieldStyle()
    }
}

struct AddCategoryView: View {
    @Binding var newCategoryName: String
    @Binding var additionalExpenses: [String: String]

    var body: some View {
        HStack {
            TextField("New Category", text: $newCategoryName)
                .customTextFieldStyle()
            Button("Add") {
                if !newCategoryName.isEmpty {
                    additionalExpenses[newCategoryName] = ""
                    newCategoryName = ""
                }
            }
            .buttonStyle(PrimaryButtonStyle(backgroundColor: primaryGreen, foregroundColor: Color.white))
        }
    }
}


