
import Foundation

enum ApiError: Error {
    case invalidURL
    case decodingFailed
   
}

class ApiService: ObservableObject {
    let session : URLSession
    
    init(session : URLSession = .shared) {
        self.session = session
    }
    
    func postRequest<T: Decodable>(type: T.Type,urlString: String, request: Encodable) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw ApiError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try JSONEncoder().encode(request)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxODI4NjhiY2M2MDM2N2U3YTllMmRhY2I5MmNhZTU5YyIsIm5iZiI6MTU0NjcwMDU0OC4zODMwMDAxLCJzdWIiOiI1YzMwYzcwNGMzYTM2ODUzMjBhNTk2NTEiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.Mlzaw3XcXCocbR-z1sowyDQ3namWxrqj11m1ZBgSmRc", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await session.data(for: urlRequest)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    
    func getRequest<T: Decodable>(type: T.Type, urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw ApiError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxODI4NjhiY2M2MDM2N2U3YTllMmRhY2I5MmNhZTU5YyIsIm5iZiI6MTU0NjcwMDU0OC4zODMwMDAxLCJzdWIiOiI1YzMwYzcwNGMzYTM2ODUzMjBhNTk2NTEiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.Mlzaw3XcXCocbR-z1sowyDQ3namWxrqj11m1ZBgSmRc", forHTTPHeaderField: "Authorization")
        
        
        let (data, _) = try await session.data(for: urlRequest)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    
}
