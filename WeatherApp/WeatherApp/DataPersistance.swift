//
//  DataPersistance.swift
//  WeatherApp
//
//  Created by antonio  on 2/3/20.
//  Copyright © 2020 Pursuit. All rights reserved.
//


import Foundation

final class DataPersistenceManager {
    static func documentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    static func filepathToDocumentsDirectory(filename: String) -> URL {
        return documentsDirectory().appendingPathComponent(filename)
    }
}
