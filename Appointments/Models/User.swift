import Foundation

struct User: Equatable, Identifiable, Codable {
    var id: Int
    var firstName: String
    var lastName: String
    
    var initials: String {
        var result = ""
        if let firstNameFirst = firstName.first {
            result.append(firstNameFirst)
        }
        if let lastNameFirst = lastName.first {
            result.append(lastNameFirst)
        }
        return result
    }
}
