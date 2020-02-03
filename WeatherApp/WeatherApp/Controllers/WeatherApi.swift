//
//  WeatherApi.swift
//  WeatherApp
//
//  Created by Pursuit on 1/20/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import Foundation

final class WeatherApiClient{
    
    // MARK: - Daily Weather API

static func dailyWeather(lat:Double,long:Double, completionHandler: @escaping (AppError?,[DataInfo]?) -> Void) {
let WeatherUrl = "https://api.darksky.net/forecast/\(SecretKeys.APIkey)/\(lat),\(long)"
NetworkHelper.shared.performDataTask(endpointURLString:WeatherUrl, httpMethod: "GET", httpBody: nil) { (appError, data, httpResponse) in
            if let appError = appError {
                completionHandler(appError,nil)
                 print("Here0")
            }
            guard let response = httpResponse,
                (200...299).contains(response.statusCode) else {
                    let statusCode = httpResponse?.statusCode ?? -999
                    completionHandler(AppError.badStatusCode(String(statusCode)), nil)
                    return
            }
            if let data = data {
                do {
                    let WeatherData = try JSONDecoder().decode(weather.self, from: data)
                    completionHandler(nil,WeatherData.daily.data)
                } catch {                    completionHandler(AppError.decodingError(error),nil)
                }
            }
        }
}
    
    
    // MARK: - Current Weather API
    
    static func currentWeather(lat:Double,long:Double, completionHandler: @escaping (AppError?,weather?) -> Void) {
    let WeatherUrl = "https://api.darksky.net/forecast/\(SecretKeys.APIkey)/\(lat),\(long)"
    NetworkHelper.shared.performDataTask(endpointURLString:WeatherUrl, httpMethod: "GET", httpBody: nil) { (appError, data, httpResponse) in
                if let appError = appError {
                    completionHandler(appError,nil)
                }
                guard let response = httpResponse,
                    (200...299).contains(response.statusCode) else {
                        let statusCode = httpResponse?.statusCode ?? -999
                        completionHandler(AppError.badStatusCode(String(statusCode)), nil)
                        return
                }
                if let data = data {
                    do {
                        let WeatherData = try JSONDecoder().decode(weather.self, from: data)
                        completionHandler(nil,WeatherData)
                    } catch {                        completionHandler(AppError.decodingError(error),nil)
                    }
                }
            }
    }
}
