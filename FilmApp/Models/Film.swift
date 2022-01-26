//
//  Film.swift
//  FilmApp
//
//  Created by Roberto Morrobel on 1/19/22.
//

import Foundation
import Combine
import CoreData

class Film: Codable, Hashable {
    static func == (lhs: Film, rhs: Film) -> Bool {
        lhs.id == rhs.id
        && lhs.title == rhs.title
        && lhs.rating == rhs.rating
    }
    
    var id: Int?
    var title: String?
    var type: String?
    var rating: Float?
    var overview:String?
    var viewCounter : Int?
    var posterImageURL : String?
    
    enum CodingKeys: String, CodingKey {
        case id,
            title,
            type,
            rating = "vote_average",
            overview,
            viewCounter,
            posterImageURL = "poster_path"
    }
    
    init() {
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        rating  = try container.decodeIfPresent(Float.self, forKey: .rating)
        overview = try container.decodeIfPresent(String.self, forKey: .overview)
        viewCounter = try container.decodeIfPresent(Int.self, forKey: .viewCounter)
        
        let imagePath = try container.decodeIfPresent(String.self, forKey: .posterImageURL)
        if let path = imagePath {
            if "" != path {
                posterImageURL = path
            } else {
                posterImageURL = ""
            }
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
    }
}
