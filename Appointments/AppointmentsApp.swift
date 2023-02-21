import ComposableArchitecture
import SwiftUI
import XCTestDynamicOverlay

struct MainApp: ReducerProtocol {
    
    struct State: Equatable {
        /// This holds the state for our AppointmentsList feature.
        var appointments: AppointmentListFeature.State = .init()
    }
    
    enum Action: Equatable {
        case appResumed
        case appBackgrounded
        case appointments(AppointmentListFeature.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.appointments, action: /Action.appointments) {
            AppointmentListFeature()
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
        ._printChanges()
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
    
    // This is purposefully handled outside of the TCA state, because
    // none of the other features do any work and it would be
    // premature optimization to embed it into the state.
    @State var selectedTab: Int = 1
    
    var body: some Scene {
        WindowGroup {
            if !_XCTIsTesting {
                NavigationView {
                    WithViewStore(store, observe: { $0 }) { viewStore in
                        TabView(selection: $selectedTab) {
                            Text("RX")
                                .tabItem {
                                    Label("", image: "rx")
                                }
                                .tag(0)
                            
                            AppointmentsListView(
                                store: store.scope(
                                    state: \.appointments,
                                    action: MainApp.Action.appointments
                                )
                            )
                            .tabItem {
                                Label("", image: "calendar")
                            }
                            .tag(1)
                            
                            Text("Payments")
                                .tabItem {
                                    Label("", image: "payments")
                                }
                                .tag(2)
                            
                            Text("Performance")
                                .tabItem {
                                    Label("", image: "performance")
                                }
                                .tag(3)
                        }
                        .navigationTitle("Appointments")
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
}
