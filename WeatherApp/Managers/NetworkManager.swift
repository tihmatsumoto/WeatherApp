//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Tiemi Matsumoto on 12/07/2024.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    private let baseURL = "https://api.weatherapi.com/v1/current.json?Key=60e52bb659f74de3a0e114844240807"
    
    private init() {}
    
    func fetchWeather(location: String, completed: @escaping (Result<WeatherModel, WAError>) -> Void) {
        let endpoint = "\(baseURL)&q=\(location)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidLocation))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            //if there is an error outside of api call error. Connection or other
            if let _  = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            //if response not nil, then, check status code
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let currentWeather = try decoder.decode(WeatherData.self, from: data)
                let modelWeather = WeatherModel(from: currentWeather)
                completed(.success(modelWeather))
            } catch {
                completed(.failure(.invalidData))
                return
            }
        }
        task.resume()
    }
}
//
//protocol WeatherManagerDelegate{
//    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
//    func didFailWithError(error: String)
//}
//
//struct WeatherManager {
//    let weatherURL = "https://api.weatherapi.com/v1/current.json?Key=60e52bb659f74de3a0e114844240807"
//
//    var delegate: WeatherManagerDelegate?
//
//    func fetchWeather(cityName: String) {
//        let urlString = "\(weatherURL)&q=\(cityName)"
//        performRequest(with: urlString)
//    }
//
//    func performRequest(with urlString: String) {
//        if let url = URL(string: urlString) {
//            let session = URLSession(configuration: .default)
//            let task = session.dataTask(with: url) {(data, response, error) in
//
//                if let httpResponse = response as? HTTPURLResponse {
//                    if httpResponse.statusCode == 400 {
//                        self.delegate?.didFailWithError(error: "Invalid location")
//                        return
//                    }
//                    if httpResponse.statusCode != 200 {
//                        self.delegate?.didFailWithError(error: "Critical error. Verify server response")
//                        return
//                    }
//                } else {
//                    self.delegate?.didFailWithError(error: "Critical Error. Verify server response")
//                    return
//                }
//
//                if let safeData = data {
//                    if let weather = parseJSON(safeData) {
//                        self.delegate?.didUpdateWeather(self, weather: weather)
//                    }
//                }
//            }
//            task.resume()
//        }
//    }
//
//    func parseJSON(_ weatherData: Data) -> WeatherModel? {
//        let decoder = JSONDecoder()
//        do {
//            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
//            let code = decodedData.current.condition.code
//            let temp = decodedData.current.temp_c
//            let city = decodedData.location.name
//            let country = decodedData.location.country
//            let condition = decodedData.current.condition.text
//
//            let weather = WeatherModel(conditionId: code, cityName: city, countryName: country, temperature: temp, conditionDescription: condition)
//            return weather
//        } catch {
//            delegate?.didFailWithError(error: "Invalid response")
//            return nil
//        }
//    }
//}
