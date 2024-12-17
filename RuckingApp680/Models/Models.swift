import Foundation

enum GearCategory: String, CaseIterable {
    case Vest, Stone, Backpack, Sandbag
}

struct GearItem: Identifiable, Hashable {
    let id: UUID
    var name: String
    var weight: Double
    var category: GearCategory
    
    init(id: UUID = UUID(), name: String, weight: Double, category: GearCategory) {
        self.id = id
        self.name = name
        self.weight = weight
        self.category = category
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: GearItem, rhs: GearItem) -> Bool {
        lhs.id == rhs.id
    }
}

struct Workout: Identifiable {
    let id = UUID()
    var date: Date
    var distance: Double
    var duration: TimeInterval
    var selectedGear: [GearItem]
    var calories: Double
    var routeName: String?
    
    var totalGearWeight: Double {
        selectedGear.reduce(0) { $0 + $1.weight }
    }
    
    var pace: TimeInterval {
        distance > 0 ? duration / distance : 0
    }
}

struct Route: Identifiable, Hashable {
    let id: UUID
    var name: String
    var distance: Double
    
    init(id: UUID = UUID(), name: String, distance: Double) {
        self.id = id
        self.name = name
        self.distance = distance
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Route, rhs: Route) -> Bool {
        lhs.id == rhs.id
    }
}
