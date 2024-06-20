//
//  Earthquake.swift
//  TremorWatch
//
//  Created by EMTECH MAC on 12/06/2024.
//

import Foundation

struct Earthquake: Codable {
    let magnitude: Double
    let location: String
    let depth: Double
    let time: Date
    
    enum CodingKeys: String, CodingKey {
        case magnitude = "mag"
        case location = "place"
        case depth = "depth"
        case time = "time"
    }

}
