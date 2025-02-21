
import SwiftUI

struct MovieHomeView: View {
    @EnvironmentObject var viewModel : MovieViewModel
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 20) {
                MovieSectionView(title: "Popular Movies", movies: viewModel.popularMovies, category: .popular)
                MovieSectionView(title: "Top Rated Movies", movies: viewModel.topRatedMovies, category: .topRated)
                MovieSectionView(title: "Upcoming Movies", movies: viewModel.upcomingMovies, category: .upcoming)
            }
            .padding(.vertical)
        }
        .navigationTitle("Movies")
        .task {
            if viewModel.popularMovies.isEmpty {
                await viewModel.fetchMovies(category: .popular)
            }
            if viewModel.topRatedMovies.isEmpty {
                await viewModel.fetchMovies(category: .topRated)
            }
            if viewModel.upcomingMovies.isEmpty {
                await viewModel.fetchMovies(category: .upcoming)
            }
        }
        
    }
    
    
}


