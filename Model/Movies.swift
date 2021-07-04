//
//  Movies.swift
//  Created by Sabrina Hoque Tuli on 29/5/21.
//

import Foundation

struct GroupedAirPort: Decodable, Equatable {
    let sortedzone: String
    let data: [Airport]
    
}

struct Airport: Decodable, Equatable{
    
    let airportCode: String
    let timezone: String
    let city: String
    let state: String
    let airportName: String
    
   
}
struct Movies: Decodable{
    
    let title: String?
    let imageHref: String?
    let rating: Double?
    let releaseDate: String?
    
   
}
