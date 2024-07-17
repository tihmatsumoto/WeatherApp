//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Tiemi Matsumoto on 12/07/2024.
//

import UIKit

class WeatherViewController: UIViewController {
    
    //MARK: - Variables
    let locationButton = UIButton()
    let searchField = UISearchTextField()
    let actionSheet = UIAlertController()
    let stackView = UIStackView()
    let historyTable = UITableView()
    
    var locations: [String] = []
    
    var weatherManager = WeatherManager()
    
    //MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        searchField.delegate = self
        weatherManager.delegate = self
        historyTable.dataSource = self
        historyTable.delegate = self
        
        configureUI()
    }
    
    //MARK: - Configure UI
    func configureUI() {
        configureHeaderView()
        configureSearchBar()
        configureHistoryTableView()
        configureLocationButton()
    }
    
    //MARK: - ConfigureSearchBar
    func configureSearchBar() {
        view.addSubview(searchField)
        searchField.placeholder = "Type city"
        searchField.textColor = .white
        searchField.backgroundColor = .gray
        searchField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchField.widthAnchor.constraint(equalToConstant: 250),
            searchField.heightAnchor.constraint(equalToConstant: 50),
            searchField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -300)
        ])
    }
    
    func configureHeaderView() {
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(searchField)
        stackView.addArrangedSubview(locationButton)
    }
    
    //MARK: - ConfigureLocationButton
    func configureLocationButton() {
        view.addSubview(locationButton)
        let config = UIImage.SymbolConfiguration(pointSize: 50)
        locationButton.setImage(UIImage(systemName: "location.square.fill", withConfiguration: config), for: .normal)
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            locationButton.trailingAnchor.constraint(equalTo: searchField.leadingAnchor, constant: -30),
            locationButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -300)
        ])
    }
    
    func configureHistoryTableView() {
        view.addSubview(historyTable)
        historyTable.translatesAutoresizingMaskIntoConstraints = false
        historyTable.backgroundColor = .clear
        historyTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        NSLayoutConstraint.activate([
            historyTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            historyTable.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 20),
            historyTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            historyTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

//MARK: - SearchField Delegate
extension WeatherViewController: UITextFieldDelegate {
    func searchTyped(_sender: UITextField) {
        searchField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchField.text != "" {
            return true
        } else {
            searchField.placeholder = "Search..."
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchField.text { //optional unwrap
            weatherManager.fetchWeather(cityName: city)
        }
        searchField.text = ""
    }
}

//MARK: - TableView
extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = locations[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        weatherManager.fetchWeather(cityName: locations[indexPath.row])
    }
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        let description = "City/Country: \(weather.cityName), \(weather.countryName) \n Temperature: \(weather.temperature) \n Condition: \(weather.conditionDescription)"
        let alertController = UIAlertController(title: "Weather Conditions", message: "\(description)", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Return", style: .cancel, handler: nil))
        locations.append(weather.cityName)
        historyTable.reloadData()
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func didFailWithError(error: String) {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
