////
////  WeatherViewController.swift
////  WeatherApp
////
////  Created by Tiemi Matsumoto on 12/07/2024.
////
//
//import UIKit
//
//class WeatherAAAViewController: UIViewController {
//    
//    
//    
////MARK: - Variables
//
//    let weatherView = WeatherView()    
//    var weatherManager = WeatherManager()
//    
//    //MARK: - Load
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        
//        weatherManager.delegate = self
//        
//        configureUI()
//    }
//    
//    func configureUI() {
//        view.addSubview(weatherView)
//        weatherView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            weatherView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            weatherView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            weatherView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            weatherView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//        ])
//    }
//}
//
////MARK: - WeatherManagerDelegate
//extension WeatherViewController: WeatherManagerDelegate {
//    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
//        let description = "City/Country: \(weather.cityName), \(weather.countryName) \n Temperature: \(weather.temperature) \n Condition: \(weather.conditionDescription)"
//        let alertController = UIAlertController(title: "Weather Conditions", message: "\(description)", preferredStyle: .actionSheet)
//        alertController.addAction(UIAlertAction(title: "Return", style: .cancel, handler: nil))
//        DispatchQueue.main.async {
//            self.present(alertController, animated: true, completion: nil)
//        }
//    }
//    
//    func didFailWithError(error: String) {
//        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        DispatchQueue.main.async {
//            self.present(alertController, animated: true, completion: nil)
//        }
//    }
//}
