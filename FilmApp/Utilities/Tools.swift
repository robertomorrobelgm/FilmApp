//
//  Tools.swift
//  FilmApp
//
//  Created by Roberto Morrobel on 1/25/22.
//

import Foundation
import SwiftUI

struct Tools {
    static func createImage(film:Film) -> UIImage {
        let urlData:NSURL? = NSURL(string: film.posterImageURL ?? "")
        guard let imageData:NSData = NSData(contentsOf: urlData! as URL) else{
            return UIImage(named: "no-available-image") ?? UIImage()
        }
        let image = UIImage(data: imageData as Data)
        
        return image ?? UIImage()
    }
}
