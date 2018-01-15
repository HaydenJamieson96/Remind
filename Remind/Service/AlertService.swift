//
//  AlertService.swift
//  Remind
//
//  Created by Hayden Jamieson on 15/01/2018.
//  Copyright © 2018 Hayden Jamieson. All rights reserved.
//

import UIKit

class AlertService {
    
    private init() {}
    
    //no threading
    static func actionSheet(in vc: UIViewController, title: String, completion: @escaping () -> Void ) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: title, style: .default) { (_) in
            completion()
        }
        alert.addAction(action)
        vc.present(alert, animated: true, completion: nil)
    }
    
}
