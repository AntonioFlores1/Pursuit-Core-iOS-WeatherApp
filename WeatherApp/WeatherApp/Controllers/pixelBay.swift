//
//  pixelBay.swift
//  WeatherApp
//
//  Created by antonio  on 2/3/20.
//  Copyright © 2020 Pursuit. All rights reserved.
//

import Foundation
import UIKit

final class PixabayAPIClient {
    private init() {}
    
    static func getImageURLString(ofLocation: String, completionHandler: @escaping (AppError?, String?) -> Void) {
        let endpointURLString = "https://pixabay.com/api/?key=\(SecretKeys.pixelbay)&q=\(ofLocation.replacingOccurrences(of: " ", with: "").lowercased())"
        guard let url = URL(string: endpointURLString) else {
            completionHandler(AppError.badURL(endpointURLString), nil)
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(AppError.networkError(error), nil)
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -999
                    completionHandler(AppError.badStatusCode("\(statusCode)"), nil)
                    return
            }
            if let data = data {
                do {
                    let imageData = try JSONDecoder().decode(pixelBay.self, from: data)
                    completionHandler(nil, imageData.hits[Int.random(in:0...imageData.hits.count-1)].largeImageURL)
                } catch {
                    completionHandler(AppError.decodingError(error), nil)
                }
            }
        }.resume()
    }
}
