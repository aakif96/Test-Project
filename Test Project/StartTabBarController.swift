//
//  StartTabBarController.swift
//  Test Project
//
//  Created by Alen Akif on 23.11.22..
//

import Foundation
import UIKit

class StartTabBarController:UITabBarController{
    //let defaultIndex: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = UserDefaults.standard.integer(forKey: "tab_bar")
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.set(selectedIndex, forKey: "tab_bar")
    }
}
