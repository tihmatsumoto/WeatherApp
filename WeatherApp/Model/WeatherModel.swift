//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Tiemi Matsumoto on 12/07/2024.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let countryName: String
    let temperature: String
    let conditionDescription: String
    
    var conditionSymbol: String {
        switch conditionId {
        case 1000:
            return "sun.max"
        case 1003...1087:
            return "cloud"
        case 1114...1117:
            return "snowflake"
        case 1150...1201:
            return "cloud.rain"
        case 1204...1237:
            return "cloud.snow"
        case 1240...1246:
            return "cloud.rain"
        case 1249...1264:
            return "cloud.snow"
        case 1273...1282:
            return "cloud.bolt.rain"
        default:
            return "cloud"
        }
    }
    
    init(from data: WeatherData) {
        self.cityName = "\(data.location.name)"
        self.countryName = "\(data.location.country)"
        self.temperature = "\(data.current.temp_c) °C"
        self.conditionDescription = "\(data.current.condition.text)"
        self.conditionId = data.current.condition.code
    }
}
