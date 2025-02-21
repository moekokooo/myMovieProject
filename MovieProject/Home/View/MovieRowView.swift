
import SwiftUI

struct MovieRowView: View {
    let movie: Movie
    @StateObject private var imageCache = ImageCache()
    
    var body: some View {
        VStack {
            if let image = imageCache.images[movie.posterURL] {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 180)
                    .cornerRadius(8)
            } else {
                ProgressView()
                    .frame(width: 120, height: 180)
                    .task {
                        await imageCache.loadImage(from: movie.posterURL)
                    }
            }
            
            Text(movie.title)
                .font(.caption.bold())
                .frame(width: 120)
                .lineLimit(1)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}
