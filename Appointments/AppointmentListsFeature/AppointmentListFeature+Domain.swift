import ComposableArchitecture

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
                
            case .appointments(.failure):
                // We're not handling any errors right now, we could capture
                // the error here and display an error message in the future.
                state.isLoading = false
                return .none
                                
            case .appointment:
                return .none
            }
        }
        .forEach(\.appointments, action: /Action.appointment(id:action:)) {
            AppointmentDetailFeature()
        }
    }
}
