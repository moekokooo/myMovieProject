
import Foundation

enum MovieCategory: String {
    case popular = "Popular Movies"
    case topRated = "Top Rated Movies"
    case upcoming = "Upcoming Movies"
    
    var apiPath: String {
        switch self {
        case .popular: return "popular"
        case .topRated: return "top_rated"
        case .upcoming: return "upcoming"
        }
    }
}

@MainActor
class MovieViewModel: ObservableObject {
    
    @Published var movies: [Movie] = []
    @Published var popularMovies: [Movie] = []
    @Published var topRatedMovies: [Movie] = []
    @Published var upcomingMovies: [Movie] = []
    @Published var errorMessage: String?
    @Published var currentPage: Int = 1
    @Published var favoriteMovies: [Movie] = []
    {
        didSet {
            saveFavorites()
        }
    }
    @Published var searchResults: [Movie] = []
    @Published var currentSearchPage = 1
    @Published var isLoadingSearch = false
    @Published var genres: [String] = []
    
    private var lastQuery = ""
    private let apiService: ApiService
    
    init(apiService: ApiService = ApiService()) {
        self.apiService = apiService
    }
    
    
    func fetchMovies(category: MovieCategory) async  {
        do {
            
            let movieResponse = try await apiService.getRequest(type: MovieResponse.self, urlString: "https://api.themoviedb.org/3/movie/\(category.apiPath)?page=\(currentPage)")
            movies.append(contentsOf: movieResponse.results)
            await MainActor.run {
                
                switch category {
                case .popular:
                    self.popularMovies.append(contentsOf: movieResponse.results)
                case .topRated:
                    self.topRatedMovies.append(contentsOf: movieResponse.results)
                case .upcoming:
                    self.upcomingMovies.append(contentsOf: movieResponse.results)
                }
                currentPage += 1
            }
        } catch {
            errorMessage = "Loading failed"
        }
        
    }
    
    func fetchGenres(for movie: Movie) async {
        let allGenres: [Genre] = [
            Genre(id: 28, name: "Action"),
            Genre(id: 12, name: "Adventure"),
            Genre(id: 16, name: "Animation"),
            Genre(id: 35, name: "Comedy"),
            Genre(id: 80, name: "Crime"),
            Genre(id: 18, name: "Drama"),
            Genre(id: 10751, name: "Family"),
            Genre(id: 14, name: "Fantasy"),
            Genre(id: 36, name: "History"),
            Genre(id: 27, name: "Horror"),
            Genre(id: 10402, name: "Music"),
            Genre(id: 9648, name: "Mystery"),
            Genre(id: 10749, name: "Romance"),
            Genre(id: 878, name: "Sci-Fi"),
            Genre(id: 53, name: "Thriller"),
            Genre(id: 10752, name: "War"),
            Genre(id: 37, name: "Western")
        ]
        
        await MainActor.run {
            self.genres = movie.genreIds.compactMap { id in
                allGenres.first { $0.id == id }?.name
            }
        }
    }
    
    func searchMovies(query: String) async {
        guard !query.isEmpty, !isLoadingSearch else { return }
        
        if query != lastQuery {
            searchResults.removeAll()
            currentSearchPage = 1
        }
        
        isLoadingSearch = true
        lastQuery = query
        
        do {
            let movieResponse = try await apiService.getRequest(
                type: MovieResponse.self,
                urlString: "https://api.themoviedb.org/3/search/movie?query=\(query)&page=\(currentSearchPage)"
            )
            
            searchResults.append(contentsOf: movieResponse.results)
            currentSearchPage += 1
        } catch {
            errorMessage = "Search Failed"
        }
        
        isLoadingSearch = false
    }
    
    
    func toggleFavorite(movie: Movie) {
        if let movieIndex = favoriteMovies.firstIndex(where: { $0.id == movie.id }) {
            favoriteMovies.remove(at: movieIndex)
        } else {
            favoriteMovies.append(movie)
        }
        saveFavorites()
    }
    
    func isFavorite(movie: Movie) -> Bool {
        return favoriteMovies.contains(where: { $0.id == movie.id })
    }
    
    private func saveFavorites() {
        if let favoriteMoviesData = try? JSONEncoder().encode(favoriteMovies) {
            UserDefaults.standard.set(favoriteMoviesData, forKey: "favoriteMovies")
        }
    }
    
    func loadFavorites() {
        if let savedData = UserDefaults.standard.data(forKey: "favoriteMovies"),
           let favoriteMovie = try? JSONDecoder().decode([Movie].self, from: savedData) {
            self.favoriteMovies = favoriteMovie
        }
    }
    
}
