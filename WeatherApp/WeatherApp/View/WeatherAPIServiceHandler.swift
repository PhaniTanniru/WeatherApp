//
//  WeatherAPIServiceHandler.swift
//  WeatherApp
//
//  Created by Phanindra Tanniru on 5/16/23.
//

import Foundation
import UIKit

// MARK: - Web Service Handling Methods
extension WeatherViewController {
        
    /// Get Weather information for Current Location as in Lat & Lon
    /// - Parameter location: user's location
    func getWeatherForAvailableLocation(location: Location) {
        
        print("Lat:\(location.latitude ?? 0)")
        print("Lat:\(location.longitude ?? 0)")
        let lat = String(location.latitude ?? 0)
        let lon = String(location.longitude ?? 0)
        let temperatureUnit: TemperatureFormat = .Celsius
        let params : [String : String] = ["lat" : lat , "lon" : lon, "units" : temperatureUnit.rawValue, "appid" : NetworkConstants.weatherAPIKey]
        fetchWeather(params: params)
    }
    
    /// Get Weather information for user's selected city
    /// - Parameter cityId: id of the city
    func getWeatherForSelectedCity(cityId: String) {
        let temperatureUnit: TemperatureFormat = .Celsius
        let params : [String : String] = ["id" : cityId , "units" : temperatureUnit.rawValue, "appid" : NetworkConstants.weatherAPIKey]
        fetchWeather(params: params)
    }
    
    /// Get weather information for user's Searched Location
    /// - Parameter location: user's search key
    func getWeatherForSearchLocation(location: String) {
        let temperatureUnit: TemperatureFormat = .Celsius
        let params : [String : String] = ["q" : location , "units" : temperatureUnit.rawValue, "appid" : NetworkConstants.weatherAPIKey]
        fetchWeather(params: params)
    }
    
    
    /// Actually Fetches the Weather
    /// - Parameter params: Parameters for fetching weather information
    func fetchWeather(params: [String:String]) {
        
        if Reachability.shared.status == .connectedViaWiFi || Reachability.shared.status == .connectedViaCellular {
            self.weatherTableView.isHidden = false
            self.weatherTableView.showLoading(activityColor: .link)
            weatherViewModel.fetchWeather(params: params) { [weak self] result in
                self?.weatherTableView.hideLoading()
                switch result {
                case .success(_):
                   // let _ = HistoryProvider.writeWeatherHistory(weather: self.weatherVM.weatherModel.value)
                    print("Fetch Weather API success")
                    //No need to handle UI Updates here as whenever a new weather will be updated and the binding will take place and trigger UI Update
                case .failure(let error):
                    self?.showAlert(message: error.localizedDescription)
                }
            }
        }else{
            self.showAlert(message: Error.network.localizedDescription)
        }
    }
}

