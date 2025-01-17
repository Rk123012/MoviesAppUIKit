//
//  Movie.swift
//  MoviesAppUIKit
//
//  Created by Rezaul Karim on 17/1/25.
//

import Foundation


struct MovieResponse : Decodable{
     let  Search : [Movie]
}

struct Movie : Decodable{
    let title : String
    let year : String
    
    
    private enum CodingKeys : String, CodingKey{
        case title = "Title"
        case year = "Year"
    }
}
