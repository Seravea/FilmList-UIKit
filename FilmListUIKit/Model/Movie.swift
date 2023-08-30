//
//  Movie.swift
//  FilmListUIKit
//
//  Created by Romain Poyard on 02/08/2023.
//

import Foundation


struct PopularMoviesResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages, totalResults: Int

    //enum for matching key name API to Swift struct for the ResponseBody
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// Movie struct for 1 result
struct Movie: Codable {
    let adult: Bool
    let backdropPath: String?
    let id: Int
    let title: String
   // let originalLanguage: OriginalLanguage?
    let originalTitle, overview, posterPath: String
    let mediaType: MediaType?
    let genreIDS: [Int]
    let popularity: Double
    let releaseDate: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    
    var imageURL: URL {
        let baseURL = URL(string: "https://image.tmdb.org/t/p/w500")!
        if let urlString = backdropPath {
            return baseURL.appending(path: urlString)
        }else {
            return baseURL.appending(path: posterPath)
        }
    }
    
    var posterURL: URL {
        let baseURL = URL(string: "https://image.tmdb.org/t/p/w500")!
        return baseURL.appending(path: posterPath)
    }

    
    //enum for matching key name API to Swift struct for the Movie fetchingData
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case id, title
       // case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case genreIDS = "genre_ids"
        case popularity
        case releaseDate = "release_date"
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

//for the Movie constante "mediaType"
enum MediaType: String, Codable {
    case movie = "movie"
}


//for the Movie constante "originalLanguage"
enum OriginalLanguage: String, Codable {
    case en = "en"
    case es = "es"
    case nl = "nl"
    case tr = "tr"
    case fi = "fi"
    case de = "de"
}


// data struct for the response of load function upcoming Movies
struct UpcomingMoviesResponse: Codable {
    let dates: RangeDate
    let page: Int
    let results: [Movie]
    let totalPages, totalResults: Int

    //enum for matching key name API to Swift struct for the UpcomingMoviesResponse
    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct RangeDate: Codable {
    let maximum: String
    let minimum: String
}

struct GenreResponseBody: Codable {
    let genres: [Genre]
}

struct Genre: Codable {
    let id: Int
    let name: String
    
}

struct TrailerResponseBody: Codable {
    let id: Int
    let results: [TrailerFile]
}

struct TrailerFile: Codable {
    let name: String
    let key: String
    let site: String
    let id: String
    var isOnYoutube: Bool {
        if site.lowercased() == "youtube" {
            return true
        }else {
            return false
        }
    }
}


