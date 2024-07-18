//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Tiemi Matsumoto on 12/07/2024.
//

import UIKit

class WeatherViewController: UIViewController {
    
    //MARK: - Variables
    let stackView = UIStackView()
    let searchField = UISearchTextField()
    let locationButton = UIButton()
    let historyTable = UITableView()
    let actionSheet = UIAlertController()
    
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
        configureStackView()
        configureSearchBar()
        configureLocationButton()
        configureHistoryTableView()
    }
    
//MARK: - Configure StackView
    func configureStackView() {
        view.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.spacing = 30

        stackView.addArrangedSubview(locationButton)
        stackView.addArrangedSubview(searchField)
        
        setStackViewConstraints()
    }
    
    func setStackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
    }
    
//MARK: - Configure SearchBar
    func configureSearchBar() {
        view.addSubview(searchField)
        searchField.placeholder = "Type city"
        
        setSearchBarConstraints()
    }
    
    func setSearchBarConstraints() {
        searchField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchField.widthAnchor.constraint(equalToConstant: 270),
            searchField.heightAnchor.constraint(equalToConstant: 50),
            searchField.centerXAnchor.constraint(equalTo: stackView.centerXAnchor, constant: 35),
            searchField.centerYAnchor.constraint(equalTo: stackView.centerYAnchor, constant: 25)
        ])
    }
    
//MARK: - Configure LocationButton
    func configureLocationButton() {
        view.addSubview(locationButton)
        let config = UIImage.SymbolConfiguration(pointSize: 40)
        locationButton.setImage(UIImage(systemName: "location.fill", withConfiguration: config), for: .normal)
        
        setLocationButtonContraints()
    }
    
    func setLocationButtonContraints() {
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationButton.trailingAnchor.constraint(equalTo: searchField.leadingAnchor, constant: -25),
            locationButton.centerYAnchor.constraint(equalTo: stackView.centerYAnchor,constant: 25)
        ])
    }
    
//MARK: - Configure HistoryTableView
    func configureHistoryTableView() {
        view.addSubview(historyTable)
        historyTable.backgroundColor = .clear
        historyTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        setHistoryTableViewConstraints()
    }
    
    func setHistoryTableViewConstraints() {
        historyTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            historyTable.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 20),
            historyTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            historyTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
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
