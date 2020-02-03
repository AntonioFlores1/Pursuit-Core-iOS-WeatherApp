//
//  pixelBayModel.swift
//  WeatherApp
//
//  Created by antonio  on 2/3/20.
//  Copyright © 2020 Pursuit. All rights reserved.
//

import Foundation


struct pixelBay: Codable {
    let hits: [hitInfo]
}

struct hitInfo:Codable {
   let largeImageURL: String
}
