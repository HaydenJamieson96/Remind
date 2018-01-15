//
//  ViewController.swift
//  Remind
//
//  Created by Hayden Jamieson on 15/01/2018.
//  Copyright © 2018 Hayden Jamieson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UNService.shared.authorize()
    }

    
    @IBAction func onTimerTapped(_ sender: Any) {
        print("timer")
        AlertService.actionSheet(in: self, title: "5 seconds") {
            UNService.shared.timerRequest(withInterval: 5)
        }
        
    }
    
    @IBAction func onDateTapped(_ sender: Any) {
        print("date")
        AlertService.actionSheet(in: self, title: "Some future time") {
            var components = DateComponents()
            components.second = 0
            
            UNService.shared.dateRequest(withComponents: components)
        }
        
    }
    
    @IBAction func onLocationTapped(_ sender: Any) {
        print("location")
        AlertService.actionSheet(in: self, title: "When I return") {
            
        }
    }
    
    
    
    
}

