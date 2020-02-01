//
//  ViewController.swift
//  WeatherApp
//
//  Created by Alex Paul on 1/17/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit

class DailyForcastViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var currentSummary: UILabel!
    
    @IBOutlet weak var currentImage: UIImageView!
    
    @IBOutlet weak var CurrentDes: UILabel!
    
    @IBOutlet weak var currentDetails: UILabel!
    
    @IBOutlet weak var CollectionTableView: UICollectionView!
    
    
    //MARK: - didSet
    private var dailyWeather = [DataInfo](){
        didSet {
            DispatchQueue.main.async {
                self.CollectionTableView.reloadData()
            }
        }
    }
    
    private var currentWeather = [weather](){
        didSet {
            DispatchQueue.main.async {
                self.currentImage.image = UIImage(named: (self.currentWeather.first?.currently.icon)!)
            }
        }
    }
    
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        CollectionTableView.dataSource = self
        CollectionTableView.delegate = self
        currentWeather(zipCode: "10021")
        dailyWeather(zipCode: "10021")
    }
    
    //MARK: - API Func
    private func currentWeather(zipCode:String){
        ZipCodeHelper.getLatLong(fromZipCode: zipCode) { (result) in
            switch result {
            case .success(let latLong):
                WeatherApiClient.currentWeather(lat: latLong.lat, long: latLong.long) { (error, weather) in
                    if let error = error {
                        print("Current API Weather error\(error)")
                    }
                    if let weather = weather{
                        self.currentWeather = [weather]
                    }
                }
            case .failure(let zipCodeError):
                print("ZipCode Error \(zipCodeError)")
            }
        }
    }
    
    private func dailyWeather(zipCode:String){
        ZipCodeHelper.getLatLong(fromZipCode: zipCode) { (result) in
            switch result {
            case .success(let latLong):
                WeatherApiClient.dailyWeather(lat: latLong.lat, long: latLong.long) { (error, weather) in
                    if let error = error {
                        print("Current API Weather error\(error)")
                    }
                    if let weather = weather{
                        self.dailyWeather = weather
                    }
                }
            case .failure(let zipCodeError):
                print("ZipCode Error \(zipCodeError)")
            }
        }
    }
    
    
}


//MARK: - CVFlow
extension DailyForcastViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 125, height: 175)
    }
    
}


//MARK: - CVDataSource
extension DailyForcastViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dailyWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionViewcell = CollectionTableView.dequeueReusableCell(withReuseIdentifier: "WeatherInfo", for: indexPath) as? DailyCollectionViewCell else {return UICollectionViewCell()}
        let cellInfo = dailyWeather[indexPath.row]
        collectionViewcell.forcastImage.image = UIImage(named: cellInfo.icon)
        collectionViewcell.DateLabel.text = "Today"
        collectionViewcell.forcastLabel.text = cellInfo.summary
        collectionViewcell.detailLabel.text = """
High: \(cellInfo.temperatureHigh)
Low: \(cellInfo.temperatureLow)
Humidity: \(cellInfo.humidity)
"""
        return collectionViewcell
    }
    
    
    
}


//MARK: - TextField

extension DailyForcastViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let textfield = textField.text else {
            return false
        }
        
        currentWeather(zipCode: textfield)
        dailyWeather(zipCode: textfield)
        
        return true
    }
}
