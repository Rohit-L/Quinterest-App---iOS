//
//  ResultsViewController.swift
//  Quinterest App
//
//  Created by Rohit Lalchanadani on 6/12/15.
//  Copyright (c) 2015 Laucity. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Reference to Table View
    @IBOutlet weak var tableView: UITableView!
    var resultsCellIdentifier = "cell"
    
    // MARK: Reference to Navigation Bar
    @IBOutlet weak var resultsNavigationBar: UINavigationItem!
    
    // MARK: Search Form Data
    var searchTermText: String!
    var searchType: String!
    var resultsType: String!
    var difficulty: String!
    var category: String!
    var tournament: String!
    
    // MARK: Query Results
    var queryData: JSON!
    
    // MARK:-
    // MARK: UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set status bar color when view loads
        UIApplication.sharedApplication().statusBarStyle = .Default
        
        // Send data to server
        getQueryData()
        
        // Set table view for dynamic row height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 300
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
        self.tableView.reloadData()
        
        // Set Navigation Bar Title
        resultsNavigationBar.title = String(self.queryData[0].asInt!) + " " + resultsType + " Found"
        
    }
    
    // MARK:-
    // MARK: HTTP Methods
    
    // Synchronous HTTP Request to Get Results from MySQL Database
    func getQueryData() {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://www.quinterest.org/quinterestApp/getSearchResults.php")!)
        request.HTTPMethod = "POST"
        let postData = "search=" + searchTermText + "&searchType=" + searchType + "&resultsType=" + resultsType + "&difficulty=" + difficulty + "&category=" + category + "&tournament=" + tournament
        request.HTTPBody = postData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        var response: NSURLResponse?
        var error: NSErrorPointer = nil
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: error)
        if data == nil {
            getQueryData()
            return
        }
        var reply = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
        queryData = JSON(string: reply)
    }

    // MARK:-
    // MARK: UITableViewDataSource Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queryData[0].asInt!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Get a valid result cell
        var cell: ResultTableCell = tableView.dequeueReusableCellWithIdentifier(resultsCellIdentifier, forIndexPath: indexPath) as! ResultTableCell
        
        // Set the text of infoLabel
        cell.infoLabel.text = "ID: " + self.queryData[indexPath.row + 1]["ID"].asString! + " | " + self.queryData[indexPath.row + 1]["Tournament"].asString! + " | " + self.queryData[indexPath.row + 1]["Year"].asString! + " | Round: " + self.queryData[indexPath.row + 1]["Round"].asString! + " | Question: " + self.queryData[indexPath.row + 1]["Question #"].asString! + " | " + self.queryData[indexPath.row + 1]["Category"].asString!
        
        // Set attributed text of questionLabel
        var questionLabel = NSMutableAttributedString(string: "Question: ", attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(14)])
        var question = NSMutableAttributedString(string: self.queryData[indexPath.row + 1]["Question"].asString!)
        questionLabel.appendAttributedString(question)
        cell.questionLabel.attributedText = questionLabel
        
        // Set attributed text of answerLabel
        var answerLabel = NSMutableAttributedString(string: "Answer: ", attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(14)])
        var answer = NSMutableAttributedString(string: self.queryData[indexPath.row + 1]["Answer"].asString!)
        answerLabel.appendAttributedString(answer)
        cell.answerLabel.attributedText = answerLabel
        
        return cell
    }

}
