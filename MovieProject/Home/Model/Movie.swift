
import Foundation

struct MovieResponse: Decodable {
    let page: Int
    let results: [Movie]
}

struct Movie: Codable,Identifiable, Hashable, Equatable {
    let id: Int
    let title: String
    let posterPath: String?
    let overview: String
    let voteAverage: Double
    let releaseDate: String
    let genreIds: [Int]
    
    
    

    var posterURL: String {
           "https://image.tmdb.org/t/p/w500\(posterPath ?? "")"
       }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case overview
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
        
    }
}

struct Genre: Decodable {
    let id: Int
    let name: String
}

struct CastMember: Codable, Identifiable {
    let id: Int
    let name: String
    let profilePath: String?
    
    var profileURL: String {
        "https://image.tmdb.org/t/p/w200\(profilePath ?? "")"
    }
}
