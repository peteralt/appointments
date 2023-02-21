import Foundation

struct Appointment: Codable, Equatable, Identifiable {
    var id: String
    var user: User
    var status: Status
    
    enum Status: String, Codable, Equatable {
        case readyToJoin = "INITIATED"
        case responseRequired = "REQUESTED"
        case active = "ACTIVE"
        case completed = "COMPLETED"
    }
}
