//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Tiemi Matsumoto on 12/07/2024.
//

import Foundation

struct WeatherModel {
    let cityName: String
    let countryName: String
    let temperature: String
    let conditionDescription: String
    
    init(from data: WeatherData) {
        self.cityName = "\(data.location.name)"
        self.countryName = "\(data.location.country)"
        self.temperature = "\(data.current.temp_c) °C"
        self.conditionDescription = "\(data.current.condition.text)"
    }
}
