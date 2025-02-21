
import SwiftUI

struct SearchMoviesView: View {
    @State private var query: String = ""
    @EnvironmentObject var viewModel: MovieViewModel
    @StateObject private var imageCache = ImageCache()
    
    
    var body: some View {
        List {
            ForEach(viewModel.searchResults) { movie in
                NavigationLink(destination: MovieDetailView(movie: movie)) {
                    HStack {
                        
                        if let image = imageCache.images[movie.posterURL] {
                            image.resizable()
                                .frame(width: 50, height: 75)
                                .cornerRadius(8)
                        } else {
                            Color.gray.opacity(0.3)
                                .frame(width: 50, height: 75)
                                .cornerRadius(8)
                                .task {
                                    await imageCache.loadImage(from: movie.posterURL)
                                }
                        }
                        
                        
                        VStack(alignment: .leading) {
                            Text(movie.title)
                                .font(.headline)
                            Text("⭐ \(movie.voteAverage, specifier: "%.1f")")
                                .font(.subheadline)
                                .foregroundColor(.yellow)
                        }
                    }
                    .task {
                        if movie == viewModel.searchResults.last {
                            await viewModel.searchMovies(query: query)
                        }
                    }
                }
                if viewModel.isLoadingSearch {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
            }
            
        }
        .navigationTitle("Search Movies")
        .searchable(text: $query, prompt: "Search movies...")
        .onChange(of: query) { oldValue ,newValue in
            Task {
                if newValue.isEmpty {
                    viewModel.searchResults = []
                } else {
                    await viewModel.searchMovies(query: newValue)
                }
            }
        }
        
    }
}

