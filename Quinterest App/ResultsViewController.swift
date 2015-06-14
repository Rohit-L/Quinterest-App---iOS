//
//  ResultsViewController.swift
//  Quinterest App
//
//  Created by Rohit Lalchanadani on 6/12/15.
//  Copyright (c) 2015 Laucity. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var resultsCellIdentifier = "cell"
    
    var searchTermText: String!
    var searchType: String!
    var resultsType: String!
    var difficulty: String!
    var category: String!
    var tournament: String!
    var queryData: JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().statusBarStyle = .Default
        
        getQueryData()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 300
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
        self.tableView.reloadData()
        
    }
    
    // Synchronous HTTP Request to Get Results from MySQL Database
    func getQueryData() {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://www.quinterest.org/quinterestApp/getSearchResults.php")!)
        request.HTTPMethod = "POST"
        let postData = "search=" + searchTermText + "&searchType=" + searchType + "&resultsType=" + resultsType + "&difficulty=" + difficulty + "&category=" + category + "&tournament=" + tournament
        println(postData)
        request.HTTPBody = postData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        var response: NSURLResponse?
        var error: NSErrorPointer = nil
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: error)
        if data == nil {
            getQueryData()
            return
        }
        var reply = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
        println("REPLY:")
        println(reply)
        queryData = JSON(string: reply)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queryData[0].asInt!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: ResultTableCell = tableView.dequeueReusableCellWithIdentifier(resultsCellIdentifier, forIndexPath: indexPath) as! ResultTableCell
        
        cell.infoLabel.text = "ID: " + self.queryData[indexPath.row + 1]["ID"].asString! + " | " + self.queryData[indexPath.row + 1]["Tournament"].asString! + " | " + self.queryData[indexPath.row + 1]["Year"].asString! + " | Round: " + self.queryData[indexPath.row + 1]["Round"].asString! + " | Question: " + self.queryData[indexPath.row + 1]["Question #"].asString! + " | " + self.queryData[indexPath.row + 1]["Category"].asString!
        
        //cell.IDLabel.text = "ID: " + self.queryData[indexPath.row + 1]["ID"].asString!
        
        cell.questionLabel.text = "Question: " + self.queryData[indexPath.row + 1]["Question"].asString!
        
        cell.answerLabel.text = "Answer: " + self.queryData[indexPath.row + 1]["Answer"].asString!
        
        return cell
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
