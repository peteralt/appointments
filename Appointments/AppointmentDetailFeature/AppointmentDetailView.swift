import ComposableArchitecture
import SwiftUI

extension Appointment.Status {
    var color: Color {
        switch self {
        case .responseRequired:
            return Color("Pawp Brilliant Blue")
        case .readyToJoin:
            return Color("Pawp Live Green")
        case .active:
            return Color("Unread Profile Color")
        case .completed:
            return Color("Read Profile Color")
        }
    }
    
    var icon: Image {
        switch self {
        case .responseRequired:
            return Image("Request to book")
        case .readyToJoin:
            return Image("Notification")
        default:
            return Image(systemName: "circle.fill")
        }
    }
}

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
                return .none
                
            case .didTapDecline:
                return .none
                
            case .didTapJoinAppointment:
                return .none
            }
        }
    }
}

struct AppointmentDetailView: View {
    let store: StoreOf<AppointmentDetailFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                HStack(alignment: .top) {
                    HStack {
                        Circle()
                            .foregroundColor(viewStore.appointment.status.color)
                            .frame(width: 8, height: 8)
                            .padding(.trailing, 9)
                            .opacity(viewStore.appointment.status != .completed ? 1 : 0)
                        
                        viewStore.appointment.status.icon
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32)
                            .foregroundColor(viewStore.appointment.status.color)
                            .overlay {
                                if viewStore.displayInitials {
                                    Text(viewStore.initials)
                                        .font(.caption2)
                                        .fontWeight(.heavy)
                                }
                            }
                    }
                    
                    VStack(alignment: .leading) {
                        if !viewStore.displayInitials {
                            Text("Status")
                                .foregroundColor(viewStore.appointment.status.color)
                                .font(.caption2)
                        }
                        Text(viewStore.name)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Text("Message frg erogijmert gtiomgiopt mhthio khoy vr gre get gt gt tr")
                            .font(.caption)
                        
                        HStack {
                            switch viewStore.appointment.status {
                            case .responseRequired:
                                ButtonView(
                                    title: "Accept",
                                    didTap: {},
                                    color: viewStore.appointment.status.color
                                )
                                ButtonView(
                                    title: "Decline",
                                    didTap: {},
                                    color: Appointment.Status.completed.color
                                )
                                
                            case .readyToJoin:
                                ButtonView(
                                    title: "Join Appointment",
                                    didTap: {},
                                    color: viewStore.appointment.status.color
                                )
                                
                            default:
                                EmptyView()
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                    
                    Spacer()
                    
                    Text("Time")
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .padding(.leading, 17)
                .padding(.trailing, 24)
                
            }
        }
    }
}

struct AppointmentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentDetailView(
            store: .init(
                initialState: .init(
                    appointment: .init(
                        id: "1",
                        user: .init(id: 1, firstName: "Peter", lastName: "Alt"),
                        status: .responseRequired
                    )
                ),
                reducer: AppointmentDetailFeature()
            )
        )
        .previewDisplayName("Response Required")
        
        AppointmentDetailView(
            store: .init(
                initialState: .init(
                    appointment: .init(
                        id: "2",
                        user: .init(id: 2, firstName: "Peter", lastName: "Alt"),
                        status: .readyToJoin
                    )
                ),
                reducer: AppointmentDetailFeature()
            )
        )
        .previewDisplayName("Ready to join")
        
        AppointmentDetailView(
            store: .init(
                initialState: .init(
                    appointment: .init(
                        id: "3",
                        user: .init(id: 3, firstName: "Peter", lastName: "Alt"),
                        status: .active
                    )
                ),
                reducer: AppointmentDetailFeature()
            )
        )
        .previewDisplayName("Active")
        
        AppointmentDetailView(
            store: .init(
                initialState: .init(
                    appointment: .init(
                        id: "4",
                        user: .init(id: 4, firstName: "Peter", lastName: "Alt"),
                        status: .completed
                    )
                ),
                reducer: AppointmentDetailFeature()
            )
        )
        .previewDisplayName("Completed")
        .previewLayout(.sizeThatFits)
    }
}
