//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Phanindra Tanniru  on 5/16/23.
//

import Foundation

class WeatherViewModel {
    
    private let apiService: NetworkServiceProtocol
    init(apiService: NetworkServiceProtocol = NetworkHelper()) {
        self.apiService = apiService
    }
    
    //create observers
    var location: AppObserver<String> = AppObserver("")
    let weatherModel: AppObserver<Weather?> = AppObserver(nil)
    
    /// Fetch Weather
    /// - Parameters:
    ///   - params: Parameters q:Location, lat: lattitude, log: longitutude, appid: API key, unit: Metric: Celsius, Imperial: Fahrenheit default is Kelvin
    ///   - complete: Completion block with Result<AppObserver<Weather?>, Error>
    func fetchWeather(params:[String:String], complete: @escaping ( Result<AppObserver<Weather?>, Error>)->()) {
        
        self.apiService.startNetworkTask(urlStr: NetworkConstants.weatherURL, params: params) { result in
            switch result {
            case .success(let dataObject):
                do {
//                    let convertedString = String(data: dataObject ?? Data(), encoding: .utf8)
//                    print("Response: \(convertedString ?? "No Data")")
                    let decoderObject = JSONDecoder()
                    self.weatherModel.value = try decoderObject.decode(Weather.self, from: dataObject!)
                    complete(.success(self.weatherModel))
                }
                catch{
                    do {
                        self.weatherModel.value = nil
                        let decoderObject = JSONDecoder()
                        let someCode: CityNotAvailable? = try decoderObject.decode(CityNotAvailable.self, from: dataObject!)
                        if let errorCode = someCode {
                            print(errorCode.message as Any)
                            complete(.failure(.other(errorCode.message ?? "" )))
                        }else{
                            complete(.failure(.other(error.localizedDescription)))
                        }
                    }
                    catch{
                        complete(.failure(.other(error.localizedDescription)))
                    }
                }
                
            case .failure(let error):
                self.weatherModel.value = nil
                complete(.failure(.other(error.localizedDescription)))
            }
        }
    }
}

