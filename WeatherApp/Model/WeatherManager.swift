//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Tiemi Matsumoto on 12/07/2024.
//

import Foundation

protocol WeatherManagerDelegate: NSObject {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: String)
}

struct WeatherManager {
    let weatherURL = "https://api.weatherapi.com/v1/current.json?Key=60e52bb659f74de3a0e114844240807"
    
    weak var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {(data, response, error) in
                
                if let httpResponse = response as? HTTPURLResponse {
                    
                    if httpResponse.statusCode == 400 {
                        self.delegate?.didFailWithError(error: "Invalid Location")
                        return
                    }
                    if httpResponse.statusCode != 200 {
                        self.delegate?.didFailWithError(error: "Critical Error, Check Server")
                        return
                    }
                } else {
                    
                    self.delegate?.didFailWithError(error: "Critical Error, Check Response Type")
                    return
                    
                }
                
                if let safeData = data {
                    if let weather = parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let code = decodedData.current.condition.code
            let temp = decodedData.current.temp_c
            let name = decodedData.location.name
            let country = decodedData.location.country
            let condition = decodedData.current.condition.text
            
            let weather = WeatherModel(conditionId: code, cityName: name, countryName: country, temperature: temp, conditionDescription: condition)
            return weather
        } catch {
            delegate?.didFailWithError(error: "Invalid Response")
            return nil
        }
    }
}
