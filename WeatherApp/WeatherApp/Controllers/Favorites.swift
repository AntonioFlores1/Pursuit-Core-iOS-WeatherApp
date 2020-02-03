//
//  FavoriteModel.swift
//  WeatherApp
//
//  Created by antonio  on 2/3/20.
//  Copyright © 2020 Pursuit. All rights reserved.
//

import Foundation

struct Favorite: Codable {
    let addedDate: String
    let imageData: Data
    
    public var date: Date {
        let isoDateFormatter = ISO8601DateFormatter()
        var formattedDate = Date()
        if let date = isoDateFormatter.date(from: addedDate) {
            formattedDate = date
        }
        return formattedDate
    }
}
