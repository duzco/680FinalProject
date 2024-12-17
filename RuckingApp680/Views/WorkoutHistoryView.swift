import SwiftUI

struct WorkoutHistoryView: View {
    @EnvironmentObject private var workoutStore: WorkoutStore
    @State private var selectedWorkout: Workout?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(workoutStore.workouts.sorted(by: { $0.date > $1.date })) { workout in
                    WorkoutRow(workout: workout)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedWorkout = workout
                        }
                }
                .onDelete(perform: deleteWorkout)
            }
            .navigationTitle("History")
            .sheet(item: $selectedWorkout) { workout in
                WorkoutDetailView(workout: workout)
            }
        }
    }
    
    private func deleteWorkout(at offsets: IndexSet) {
        offsets.forEach { index in
            let workout = workoutStore.workouts.sorted(by: { $0.date > $1.date })[index]
            workoutStore.deleteWorkout(workout)
        }
    }
}

struct WorkoutRow: View {
    let workout: Workout
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(workout.date.formatted(date: .abbreviated, time: .shortened))
                .font(.headline)
            
            HStack {
                Text(String(format: "%.1f miles", workout.distance))
                Spacer()
                Text("\(formatDuration(workout.duration))")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            
            Text("Total Weight: \(String(format: "%.1f lbs", workout.totalGearWeight))")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

struct WorkoutDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var workoutStore: WorkoutStore
    let workout: Workout
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Workout Details")) {
                    LabeledContent("Date", value: workout.date.formatted(date: .long, time: .shortened))
                    LabeledContent("Distance", value: String(format: "%.1f miles", workout.distance))
                    LabeledContent("Duration", value: formatDuration(workout.duration))
                    LabeledContent("Pace", value: formatDuration(workout.pace) + "/mile")
                    LabeledContent("Calories", value: String(format: "%.0f", workout.calories))
                }
                
                Section(header: Text("Gear Used")) {
                    ForEach(workout.selectedGear) { gear in
                        HStack {
                            Text(gear.name)
                            Spacer()
                            Text("\(String(format: "%.1f", gear.weight)) lbs")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    HStack {
                        Text("Total Weight")
                            .bold()
                        Spacer()
                        Text("\(String(format: "%.1f", workout.totalGearWeight)) lbs")
                            .bold()
                    }
                }
            }
            .navigationTitle("Workout Details")
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}