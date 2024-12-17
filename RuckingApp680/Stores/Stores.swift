import Foundation

class WorkoutStore: ObservableObject {
    @Published var workouts: [Workout] = []
    
    init() {
        // Get example gear
        let gearStore = GearStore()
        let rucker = gearStore.gearItems.first { $0.name == "GORUCK Rucker 4.0" }!
        let plate20 = gearStore.gearItems.first { $0.name == "20lb Plate" }!
        let sandbag = gearStore.gearItems.first { $0.name == "30lb Sandbag" }!
        
        // Get example routes
        let routeStore = RouteStore()
        let neighborhoodLoop = routeStore.routes.first { $0.name == "Neighborhood Loop" }!
        let parkTrail = routeStore.routes.first { $0.name == "Park Trail" }!
        let riverRun = routeStore.routes.first { $0.name == "River Run" }!
        
        // Create example workouts from the past 5 days
        let calendar = Calendar.current
        let now = Date()
        
        let exampleWorkouts = [
            // Today's workout
            createWorkout(
                date: now,
                route: riverRun,
                duration: 3600, // 1 hour
                gear: [rucker, plate20]
            ),
            
            // Yesterday's workout
            createWorkout(
                date: calendar.date(byAdding: .day, value: -1, to: now)!,
                route: parkTrail,
                duration: 2700, // 45 minutes
                gear: [rucker, sandbag]
            ),
            
            // 2 days ago
            createWorkout(
                date: calendar.date(byAdding: .day, value: -2, to: now)!,
                route: neighborhoodLoop,
                duration: 1800, // 30 minutes
                gear: [rucker, plate20]
            ),
            
            // 3 days ago
            createWorkout(
                date: calendar.date(byAdding: .day, value: -3, to: now)!,
                route: riverRun,
                duration: 4500, // 1 hour 15 minutes
                gear: [rucker, plate20, sandbag]
            ),
            
            // 4 days ago
            createWorkout(
                date: calendar.date(byAdding: .day, value: -4, to: now)!,
                route: parkTrail,
                duration: 2400, // 40 minutes
                gear: [rucker, plate20]
            )
        ]
        
        workouts = exampleWorkouts
    }
    
    private func createWorkout(date: Date, route: Route, duration: TimeInterval, gear: [GearItem]) -> Workout {
        Workout(
            date: date,
            distance: route.distance,
            duration: duration,
            selectedGear: gear,
            calories: calculateCalories(
                distance: route.distance,
                duration: duration,
                totalWeight: gear.reduce(0) { $0 + $1.weight }
            ),
            routeName: route.name
        )
    }
    
    func addWorkout(distance: Double, duration: TimeInterval, selectedGear: [GearItem], routeName: String? = nil) {
        let workout = Workout(
            date: Date(),
            distance: distance,
            duration: duration,
            selectedGear: selectedGear,
            calories: calculateCalories(distance: distance, duration: duration, totalWeight: selectedGear.reduce(0) { $0 + $1.weight }),
            routeName: routeName
        )
        workouts.append(workout)
    }
    
    func deleteWorkout(_ workout: Workout) {
        workouts.removeAll { $0.id == workout.id }
    }
    
    func updateWorkout(_ workout: Workout) {
        if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
            workouts[index] = workout
        }
    }
    
    private func calculateCalories(distance: Double, duration: TimeInterval, totalWeight: Double) -> Double {
        let durationInMinutes = duration / 60
        return distance * (totalWeight * 0.1) * (durationInMinutes * 0.05)
    }
}

class GearStore: ObservableObject {
    @Published var gearItems: [GearItem] = []
    
    init() {
        // Add example gear items
        let exampleGear = [
            GearItem(name: "GORUCK Rucker 4.0", weight: 45.0, category: .Backpack),
            GearItem(name: "20lb Plate", weight: 20.0, category: .Vest),
            GearItem(name: "30lb Sandbag", weight: 30.0, category: .Sandbag),
            GearItem(name: "40lb Stone", weight: 40.0, category: .Stone)
        ]
        gearItems = exampleGear
    }
    
    func addGearItem(name: String, weight: Double, category: GearCategory) {
        let item = GearItem(name: name, weight: weight, category: category)
        gearItems.append(item)
    }
    
    func deleteGearItem(_ item: GearItem) {
        gearItems.removeAll { $0.id == item.id }
    }
    
    func updateGearItem(_ item: GearItem) {
        if let index = gearItems.firstIndex(where: { $0.id == item.id }) {
            var updatedItems = gearItems
            updatedItems[index] = item
            gearItems = updatedItems
        }
    }
}

class RouteStore: ObservableObject {
    @Published var routes: [Route] = []
    
    init() {
        // Add example routes
        let exampleRoutes = [
            Route(name: "Neighborhood Loop", distance: 2.0),
            Route(name: "Park Trail", distance: 3.1),
            Route(name: "River Run", distance: 4.5),
            Route(name: "Downtown Circuit", distance: 5.0)
        ]
        routes = exampleRoutes
    }
}
