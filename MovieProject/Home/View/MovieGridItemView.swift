
import SwiftUI

struct MovieGridItemView: View {
    let movie: Movie
    @StateObject private var imageCache = ImageCache()

    var body: some View {
        VStack {
            if let image = imageCache.images[movie.posterURL] {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 225)
                    .cornerRadius(10)
            } else {
                ProgressView()
                    .frame(width: 150, height: 225)
                    .task {
                        await imageCache.loadImage(from: movie.posterURL)
                    }
            }

            Text(movie.title)
                .font(.caption)
                .bold()
                .frame(width: 120)
                .lineLimit(1)
                .multilineTextAlignment(.center)
        }
    }
}

