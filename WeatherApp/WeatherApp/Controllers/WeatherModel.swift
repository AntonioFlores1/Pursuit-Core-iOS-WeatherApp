//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Pursuit on 1/20/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import Foundation

struct weather:Codable {
    let latitude: Double
    let longitude:Double
    let timezone: String
    let currently: Today
    let daily: Weekly
    
}
struct Today: Codable{
    let time: Int
    let summary: String
    let icon: String
    let temperature: Double
    let humidity: Double
    let uvIndex: Double
    let visibility: Double
}

struct Weekly:Codable {
    let summary: String
    let icon: String
    let data: [DataInfo]
}

struct DataInfo:Codable {
    let time: Int
    let summary: String
    let icon: String
    let temperatureHigh: Double
    let temperatureLow: Double
    let humidity:Double
    let windSpeed: Double
    let uvIndex: Double
    let visibility:Double
    let temperatureMin: Double
    let temperatureMax: Double
}
