//
//  DetailViewController.swift
//  Cartier
//
//  Created by Gianni Settino on 2014-08-03.
//  Copyright (c) 2014 Milton and Parc. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.086, green: 0.627, blue: 0.522, alpha: 1)
        
        self.navigationController.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController.navigationBarHidden = false
    }
    
}
