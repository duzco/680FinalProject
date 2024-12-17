import SwiftUI

@main
struct RuckingApp680App: App {
    @StateObject private var workoutStore = WorkoutStore()
    @StateObject private var gearStore = GearStore()
    @StateObject private var routeStore = RouteStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(workoutStore)
                .environmentObject(gearStore)
                .environmentObject(routeStore)
        }
    }
} 