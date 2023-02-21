import ComposableArchitecture
import SwiftUI

struct AppointmentListFeature: ReducerProtocol {
    @Dependency(\.apiClient) var apiClient
    private enum APIRequestCancellationID {}
    
    struct State: Equatable {
        var appointments: IdentifiedArrayOf<AppointmentDetailFeature.State> = []
        
        /// Displays a loading state indicator
        var isLoading: Bool = false
    }
    
    enum Action: Equatable {
        case didAppear
        case appointments(TaskResult<AppointmentResponse>)
        case appointment(id: AppointmentDetailFeature.State.ID, action: AppointmentDetailFeature.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .didAppear:
                state.isLoading = true
                return .task {
                    return await .appointments(TaskResult {
                        try await apiClient
                            .fetchAppointments()
                    })
                }
                .cancellable(id: APIRequestCancellationID.self)
                
            case let .appointments(.success(response)):
                state.isLoading = false
                let appointments = response.appointments
                    .map { AppointmentDetailFeature.State(appointment: $0) }
                state.appointments = .init(uniqueElements: appointments)
                return .none
                
            case let .appointments(.failure(error)):
                state.isLoading = false
                return .none
                
            case .appointment:
                return .none
            }
        }
    }
}

struct AppointmentsListView: View {
    let store: StoreOf<AppointmentListFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ScrollView {
                ForEachStore(
                    store.scope(
                        state: \.appointments,
                        action: AppointmentListFeature.Action.appointment(id:action:)
                    )
                ) {
                    AppointmentDetailView(store: $0)
                }
                
            }
            .overlay {
                if viewStore.isLoading {
                    Text("loading")
                }
            }
            .onAppear {
                viewStore.send(.didAppear)
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
                reducer: AppointmentListFeature()
            )
        )
    }
}
#endif
