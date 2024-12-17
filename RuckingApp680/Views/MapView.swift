import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.3361, longitude: -122.0090),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )
    @State private var isTracking = false
    @State private var routeCoordinates: [CLLocationCoordinate2D] = []
    
    var body: some View {
        ZStack {
            Map {
                UserAnnotation()
            }
            .mapStyle(.standard)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                Button(action: {
                    isTracking.toggle()
                    if !isTracking {
                        // Save workout
                    }
                }) {
                    Text(isTracking ? "Stop Workout" : "Start Workout")
                        .padding()
                        .background(isTracking ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom)
            }
        }
    }
}
