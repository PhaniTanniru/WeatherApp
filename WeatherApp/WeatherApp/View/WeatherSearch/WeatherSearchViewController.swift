//
//  WeatherSearchViewController.swift
//  WeatherApp
//
//  Created by Phanindra Tanniru on 5/16/23.
//

import Foundation
import UIKit

// MARK: - City List Protocol
protocol CitySelectionProtocol: AnyObject {
    func didSelectedCity(cityId: String)
}

// MARK: - Weather Search View Controller
class WeatherSearchViewController: UITableViewController {
    
    ///Properties
    private var allCities: [City]?
    private var sections: [Section] = []
    private var weatherViewModel = WeatherViewModel()
    private let cityIdKey = "cityId"
    private let searchController = UISearchController(searchResultsController: nil)
    private lazy var filteredCities: [City] = []
    private struct Section {
        let letter : String
        let cities : [City]
    }
    private var isFiltering: Bool {
        searchController.isActive && !isSearchBarEmpty
    }
    private var isSearchBarEmpty: Bool {
        searchController.searchBar.text?.isEmpty ?? true
    }
    weak var delegate: CitySelectionProtocol?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = WeatherAppConstants.searchListTitle
        loadCities()
        tableView.isAccessibilityElement = true
        tableView.accessibilityIdentifier = "CityListTable"
        setupSearchBar()
    }
    
    /// Dismiss
    func removeCityList(){
        self.popVC()
    }
    
    // MARK: - Private methods
    
    /// Load Cities
    private func loadCities(){
        self.view.showLoading(activityColor: .link)
        WeatherSearchListProvider.getCityList(fileName: "CityList",complete: { result in
            
            self.view.hideLoading()
            switch result {
            case .success(let list):
                self.handleCityList(cities: list!)
            case .failure(let error):
                self.openAlert(title: WeatherAppConstants.appTitle, message: error.localizedDescription,  alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default],actions: [
                    { _ in
                    }
                ])
            }
        })
    }
    
    
    /// Handle City List after get request
    /// - Parameter cities: city list
    func handleCityList(cities: [City]?) {
        allCities = cities
        let groupedCities = Dictionary(grouping: allCities ?? [City]()) { $0.country.first! }
        let keys = groupedCities.keys.sorted()
        sections = keys
            .map {
                Section(letter: String($0),
                        cities: groupedCities[$0]!
                            .sorted { $0.country.localizedCaseInsensitiveCompare($1.country) == .orderedAscending }
                )
            }
        tableView.reloadData()
    }
    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = WeatherAppConstants.searchCity
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        guard let cities = allCities else {
            return
        }
        filteredCities = cities.filter { city in
            city.name.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
}

// MARK: - UISearchResultsUpdating
extension WeatherSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

// MARK: - Data source
extension WeatherSearchViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard isFiltering else {
            return sections.count
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard isFiltering else {
            return sections[section].cities.count
        }
        return filteredCities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        
        let city: City
        if isFiltering {
            city = filteredCities[indexPath.row]
        } else {
            city = sections[indexPath.section].cities[indexPath.row]
        }
        
        cell.textLabel?.text = city.name
        cell.detailTextLabel?.text = city.country
        
        return cell
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        guard isFiltering else {
            return sections.map { $0.letter }
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard isFiltering else {
            return sections[section].letter
        }
        return nil
    }
}

// MARK: - UITableViewDelegate
extension WeatherSearchViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cityId: Int
        if isFiltering {
            cityId = filteredCities[indexPath.row].id
        } else {
            cityId = sections[indexPath.section].cities[indexPath.row].id
        }
        
        Dispatch.main {
            self.delegate?.didSelectedCity(cityId: String(describing: cityId))
            self.removeCityList()
        }
    }
}


