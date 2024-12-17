import SwiftUI

struct NewWorkoutView: View {
    @EnvironmentObject private var workoutStore: WorkoutStore
    @EnvironmentObject private var gearStore: GearStore
    @EnvironmentObject private var routeStore: RouteStore
    
    @State private var distance: String = ""
    @State private var selectedHours = 0
    @State private var selectedMinutes = 0
    @State private var selectedSeconds = 0
    @State private var selectedGear: Set<GearItem> = []
    @State private var selectedRoute: Route?
    
    var totalWeight: Double {
        selectedGear.reduce(0) { $0 + $1.weight }
    }
    
    var groupedGear: [(GearCategory, [GearItem])] {
        Dictionary(grouping: gearStore.gearItems) { $0.category }
            .sorted { $0.key.rawValue < $1.key.rawValue }
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Route Selection Section
                Section(header: Text("Route")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            RouteCard(route: nil, isSelected: selectedRoute == nil)
                                .onTapGesture { selectedRoute = nil }
                            
                            ForEach(routeStore.routes) { route in
                                RouteCard(route: route, isSelected: selectedRoute?.id == route.id)
                                    .onTapGesture { selectedRoute = route }
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                    .listRowInsets(EdgeInsets())
                    
                    if selectedRoute == nil {
                        TextField("Distance (miles)", text: $distance)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                
                // Duration Section
                Section(header: Text("Duration")) {
                    HStack {
                        TimePickerColumn(value: $selectedHours, range: 0..<24, label: "hr")
                        Text(":").font(.title3)
                        TimePickerColumn(value: $selectedMinutes, range: 0..<60, label: "min")
                        Text(":").font(.title3)
                        TimePickerColumn(value: $selectedSeconds, range: 0..<60, label: "sec")
                    }
                    .padding(.vertical, -8)
                }
                
                // Gear Selection Section
                Section(header: Text("Gear"), footer: Text("Total Weight: \(String(format: "%.1f", totalWeight)) lbs")) {
                    ForEach(groupedGear, id: \.0) { category, items in
                        DisclosureGroup(category.rawValue) {
                            ForEach(items) { item in
                                GearCard(
                                    item: item,
                                    isSelected: selectedGear.contains(item)
                                ) {
                                    if selectedGear.contains(item) {
                                        selectedGear.remove(item)
                                    } else {
                                        selectedGear.insert(item)
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Save Button Section
                Section {
                    Button(action: saveWorkout) {
                        Text("Save Workout")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.blue)
                }
            }
            .navigationTitle("New Workout")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func saveWorkout() {
        let distanceValue: Double
        let routeName: String?
        
        if let route = selectedRoute {
            distanceValue = route.distance
            routeName = route.name
        } else {
            guard let customDistance = Double(distance) else { return }
            distanceValue = customDistance
            routeName = nil
        }
        
        let duration = Double(selectedHours * 3600 + selectedMinutes * 60 + selectedSeconds)
        
        workoutStore.addWorkout(
            distance: distanceValue,
            duration: duration,
            selectedGear: Array(selectedGear),
            routeName: routeName
        )
        
        // Reset form
        distance = ""
        selectedHours = 0
        selectedMinutes = 0
        selectedSeconds = 0
        selectedGear.removeAll()
        selectedRoute = nil
    }
}

// Supporting Views
struct RouteCard: View {
    let route: Route?
    let isSelected: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(route?.name ?? "Custom Distance")
                .font(.headline)
            if let route = route {
                Text(String(format: "%.1f miles", route.distance))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(width: 160)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: isSelected ? .blue.opacity(0.3) : .gray.opacity(0.2), radius: 8)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
    }
}

struct TimePickerColumn: View {
    @Binding var value: Int
    let range: Range<Int>
    let label: String
    
    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection: $value) {
                ForEach(range, id: \.self) { number in
                    Text(String(format: "%02d", number))
                        .tag(number)
                        .monospacedDigit()
                }
            }
            .pickerStyle(.wheel)
            .frame(width: 45, height: 80)
            .clipped()
            
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
                .padding(.top, 2)
        }
    }
}

struct GearCard: View {
    let item: GearItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.headline)
                    Text("\(String(format: "%.1f", item.weight)) lbs")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .blue : .gray)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}