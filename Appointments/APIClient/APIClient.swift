import ComposableArchitecture
import Foundation
import XCTestDynamicOverlay

struct AppointmentResponse: Decodable, Equatable {
    let appointments: [Appointment]
}

struct APIClient {
    var fetchAppointments: @Sendable () async throws -> AppointmentResponse
}

extension DependencyValues {
    var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}

extension APIClient: DependencyKey {
    static let liveValue = Self(
        fetchAppointments: {
            var jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            let (data, _) = try await URLSession.shared
                .data(from: URL(string: "https://interview.pawp.workers.dev/appointment/")!)
            return try jsonDecoder.decode(AppointmentResponse.self, from: data)
        }
    )
}
