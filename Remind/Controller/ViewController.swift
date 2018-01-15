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
    }
    
    @IBAction func onDateTapped(_ sender: Any) {
        print("date")
    }
    
    @IBAction func onLocationTapped(_ sender: Any) {
        print("location")
    }
    
    
    
    
}

