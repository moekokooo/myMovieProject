
import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @StateObject private var imageCache = ImageCache()
    @EnvironmentObject var viewModel : MovieViewModel
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ZStack(alignment: .bottom) {
                    if let image = imageCache.images[movie.posterURL] {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 400)
                            .clipped()
                            .blur(radius: 10)
                    } else {
                        Color.gray.opacity(0.3)
                            .task {
                                await imageCache.loadImage(from: movie.posterURL)
                            }
                    }
                    
                    VStack {
                        if let image = imageCache.images[movie.posterURL] {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                                .shadow(radius: 10)
                        } else {
                            Color.gray.opacity(0.3)
                                .task {
                                    await imageCache.loadImage(from: movie.posterURL)
                                }
                        }
                    }
                }
                
                HStack {
                    Text(movie.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    Button {
                        viewModel.toggleFavorite(movie: movie)
                    } label: {
                        Image(systemName: viewModel.isFavorite(movie: movie) ? "heart.fill" : "heart")
                            .foregroundColor( viewModel.isFavorite(movie: movie) ? .red : .gray)
                            .overlay(
                                Image(systemName: "heart")
                                    .foregroundColor(.red)
                            )
                            .font(.title)
                        
                    }
                    .padding(.horizontal)
                }
                
                
                Text("Released: \(movie.releaseDate)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                if !viewModel.genres.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.genres, id: \.self) { genre in
                                Text(genre)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 5)
                                    .background(Color.blue.opacity(0.2))
                                    .clipShape(Capsule())
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                HStack {
                    ForEach(0..<5) { index in
                        Image(systemName: index < Int(movie.voteAverage / 2) ? "star.fill" : "star")
                            .foregroundColor(index < Int(movie.voteAverage / 2) ? .yellow : .gray)
                    }
                    Text("\(String(format: "%.1f", movie.voteAverage))/10")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                Text("Overview")
                    .font(.headline)
                    .padding(.horizontal)
                
                Text(movie.overview)
                    .font(.body)
                    .padding(.horizontal)
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.fetchGenres(for: movie)
                
            }
        }
        
    }
    
}




