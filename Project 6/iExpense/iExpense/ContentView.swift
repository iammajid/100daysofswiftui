//
//  ContentView.swift
//  iExpense
//
//  Created by Majid Achhoud on 30.11.23.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoder = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoder, forKey: "Items")
            }
        }
    }
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        items = []
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    
    @State private var showingAddExpense = false
    
    var body: some View {
            NavigationStack {
                List {
                    Section(header: Text("Personal Expenses")) {
                        ForEach(expenses.items.filter { $0.type == "Personal" }) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                    
                                    Text(item.type)
                                }
                                
                                Spacer()
                                
                                Text(item.amount, format: .currency(code: "EUR"))
                                    .foregroundColor(item.amount >= 100 ? .red : (item.amount <= 10 ? .green : .yellow))
                            }
                        }
                        .onDelete(perform: removeItems)
                    }

                    Section(header: Text("Business Expenses")) {
                        ForEach(expenses.items.filter { $0.type == "Business" }) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                    
                                    Text(item.type)
                                }
                                
                                Spacer()
                                
                                Text(item.amount, format: .currency(code: "EUR"))
                                    .foregroundColor(item.amount >= 100 ? .red : (item.amount <= 10 ? .green : .yellow))
                            }
                        }
                        .onDelete(perform: removeItems)
                    }
                }
                .navigationTitle("iExpense")
                .toolbar {
                    Button("Add Expense", systemImage: "plus") {
                        showingAddExpense = true
                    }
                }
                .sheet(isPresented: $showingAddExpense) {
                    AddView(expenses: expenses)
                }
            }
        }

        func removeItems(at offsets: IndexSet) {
            expenses.items.remove(atOffsets: offsets)
        }
    }

#Preview {
    ContentView()
}
