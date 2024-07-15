//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Tiemi Matsumoto on 12/07/2024.
//

import Foundation

struct WeatherData: Decodable {
    let location: Location
    let current: Current
}

struct Location: Decodable {
    let name: String
    let country: String
}

struct Current: Decodable {
    let temp_c: Double
    let condition: Condition
}

struct Condition: Decodable {
    let code: Int
    let text: String
}

enum ApiError: Error {
    case invalidURL
    case invalidKey
    case invalidResponse
}
