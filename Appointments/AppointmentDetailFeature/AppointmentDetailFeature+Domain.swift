import ComposableArchitecture

struct AppointmentDetailFeature: ReducerProtocol {
    
    struct State: Equatable, Identifiable {
        var id: String { appointment.id }
        var appointment: Appointment
        
        var name: String {
            appointment.user.firstName + " " + appointment.user.lastName
        }
        
        var initials: String {
            return name.components(separatedBy: " ")
                .reduce("") {
                    ($0.isEmpty ? "" : "\($0.first?.uppercased() ?? "")") +
                    ($1.isEmpty ? "" : "\($1.first?.uppercased() ?? "")")
                }
        }
        
        var displayInitials: Bool {
            return appointment.status != .readyToJoin && appointment.status != .responseRequired
        }
    }
    
    enum Action: Equatable {
        case didTapAccept
        case didTapDecline
        case didTapJoinAppointment
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
                
            case .didTapAccept:
                state.appointment.status = .active
                return .none
                
            case .didTapDecline:
                state.appointment.status = .completed
                return .none
                
            case .didTapJoinAppointment:
                // we would do something here, but it's out of scope
                return .none
            }
        }
    }
}
