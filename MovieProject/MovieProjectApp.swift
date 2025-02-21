
import SwiftUI

@main
struct MovieProjectApp: App {
    
    @AppStorage("isShowOnboarding") private var isShowOnboarding: Bool = false
    @AppStorage("sessionID") private var sessionID: String = ""
    @StateObject private var viewModel = MovieViewModel()
    
    var body: some Scene {
        WindowGroup {
            if isShowOnboarding  {
                if sessionID.isEmpty {
                    LoginView()
                } else {
                    ContentView()
                        .environmentObject(viewModel)
                }
            } else {
                NavigationStack {
                    OnboardingView()
                }
            }
        }
    }
}
