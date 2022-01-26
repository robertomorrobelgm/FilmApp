//
//  Constants.swift
//  FilmApp
//
//  Created by Roberto Morrobel on 1/24/22.
//

import Foundation

struct Constants {
    static let imageBaseURL = "https://image.tmdb.org/t/p/"
    static let imageListURL = imageBaseURL + "w300"
    static let apiKey = "d7f7495cc467937bccf8f078c9db21b9"
    static let movieDiscoveryURL = "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&language=en-US&sort_by=vote_average.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=free"
}
