//
//  ViewController.swift
//  WeatherApp
//
//  Created by Alex Paul on 1/17/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit

class DailyForcastViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var backGroundView: UIView!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var currentSummary: UILabel!
    
    @IBOutlet weak var cityImage: UIImageView!
    
    @IBOutlet weak var CurrentDes: UILabel!
    
    @IBOutlet weak var currentDetails: UILabel!
    
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var CollectionTableView: UICollectionView!
    
    @IBOutlet weak var currentView: UIView!
    
    
    var location: String? {
        didSet {
            self.currentSummary.text = "\(location!)"
            self.mainLabel.text = location!
        }
    }
    
    
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
               
                
                let cityName = self.currentWeather.first?.timezone.replacingOccurrences(of: "/", with: " ")
                let array = cityName?.components(separatedBy: " ")
                self.location = array![1].replacingOccurrences(of: "_", with: " ")
                                        
                               if self.location == "New York" {
                                   self.cityImage.image = UIImage(named: "newYorkCity")
                               } else if self.location == "Los Angeles"{
                                   self.cityImage.image = UIImage(named: "los angeles")
                                   
                               } else {
                                   self.cityImage.image = UIImage(named: "default city")
                               }
                
                self.CurrentDes.text = self.currentWeather.first?.currently.summary
                self.currentDetails.text = "   \(Int(self.currentWeather.first!.currently.temperature))°"
                
                
            }
        }
    }
    
    
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
//      backGroundView.backgroundColor = .red

//        let gradient = CAGradientLayer()
//        let darkBlue = UIColor(displayP3Red: 23, green: 39, blue: 54, alpha: 1)
//        let lightBlue = UIColor(displayP3Red: 34, green: 56, blue: 77, alpha: 1)
//        gradient.colors = [UIColor.red,UIColor.green]
//        gradient.frame = backGroundView.bounds
//        gradient.frame = view.bounds
////        gradient.startPoint = CGPoint(x:0.0, y:0.5)
////        gradient.endPoint = CGPoint(x:1.0,y:0.5)
////        backGroundView.layer.addSublayer(gradient)
//        backGroundView.layer.insertSublayer(gradient, at: 0)
//        view.layer.addSublayer(gradient)
        setGradientColour()
    }
    
    
    func setGradientColour() {
//        let colorTop = UIColor(red: 14/255.0, green: 21/255.0, blue: 27/255.0, alpha: 1.0)
//        let colorBottom = UIColor(red: 34/255.0, green: 56/255.0, blue: 77/255.0, alpha: 1.0)
////        let gradientLayer = CAGradientLayer()
////        gradientLayer.colors = [colorTop, colorBottom]
//////        gradientLayer.startPoint = CGPoint(x:0.0, y:0.5)
//////        gradientLayer.endPoint = CGPoint(x:1.0,y:0.5)
////        gradientLayer.frame = scrollView.frame
////        scrollView.layer.addSublayer(gradientLayer)
//        
//        backGroundView.backgroundColor = colorTop
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
      currentView.layer.cornerRadius = 20
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
                        dump(weather)
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
    
    //MARK: - Prepare For Segueb
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? DetailViewController,let indexpath = CollectionTableView.indexPathsForSelectedItems?.first else {
            return
        }
        
        detailVC.detailInfo = dailyWeather[indexpath.row]
        detailVC.location = location
    }
}



//MARK: - CVFlow
extension DailyForcastViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 240, height: 300)
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
        collectionViewcell.layer.cornerRadius = 28
        collectionViewcell.forcastImage.image = UIImage(named: cellInfo.icon)
        collectionViewcell.DateLabel.text = "\(Int(cellInfo.temperatureHigh))°"
        collectionViewcell.forcastLabel.text = cellInfo.summary
        collectionViewcell.detailLabel.text = """
High: \(cellInfo.temperatureHigh) Low: \(cellInfo.temperatureLow)
Humidity: \(cellInfo.humidity)
"""
        return collectionViewcell
    }
    
    
    
}


//MARK: - TextField

extension DailyForcastViewController:UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.scrollView.contentOffset.y = 500
        }, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let textfield = textField.text else {
            return false
        }
        
        currentWeather(zipCode: textfield)
        dailyWeather(zipCode: textfield)
        scrollView.contentOffset.y = 100
        
        textField.resignFirstResponder()
        return true
    }
}
