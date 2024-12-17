import SwiftUI

struct GearView: View {
    @EnvironmentObject private var gearStore: GearStore
    @State private var isAddingGear = false
    @State private var selectedGear: GearItem?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(gearStore.gearItems) { item in
                    GearItemRow(itemId: item.id)
                        .onTapGesture {
                            selectedGear = item
                        }
                }
                .onDelete(perform: deleteGear)
            }
            .navigationTitle("Gear")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isAddingGear = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddingGear) {
                GearFormView(isPresented: $isAddingGear)
            }
            .sheet(item: $selectedGear) { gear in
                GearFormView(isPresented: .init(
                    get: { selectedGear != nil },
                    set: { if !$0 { selectedGear = nil } }
                ), gear: gear)
            }
        }
    }
    
    private func deleteGear(at offsets: IndexSet) {
        offsets.forEach { index in
            let gear = gearStore.gearItems[index]
            gearStore.deleteGearItem(gear)
        }
    }
}

struct GearItemRow: View {
    @EnvironmentObject private var gearStore: GearStore
    let itemId: UUID
    
    private var item: GearItem {
        gearStore.gearItems.first { $0.id == itemId }!
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(item.name)
                .font(.headline)
            HStack {
                Text("\(String(format: "%.1f", item.weight)) lbs")
                    .foregroundColor(.secondary)
                Spacer()
                Text(item.category.rawValue)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.secondary.opacity(0.2))
                    .cornerRadius(8)
            }
        }
        .padding(.vertical, 4)
    }
}

struct GearFormView: View {
    @EnvironmentObject private var gearStore: GearStore
    @Binding var isPresented: Bool
    @State private var showingDeleteAlert = false
    
    var gear: GearItem?
    
    @State private var name: String = ""
    @State private var weight: String = ""
    @State private var category: GearCategory = .Backpack
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                TextField("Weight (lbs)", text: $weight)
                    .keyboardType(.decimalPad)
                Picker("Category", selection: $category) {
                    ForEach(GearCategory.allCases, id: \.self) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
                
                if gear != nil {
                    Section {
                        Button(role: .destructive, action: {
                            showingDeleteAlert = true
                        }) {
                            HStack {
                                Spacer()
                                Text("Delete Gear")
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationTitle(gear == nil ? "Add Gear" : "Edit Gear")
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                },
                trailing: Button("Save") {
                    saveGear()
                    isPresented = false
                }
            )
            .alert("Delete Gear", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    if let gear = gear {
                        gearStore.deleteGearItem(gear)
                        isPresented = false
                    }
                }
            } message: {
                Text("Are you sure you want to delete this gear item?")
            }
            .onAppear {
                if let gear = gear {
                    name = gear.name
                    weight = String(gear.weight)
                    category = gear.category
                }
            }
        }
    }
    
    private func saveGear() {
        guard let weightValue = Double(weight) else { return }
        
        if let existingGear = gear {
            let updatedGear = GearItem(
                id: existingGear.id,
                name: name,
                weight: weightValue,
                category: category
            )
            gearStore.updateGearItem(updatedGear)
        } else {
            gearStore.addGearItem(
                name: name,
                weight: weightValue,
                category: category
            )
        }
    }
}