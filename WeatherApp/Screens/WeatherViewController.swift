//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Tiemi Matsumoto on 16/09/2024.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    let currentLocationButton = UIButton()
    let locationTextField = WATextField()
    let alertMessage = UIAlertController()
    
    var locationManager = CLLocationManager()
    
    var isLocationEntered: Bool {
        return !locationTextField.text!.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.33, green: 0.64, blue: 1.00, alpha: 1.00)
        
        configureCurrentLocationButton()
        configureLocationTextField()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func showAlert(title: String, message: String, preferredStyle: UIAlertController.Style = .actionSheet) {
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        actionSheet.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        DispatchQueue.main.async {
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    func fetchWeather(location: String) {
//        guard isLocationEntered else {
//            showAlert(title: "No location", message: "No location to fetch weather from", preferredStyle: .alert)
//            return
//        }
        
        NetworkManager.shared.fetchWeather(location: location) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let currentWeather):
                let description = "Temperature: \(currentWeather.temperature)\n Condition: \(currentWeather.conditionDescription)"
                showAlert(title: "Current weather for \(currentWeather.cityName), \(currentWeather.countryName)", message: description)
            case .failure(let error):
                showAlert(title: "Error", message: String(error.rawValue))
            }
        }
    }
    
    func configureCurrentLocationButton() {
        view.addSubview(currentLocationButton)
        currentLocationButton.setImage(UIImage(systemName: "location.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 36)), for: .normal)
        currentLocationButton.translatesAutoresizingMaskIntoConstraints = false
        
        currentLocationButton.addTarget(self, action: #selector(getWeatherForLocation), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            currentLocationButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            currentLocationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            currentLocationButton.widthAnchor.constraint(equalToConstant: 50),
            currentLocationButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func getWeatherForLocation() {
        locationManager.requestLocation()
    }
    
    func configureLocationTextField() {
        view.addSubview(locationTextField)
        
        locationTextField.translatesAutoresizingMaskIntoConstraints = false
        
        locationTextField.delegate = self
        
        NSLayoutConstraint.activate([
            locationTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            locationTextField.leadingAnchor.constraint(equalTo: currentLocationButton.trailingAnchor, constant: 20),
            locationTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            locationTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        fetchWeather(location: locationTextField.text!)
        return true
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            fetchWeather(location: "\(lat),\(lon)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

