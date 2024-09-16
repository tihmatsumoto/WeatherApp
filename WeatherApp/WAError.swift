//
//  WAError.swift
//  WeatherApp
//
//  Created by Tiemi Matsumoto on 16/09/2024.
//

import Foundation

enum WAError: String, Error {
    case invalidLocation = "This location is not available. Please try another one."
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response. Please try again."
    case invalidData = "Invalid data. Please try again."
}
