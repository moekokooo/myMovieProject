
import Foundation

struct LoginRequest: Encodable {
    let username: String
    let password: String
    let request_token: String
}
