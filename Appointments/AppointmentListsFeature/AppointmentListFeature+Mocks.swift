import Foundation

#if DEBUG
extension AppointmentListFeature.State {
    static var sample: Self {
        .init(
            appointments: [
                .init(
                    appointment: .init(
                        id: "first",
                        user: .init(
                            id: 1,
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
                                id: 2,
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
                                id: 3,
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
                                id: 4,
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
