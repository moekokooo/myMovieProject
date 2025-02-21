
import Foundation

@MainActor
class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    //moeko
    @Published var password: String = ""
    //1234@
    @Published var errorMessage: String? {
        didSet {
            isErrorOccured = errorMessage != nil
        }
    }
    
    @Published var isErrorOccured: Bool = false
    @Published var requestToken: String = ""
    
    private let userDefaults : UserDefaults
    
    private let apiService : ApiService
    
    init(userDefaaults: UserDefaults = .standard, apiService: ApiService = ApiService()) {
        self.userDefaults = userDefaaults
        self.apiService = apiService
    }
    
    
    func getRequestToken() async {
        
        do {
            let requestTokenResponse = try await apiService.getRequest(type: RequestTokenResponse.self, urlString: "https://api.themoviedb.org/3/authentication/token/new")
            requestToken = requestTokenResponse.requestToken
            
        } catch {
            self.errorMessage = "RequestToken Inavlid"
            
        }

    }
    
    
    func login() async {
        let loginRequest = LoginRequest(username: username, password: password, request_token: requestToken)
        
        if username.isEmpty {
            errorMessage = "Username is required!"
            return
        }
        
        if password.isEmpty {
            errorMessage = "Password is required!"
            return
        }
        
        self.errorMessage = nil
        
        do {
            let loginResponse = try await apiService.postRequest(type: LoginResponse.self, urlString: "https://api.themoviedb.org/3/authentication/token/validate_with_login", request: loginRequest)
            self.errorMessage = nil
            await userSession(requestToken: loginResponse.requestToken)

        } catch {
            self.errorMessage = "Fail to login!"
        }
    }
    
    
    func userSession(requestToken: String) async {
        let tokenRequest = SessionTokenRequest(request_token: requestToken)
        
        do {
            let sessionTokenResponse = try await apiService.postRequest(type: SessionTokenResponse.self, urlString: "https://api.themoviedb.org/3/authentication/session/new", request: tokenRequest)
            UserDefaults.standard.set(sessionTokenResponse.sessionID, forKey: "sessionID")
        } catch  {
            self.errorMessage = "Login Failed!"
        }

    }
    
    
}
