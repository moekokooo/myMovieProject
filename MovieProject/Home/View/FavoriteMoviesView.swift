
import SwiftUI

struct FavoriteMoviesView: View {
    
    @EnvironmentObject var viewModel: MovieViewModel
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.favoriteMovies) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie).environmentObject(viewModel)) {
                        MovieGridItemView(movie: movie)
                    }
                }
            }
            .padding()
            
        }
        .navigationTitle("Favorite Movies")
        .onAppear {
            viewModel.loadFavorites()
            
        }
        
    }
}

