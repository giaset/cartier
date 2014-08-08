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
        self.navigationController.navigationBar.translucent = false
        
        // Set up custom back button
        var backButton = UIBarButtonItem(title: "Back", style: .Bordered, target: self, action: "backButtonClicked")
        self.navigationItem.leftBarButtonItem = backButton;
    }
    
    func backButtonClicked() {
        self.navigationController.popViewControllerAnimated(false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController.navigationBarHidden = false
    }
    
    override func tableView(tableView: UITableView!, heightForHeaderInSection section: Int) -> CGFloat {
        return 250
    }
    
    override func tableView(tableView: UITableView!, viewForHeaderInSection section: Int) -> UIView! {
        var headerView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 250))
        headerView.backgroundColor = UIColor.blackColor()
        
        let overflowAmount: CGFloat = 500
        var topOverflowView = UIView(frame: CGRectMake(0, -overflowAmount, self.view.frame.width, overflowAmount))
        topOverflowView.backgroundColor = UIColor.blackColor()
        headerView.addSubview(topOverflowView)
        
        return headerView
    }
}
