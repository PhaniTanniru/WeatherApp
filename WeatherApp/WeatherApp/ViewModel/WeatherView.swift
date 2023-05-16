//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Phanindra Tanniru on 5/16/23.
//

import Foundation
import UIKit

// MARK: - Weather UI
class WeatherView: UIView {
    
    ///Outlets
    @IBOutlet weak private var lblCity: UILabel!
    @IBOutlet weak private var lblCountry: UILabel!
    @IBOutlet weak private var lblComment: UILabel!
    @IBOutlet weak private var lblMinTemp: UILabel!
    @IBOutlet weak private var lblMaxTemp: UILabel!
    @IBOutlet weak private var lblDate: UILabel!
    @IBOutlet weak private var lblWeatherDescription: UILabel!
    @IBOutlet weak private var lblTemperature: UILabel!
    @IBOutlet weak var imgWeather: MyExtendedImage!
    
    
    /// Update the UI
    /// - Parameter weather: Weather to update UI from
    func update(with weather: Weather){
        let temperature = weather.main?.temp
        switch temperature!{
        case ...15.0:
            lblComment.text = WeatherAppConstants.winterMessage
        case 15.1...25.0:
            lblComment.text = WeatherAppConstants.springMessage
        case 25.1...:
            lblComment.text = WeatherAppConstants.summerMessage
        default: break
        }
        
        //load image for the weather
        if let iconId = weather.weather?.first?.icon {
            imgWeather.loadImageWithUrl(URL(string: "\(NetworkConstants.imageURL)\(iconId)@2x.png")!)
        }
        
        setupDateLabel(with: weather)
        lblMinTemp.text = String(format: "%.f°", (weather.main?.tempMin ?? 0))
        lblMaxTemp.text = String(format: "%.f°", (weather.main?.tempMax ?? 0))
        lblCity.text = weather.name
        lblCountry.text = weather.sys?.country
        lblWeatherDescription.text = weather.weather?.first?.description
        
        let tempratureUnit: String = "C"
        
        animate(text: String(format: "%.f°\(tempratureUnit)", (weather.main?.temp ?? 0)), with: .curveEaseIn)
    }
    
    func setupDateLabel(with weather: Weather){
        let date: String
        if weather.dt != nil {
            var timestampe = weather.dt ?? 0
            let timezoneDiff = weather.timezone ?? 0
            timestampe += timezoneDiff
            let weatherDate = timestampe.fromUnixTimeStamp()
            date =  " \(weatherDate?.convertToString(format: WeatherAppConstants.dateFormat_Long) ?? "")"
        }else{
            date =  " \(Date().convertToString(format: WeatherAppConstants.dateFormat_Long))"
        }
        lblDate.text = date
    }
    
    ///Animate temprature label
    private func animate(text: String, with options: UIView.AnimationOptions) {
        UIView.transition(with: lblTemperature,
                          duration: WeatherAppConstants.animationDuration,
                          options: options,
                          animations: { [weak self] in
            self?.lblTemperature.text = text
        }, completion: nil)
    }
}


