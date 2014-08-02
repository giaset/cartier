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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController.navigationBarHidden = false
    }
    
}
