
import SwiftUI

struct FinancialDashboardView: View {
    let videoLinks = [
        ("Financial Literacy - Video 1", "https://www.youtube.com/watch?v=4j2emMn7UaI"),
        ("Financial Literacy - Video 2", "https://www.youtube.com/watch?v=0iRbD5rM5qc")
        // Add more links as needed
    ]

    let textLinks = [
        ("Why Financial Literacy Is So Important?", "https://www.forbes.com/sites/truetamplin/2023/09/21/financial-literacy--meaning-components-benefits--strategies/?sh=753cbad868cd"),
        ("From Saving to Paying Debts", "https://www.cnbc.com/2022/04/01/why-financial-literacy-is-so-important.html")
        // Add more links as needed
    ]

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Financial Literacy Videos")) {
                    ForEach(videoLinks, id: \.1) { link in
                        Link(link.0, destination: URL(string: link.1)!)
                    }
                }

                Section(header: Text("Financial Literacy Texts")) {
                    ForEach(textLinks, id: \.1) { link in
                        Link(link.0, destination: URL(string: link.1)!)
                    }
                }
            }
            .navigationBarTitle("Financial Dashboard")
        }
    }
}



#Preview {
    FinancialDashboardView()
}

