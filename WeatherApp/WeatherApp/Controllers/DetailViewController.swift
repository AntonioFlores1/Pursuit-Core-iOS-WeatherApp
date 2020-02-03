//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Pursuit on 1/20/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit
import ImageKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detialHeader: UILabel!
    
    @IBOutlet weak var detailImage: UIImageView!
    
    @IBOutlet weak var detailSummary: UILabel!
    
    @IBOutlet weak var detailDesc: UILabel!
    
    
    var detailInfo: DataInfo?
    
    var location: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pixelBayAPI()
        
        detialHeader.text = "Weather Forcast for \(location!)"
        detailImage.image = UIImage.init(named: (detailInfo?.icon)!)
        detailSummary.text = detailInfo?.summary
        detailDesc.text = """
        High: \(detailInfo!.temperatureHigh)     Low: \(detailInfo!.temperatureLow)
        Humidity: \(detailInfo!.humidity)    uvIndex: \(detailInfo!.uvIndex)
        Visibility: \(detailInfo!.visibility) WindSpeed: \(detailInfo!.windSpeed)
        """
        
    }
    
    
    
    func pixelBayAPI(){
        PixabayAPIClient.getImageURLString(ofLocation: location!) { (error, image) in
            if let error = error {
                print(error)
            }
            
            print(self.location)
            if let largImage = image{
                print(largImage)
                
                DispatchQueue.main.async {
                    
                    self.detailImage.getImage(with: largImage) { (result) in
                        switch result {
                        case .failure(let error):
                            print("Image error \(error)")
                            
                        case .success(let image):
                            DispatchQueue.main.async {
                                self.detailImage.image = image
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        if let image = detailImage.image {
            if let imageToSave = image.jpegData(compressionQuality: 0.5) {
                let date = Date()
                let isoDateFormatter = ISO8601DateFormatter()
                isoDateFormatter.formatOptions = [.withFullDate,
                                                  .withFullTime,
                                                  .withInternetDateTime,
                                                  .withTimeZone,
                                                  .withDashSeparatorInDate]
                let timeStamp = isoDateFormatter.string(from: date)
                let favoriteImage = Favorite.init(addedDate: timeStamp, imageData: imageToSave)
                FavoritesModel.addFavoriteImage(favoriteImage: favoriteImage)
                showAlert(message: "Successfully favorited image")
            } else {
                print("image can't be compressed to jpeg")
                showAlert(message: "Can not favorite image")
            }
        } else {
            print("image does not exist")
            showAlert(message: "Can not favorite image")
        }
    }
    
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
}
