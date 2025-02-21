
import SwiftUI

struct MovieSectionView: View {
    let title: String
    let movies: [Movie]
    let category: MovieCategory
    
    @EnvironmentObject var viewModel: MovieViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .bold()
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(movies) { movie in
                        NavigationLink(destination: MovieDetailView(movie: movie).environmentObject(viewModel)) {
                            MovieRowView(movie: movie)
                        }
                    }
                    
                    NavigationLink(destination: MovieListView(category: category).environmentObject(viewModel)) {
                        VStack {
                            Image(systemName: "chevron.right.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.blue)
                            
                            Text("See More")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        .padding(.horizontal, 10)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
