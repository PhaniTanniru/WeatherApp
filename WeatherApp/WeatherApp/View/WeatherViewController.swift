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
    
    //MARK: Private Properties
    let locationManager = CLLocationManager()
    var currentLocation : CLLocation!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Setup UI , Reload and Observer Binding
    func setupView(){
        // setup view here
        self.title = "Weather"

    }
}

//MARK: - Weather History Menu
extension WeatherViewController{
    
}
