//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Pursuit on 1/20/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detialHeader: UILabel!

    @IBOutlet weak var detailImage: UIImageView!
    
    @IBOutlet weak var detailSummary: UILabel!

    @IBOutlet weak var detailDesc: UILabel!
    
    
    var detailInfo: DataInfo?
    
    
    override func viewDidLoad() {
           super.viewDidLoad()

        detailImage.image = UIImage.init(named: (detailInfo?.icon)!)
        detailSummary.text = detailInfo?.summary
        detailDesc.text = """
High: \(detailInfo!.temperatureHigh)
Low: \(detailInfo!.temperatureLow)
Humidity: \(detailInfo!.humidity)
"""
        
       }

//    @IBAction func arSegue(_ sender: UIBarButtonItem) {
//        if #available(iOS 13.0, *) {
//            guard let arVC = storyboard?.instantiateViewController(identifier: "ARView") as? RealViewController else {
//                return
//            }
//            present(arVC, animated: true, completion: nil)
//
//        } else {
//            // Fallback on earlier versions
//
//        }
//    }
}
