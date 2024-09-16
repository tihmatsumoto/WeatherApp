////
////  WeatherView.swift
////  WeatherApp
////
////  Created by Tiemi Matsumoto on 18/07/2024.
////
//
//import UIKit
//
//class WeatherView: UIView {
//    
//    //MARK: - Variables
//    let stackView = UIStackView()
//    let searchField = UISearchTextField()
//    let locationButton = UIButton()
//    let historyTable = UITableView()
////    let actionSheet = UIAlertController()
//    
//    var locations: [String] = []
//    
//    let weatherManager = WeatherManager()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        searchField.delegate = self
//        historyTable.dataSource = self
//        historyTable.delegate = self
//        configureUI()
//        
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("NSCoder has not been implemented")
//    }
//    
//    //MARK: - Configure UI
//    func configureUI() {
//        configureStackView()
//        configureSearchBar()
//        configureLocationButton()
////        configureHistoryTableView()
//    }
//    
//    //MARK: - Configure StackView
//    func configureStackView() {
//        addSubview(stackView)
//        stackView.axis = .horizontal
//        stackView.distribution = .equalCentering
//        stackView.spacing = 30
//        
//        stackView.addArrangedSubview(locationButton)
//        stackView.addArrangedSubview(searchField)
//        
//        setStackViewConstraints()
//    }
//    
//    func setStackViewConstraints() {
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
//        stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
//        stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
//    }
//    
//    //MARK: - Configure SearchBar
//    func configureSearchBar() {
//        searchField.placeholder = "Type city"
//        searchField.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            searchField.heightAnchor.constraint(equalToConstant: 50),
//            searchField.centerXAnchor.constraint(equalTo: stackView.centerXAnchor, constant: 35),
//        ])
//    }
//    
//    //MARK: - Configure LocationButton
//    func configureLocationButton() {
//        let config = UIImage.SymbolConfiguration(pointSize: 36)
//        locationButton.setImage(UIImage(systemName: "location.fill", withConfiguration: config), for: .normal)
//        locationButton.translatesAutoresizingMaskIntoConstraints = false
//    }
//    
//    
//    //MARK: - Configure HistoryTableView
//    func configureHistoryTableView() {
//        addSubview(historyTable)
//        historyTable.backgroundColor = .clear
//        historyTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        historyTable.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            historyTable.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
//            historyTable.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
//            historyTable.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
//            historyTable.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
//        ])
//    }
//}
//
////MARK: - SearchField Delegate
//
//extension WeatherView: UITextFieldDelegate {
//    func searchTyped(_sender: UITextField) {
//        searchField.endEditing(true)
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        searchField.endEditing(true)
//        return true
//    }
//    
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        if textField.text != "" {
//            return true
//        } else {
//            textField.placeholder = "Type a city"
//            return false
//        }
//    }
//    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if let city = searchField.text { //optional unwrap
//            weatherManager.fetchWeather(cityName: city)
//        }
//        searchField.text = ""
//    }
//}
//
////MARK: - TableView
//extension WeatherView: UITableViewDataSource, UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return locations.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = locations[indexPath.row]
//        cell.selectionStyle = .none
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        weatherManager.fetchWeather(cityName: locations[indexPath.row])
//    }
//}
