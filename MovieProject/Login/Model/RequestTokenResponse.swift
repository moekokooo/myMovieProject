
import Foundation

struct RequestTokenResponse: Decodable {

    let requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case requestToken = "request_token"
    }
}
