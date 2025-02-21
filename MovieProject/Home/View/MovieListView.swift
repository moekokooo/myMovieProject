
import SwiftUI

struct MovieListView: View {
    let category: MovieCategory
    @EnvironmentObject var viewModel: MovieViewModel
    
    var movies: [Movie] {
        switch category {
        case .popular:
            return viewModel.popularMovies
        case .topRated:
            return viewModel.topRatedMovies
        case .upcoming:
            return viewModel.upcomingMovies
        }
    }
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(movies, id: \.id) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie).environmentObject(viewModel)) {
                        MovieGridItemView(movie: movie)
                            .onAppear {
                                Task {
                                    if movie == movies.last {
                                        await viewModel.fetchMovies(category: category)
                                    }
                                }
                            }
                        }
                }
                .padding()
            }
            .navigationTitle(category.rawValue)
            .onAppear {
                Task {
                    await viewModel.fetchMovies(category: category)
                }
                
            }
        }
    }
}

