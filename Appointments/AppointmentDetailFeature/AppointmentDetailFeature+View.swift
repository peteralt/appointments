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
    
    var actionTitle: String? {
        switch self {
        case .responseRequired:
            return "Request to book"
        case .readyToJoin:
            return "Starting soon"
        default:
            return nil
        }
    }
}

extension Appointment {
    var relativeTime: String {
        let formatter = RelativeDateTimeFormatter()
        return formatter.localizedString(for: startTime, relativeTo: .now)
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    var formattedLastMessage: String {
        switch status {
        case .responseRequired:
            return "\(user.firstName) has requested an appointment on \(self.dateFormatter.string(from: startTime))."
        case .readyToJoin:
            return "Your appointment with \(user.firstName) begins in \(relativeTime) minutes"
        default:
            return lastMessage ?? ""
        }
    }
    
    var displayedTime: Date? {
        switch status {
        case .responseRequired, .readyToJoin:
            return requestedAt
        default:
            return lastMessageAt
        }
    }
}

struct AppointmentDetailView: View {
    let store: StoreOf<AppointmentDetailFeature>
    
    static var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }
    
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
                        if let actionTitle = viewStore.appointment.status.actionTitle {
                            Text(actionTitle)
                                .foregroundColor(viewStore.appointment.status.color)
                                .font(.caption2)
                        }
                        Text(viewStore.name)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Text(viewStore.appointment.formattedLastMessage)
                            .font(.caption)
                        
                        HStack {
                            switch viewStore.appointment.status {
                            case .responseRequired:
                                ButtonView(
                                    title: "Accept",
                                    didTap: { viewStore.send(.didTapAccept) },
                                    color: viewStore.appointment.status.color
                                )
                                ButtonView(
                                    title: "Decline",
                                    didTap: { viewStore.send(.didTapDecline) },
                                    color: Appointment.Status.completed.color
                                )
                                
                            case .readyToJoin:
                                ButtonView(
                                    title: "Join Appointment",
                                    didTap: { viewStore.send(.didTapJoinAppointment) },
                                    color: viewStore.appointment.status.color
                                )
                                
                            default:
                                EmptyView()
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                    
                    Spacer()
                    
                    if let date = viewStore.appointment.displayedTime {
                        Text(Self.timeFormatter.string(from: date))
                            .font(.caption)
                            .fontWeight(.medium)
                            .fixedSize()
                    }
                    
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
                        status: .responseRequired,
                        startTime: .now,
                        endTime: .distantFuture,
                        requestedAt: .distantPast
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
                        status: .readyToJoin,
                        startTime: .now,
                        endTime: .distantFuture,
                        requestedAt: .distantPast
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
                        status: .active,
                        lastMessage: "What do you think about this?",
                        startTime: .now,
                        endTime: .distantFuture,
                        requestedAt: .distantPast
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
                        status: .completed,
                        lastMessage: "Thank you",
                        startTime: .now,
                        endTime: .distantFuture,
                        requestedAt: .distantPast
                    )
                ),
                reducer: AppointmentDetailFeature()
            )
        )
        .previewDisplayName("Completed")
        .previewLayout(.sizeThatFits)
    }
}
