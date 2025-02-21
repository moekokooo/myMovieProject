
import SwiftUI

struct ContentView: View {
    
    
    var body: some View {
        TabView {
            
            NavigationStack {
                MovieHomeView()
            }
            .tabItem {
                Image(systemName: "film")
                Text("Movies")
            }
            
            NavigationStack {
                FavoriteMoviesView()
            }
            .tabItem {
                Image(systemName: "heart.fill")
                Text("Favorites")
            }
            
            NavigationStack {
                SearchMoviesView()
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }
        }
        
        
    }
    
}
#Preview {
    ContentView()
}
