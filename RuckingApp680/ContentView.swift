import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            WorkoutHistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.fill")
                }
            
            NewWorkoutView()
                .tabItem {
                    Label("New Workout", systemImage: "plus.circle.fill")
                }

            MapView()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
            
            GearView()
                .tabItem {
                    Label("My Gear", systemImage: "dumbbell.fill")
                }
        }
    }
}