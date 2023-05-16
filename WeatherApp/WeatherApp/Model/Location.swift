//
//  Location.swift
//  WeatherApp
//
//  Created by Phanindra Tanniru on 5/16/23.
//

import Foundation

class Location {
    static var shared = Location()
    
    private init() {}
    
    var latitude : Double?
    var longitude : Double?
}
