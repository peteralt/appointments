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
                        status: .readyToJoin,
                        startTime: .now,
                        endTime: .distantFuture,
                        requestedAt: .distantPast
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
                            status: .responseRequired,
                            startTime: .now,
                            endTime: .distantFuture,
                            requestedAt: .distantPast
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
                            status: .active,
                            startTime: .now,
                            endTime: .distantFuture,
                            requestedAt: .distantPast
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
                            status: .completed,
                            startTime: .now,
                            endTime: .distantFuture,
                            requestedAt: .distantPast
                        )
                    )
            ]
        )
    }
}
#endif
