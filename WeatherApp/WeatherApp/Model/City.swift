//
//  City.swift
//  WeatherApp
//
//  Created by Phanindra Tanniru on 5/16/23.
//

import Foundation

//MARK: - City
struct City: Decodable {
    let id: Int
    let name: String
    let country: String
}

extension City: Hashable {
    static func == (lhs: City, rhs: City) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
