import ComposableArchitecture
import SwiftUI
import XCTestDynamicOverlay

struct MainApp: ReducerProtocol {
    
    struct State: Equatable {
        /// This holds the state for our AppointmentsList feature.
        var appointments: AppointmentsListFeature.State = .init()
    }
    
    enum Action: Equatable {
        case appResumed
        case appBackgrounded
        case appointments(AppointmentsListFeature.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.appointments, action: /Action.appointments) {
            AppointmentsListFeature()
        }
        Reduce { state, action in
            switch action {
            case .appResumed:
                return .none
                
            case .appBackgrounded:
                return .none
                
            case .appointments:
                return .none
                
            }
        }
    }
}

@main
struct AppointmentsApp: App {
    let store: StoreOf<MainApp> = .init(
        initialState: .init(),
        reducer: MainApp()
    )
    
    @Environment(\.scenePhase)
    private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            if !_XCTIsTesting {
                WithViewStore(store, observe: { $0 }) { viewStore in
                    AppointmentsListView(
                        store: store.scope(
                            state: \.appointments,
                            action: MainApp.Action.appointments
                        )
                    )
                    .onChange(of: scenePhase) { (newScenePhase) in
                        let viewStore = ViewStore(store)
                        switch (scenePhase, newScenePhase) {
                        case (.inactive, .active):
                            viewStore.send(.appResumed)
                        case (.active, .inactive):
                            viewStore.send(.appBackgrounded)
                        default:
                            break
                        }
                    }
                }
            }
        }
    }
}
