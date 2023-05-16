//
//  NetworkConstants.swift
//  WeatherApp
//
//  Created by Phanindra Tanniru on 5/16/23.
//

import Foundation

struct NetworkConstants {
    static let baseURL = String(describing: AppUtility.infoForKey(for: "WEATHER_BASE_URL")).trimmingCharacters(in: .whitespacesAndNewlines)
    static let weatherURL = baseURL + "weather"
    static let imageURL =  "https://openweathermap.org/img/wn/"
    static let weatherAPIKey = String(describing: AppUtility.infoForKey(for: "WEATHER_API_KEY")).trimmingCharacters(in: .whitespacesAndNewlines)
}
