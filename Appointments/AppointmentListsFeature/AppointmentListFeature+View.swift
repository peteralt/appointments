import ComposableArchitecture
import SwiftUI

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
                    ProgressView()
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
