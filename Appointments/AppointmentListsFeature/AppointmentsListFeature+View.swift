import ComposableArchitecture
import SwiftUI

struct Appointment: Equatable, Identifiable {
    var id: String
    var user: User
    var status: Status
    
    enum Status: String, Equatable {
        case readyToJoin = "INITIATED"
        case responseRequired = "REQUESTED"
        case active = "ACTIVE"
        case completed = "COMPLETED"
    }
}

struct User: Equatable, Identifiable, Codable {
    var id: String
    var firstName: String
    var lastName: String
    
    var initials: String {
        var result = ""
        if let firstNameFirst = firstName.first {
            result.append(firstNameFirst)
        }
        if let lastNameFirst = lastName.first {
            result.append(lastNameFirst)
        }
        return result
    }
}

struct AppointmentsListFeature: ReducerProtocol {
    
    struct State: Equatable {
        var appointments: IdentifiedArrayOf<AppointmentDetailFeature.State> = []
    }
    
    enum Action: Equatable {
        case appointment(id: AppointmentDetailFeature.State.ID, action: AppointmentDetailFeature.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            return .none
        }
    }
}



#if DEBUG
extension AppointmentsListFeature.State {
    static var sample: Self {
        .init(
            appointments: [
                .init(
                    appointment: .init(
                        id: "first",
                        user: .init(
                            id: "1",
                            firstName: "Peter",
                            lastName: "Alt"
                        ),
                        status: .readyToJoin
                    )
                ),
                
                    .init(
                        appointment: .init(
                            id: "second",
                            user: .init(
                                id: "2",
                                firstName: "Peter",
                                lastName: "Alt"
                            ),
                            status: .responseRequired
                        )
                    ),
                
                    .init(
                        appointment: .init(
                            id: "third",
                            user: .init(
                                id: "3",
                                firstName: "Peter",
                                lastName: "Alt"
                            ),
                            status: .active
                        )
                    ),
                
                    .init(
                        appointment: .init(
                            id: "fourth",
                            user: .init(
                                id: "4",
                                firstName: "Peter",
                                lastName: "Alt"
                            ),
                            status: .completed
                        )
                    )
            ]
        )
    }
}
#endif

struct AppointmentsListView: View {
    let store: StoreOf<AppointmentsListFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ScrollView {
                ForEachStore(
                    store.scope(
                        state: \.appointments,
                        action: AppointmentsListFeature.Action.appointment(id:action:)
                    )
                ) {
                    AppointmentDetailView(store: $0)
                }
                
            }
        }
    }
}

#if DEBUG
struct AppointmentsList_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentsListView(
            store: .init(
                initialState: .sample,
                reducer: AppointmentsListFeature()
            )
        )
    }
}
#endif
