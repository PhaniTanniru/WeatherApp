//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Phanindra Tanniru on 5/15/23.
//

import UIKit
import Foundation
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet weak var barBtnSearch: UIBarButtonItem!{
        didSet{
            barBtnSearch.primaryAction = nil
            barBtnSearch.accessibilityIdentifier = "SearchButton"
        }
    }
    
    //MARK: Private Properties
    let locationManager = CLLocationManager()
    var currentLocation : CLLocation!
    var weatherViewModel = WeatherViewModel()

    override func viewDidLoad(){
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
    }
    
    // MARK: - Setup UI , Reload and Observer Binding
    func setupView(){
        // setup view here
        showNoDataView()
        self.title = WeatherAppConstants.navigationTitle
        weatherTableView.dataSource = self
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy =  kCLLocationAccuracyBest
        
        //Binding Observer
        bindWeatherModel()
        //Reachability
        Reachability.shared.startMonitoring()
        
        //Request and Fetch user current location
        fetchCurrentLocation()
    }
    
    /// Binding of Observer
    func bindWeatherModel() {
        weatherViewModel.weatherModel.bind { [weak self] newModel in
            DispatchQueue.main.async {
                self?.reloadWeatherUI()
               // self?.barBtnHistory.menu =  self?.createContextMenu()
            }
        }
    }
    
    /// Request User's Current Location
    func fetchCurrentLocation() {
        requestLocationAccess()
    }
    
    /// Reload Weather UI
    func reloadWeatherUI(){
        if weatherViewModel.weatherModel.value?.weather != nil {
            //Found Weather
            hideNoDataView()
        } else {
            //Weather data not Found
            showNoDataView()
        }
        weatherTableView.reloadData()
    }
    
    /// Show Common Alert
    /// - Parameter message: Alert Message
    func showAlert(message: String){
        openAlert(title: WeatherAppConstants.appTitle, message: message,  alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default],actions: [
            { _ in
            }
        ])
    }
    
    /// No Data Label
    private lazy var noDataView: NoDataView = {
        let nodataView: NoDataView = Bundle.main.loadNibNamed("NoDataView", owner: self, options: nil)?.first as! NoDataView
        nodataView.center = view.center
        nodataView.setupSelectLocation()
        return nodataView
    }()
    
    /// Show No Data View
    func showNoDataView(){
        view.addSubview(noDataView)
        view.bringSubviewToFront(noDataView)
    }
    
    /// Hide No Data View
    func hideNoDataView() {
        noDataView.removeFromSuperview()
    }
}

//MARK: - Weather TableView DataSource
extension WeatherViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if weatherViewModel.weatherModel.value?.weather != nil {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherAppConstants.weatherCellId)  else {
            return UITableViewCell()
        }
        
        //Access the weather view from Cell and provide weather information to update ui
        if let weatherView = cell.contentView.viewWithTag(1) as? WeatherView {
            if let weatherData = weatherViewModel.weatherModel.value, weatherData.weather != nil  {
                weatherView.update(with: weatherData)
            }
        }
       
        return cell
    }
}

// MARK: - Current Location Handling Methods & Delegate
extension WeatherViewController: CLLocationManagerDelegate{
    
    /// handle Location after received from Location Manager
    /// - Parameter location: Location
    func performLocationUpdate(location: CLLocation?){
        if let location = location {
            Location.shared.latitude = location.coordinate.latitude
            Location.shared.longitude = location.coordinate.longitude
            self.getWeatherForAvailableLocation(location: Location.shared)
        }
    }
    
    func requestLocationAccess(){
        print("access user location ... \(locationManager.authorizationStatus)")
        if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
        else{
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            // Request the appropriate authorization based on the needs of the app
            manager.requestWhenInUseAuthorization()
        case .restricted:
            print("Sorry, restricted")
            // Optional: Offer to take user to app's settings screen
        case .denied:
            print("Sorry, denied")
            // Optional: Offer to take user to app's settings screen
        case .authorizedAlways, .authorizedWhenInUse:
            // The app has permission so start getting location updates
            manager.startUpdatingLocation()
        @unknown default:
            print("Unknown status")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Some location updates can be invalid or have insufficient accuracy.
        // Find the first location that has sufficient horizontal accuracy.
        // If the manager's desiredAccuracy is one of kCLLocationAccuracyNearestTenMeters,
        // kCLLocationAccuracyHundredMeters, kCLLocationAccuracyKilometer, or kCLLocationAccuracyThreeKilometers
        // then you can use $0.horizontalAccuracy <= manager.desiredAccuracy. Otherwise enter the number of meters desired.
        if let location = locations.first(where: { $0.horizontalAccuracy <= 50 }) {
            print("location found: \(location)")
            self.performLocationUpdate(location: locationManager.location)
            // stop updating Location if you don't need any more updates
            manager.stopUpdatingLocation()
        }else{
            showAlert(message: WeatherAppConstants.noLocationFound)
        }
    }
    
    private func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //Show Alert that Not able to fetch User's Location
        showAlert(message: error.localizedDescription)
    }
}
