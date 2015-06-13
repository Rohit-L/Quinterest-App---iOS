//
//  ResultsViewController.swift
//  Quinterest App
//
//  Created by Rohit Lalchanadani on 6/12/15.
//  Copyright (c) 2015 Laucity. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    var searchTermText: String!
    var searchType: String!
    var resultsType: String!
    var difficulty: String!
    var category: String!
    var tournament: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().statusBarStyle = .Default

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
