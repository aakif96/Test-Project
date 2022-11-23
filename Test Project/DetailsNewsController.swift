//
//  DetailsNewsController.swift
//  Test Project
//
//  Created by Alen Akif on 17.11.22..
//

import Foundation
import UIKit

class DetailsNewsController:UIViewController{
    let news: News
    
    @IBOutlet var detailsNewsImageView: UIImageView!
    
    @IBOutlet var detailsNewsLabel: UILabel!
    
    @IBOutlet var titleOnImage: UILabel!
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            if let data = try? Data(contentsOf: URL(string: news.rotatedImageUrl)!) {
                // Create Image and Update Image View
                detailsNewsImageView.image = UIImage(data: data)
                print("radi")
                
            }
            
        }else{
            if let data = try? Data(contentsOf: URL(string: news.largeImgUrl)!) {
                // Create Image and Update Image View
                detailsNewsImageView.image = UIImage(data: data)
                
            }
        }
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsNewsLabel.text = news.title
        titleOnImage.text = news.title
        
        if UIApplication.shared.statusBarOrientation.isLandscape {
            if let data = try? Data(contentsOf: URL(string: news.rotatedImageUrl)!) {
                // Create Image and Update Image View
                detailsNewsImageView.image = UIImage(data: data)
                print("radi")
                
            }
        } else {
            if let data = try? Data(contentsOf: URL(string: news.largeImgUrl)!) {
                // Create Image and Update Image View
                detailsNewsImageView.image = UIImage(data: data)
                
            }
                   
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("Fatal Error")
    }
    init?(coder: NSCoder, news: News) {
        self.news = news
        
        super.init(coder: coder)
    }
    
}
