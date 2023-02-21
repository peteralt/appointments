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
    static var formatter: ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }
    static let liveValue = Self(
        fetchAppointments: {
            var jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            
            // the ISO8601 formatted string is not handled with the built-in decoding strategy,
            // so we need to use a custom one here.
            jsonDecoder.dateDecodingStrategy = .custom { [formatter] decoder in
                let container = try decoder.singleValueContainer()
                let dateString = try container.decode(String.self)
                
                if let date = formatter.date(from: dateString) {
                    return date
                }
                
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Unable to decode date string \(dateString)"
                )
            }
            let (data, _) = try await URLSession.shared
                .data(from: URL(string: "https://interview.pawp.workers.dev/appointment/")!)
            return try jsonDecoder.decode(AppointmentResponse.self, from: data)
        }
    )
}
