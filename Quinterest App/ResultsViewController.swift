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
    var tossupCell = "tossupCell"
    var bonusCell = "bonusCell"
    
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
        
        if resultsType == "Tossups" {
            
            // Get a valid result cell
            var cell: TossupResultTableCell = tableView.dequeueReusableCellWithIdentifier(tossupCell, forIndexPath: indexPath) as! TossupResultTableCell
            
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
            
        } else {
            
            // Get a valid result cell
            var cell: BonusResultTableCell = tableView.dequeueReusableCellWithIdentifier(bonusCell, forIndexPath: indexPath) as! BonusResultTableCell
            
            // Set the text of infoLabel
            cell.infoLabel.text = "ID: " + self.queryData[indexPath.row + 1]["ID"].asString! + " | " + self.queryData[indexPath.row + 1]["Tournament"].asString! + " | " + self.queryData[indexPath.row + 1]["Year"].asString! + " | Round: " + self.queryData[indexPath.row + 1]["Round"].asString! + " | Question: " + self.queryData[indexPath.row + 1]["Question #"].asString! + " | " + self.queryData[indexPath.row + 1]["Category"].asString!
            
            // Set attributed text of intoLabel
            if self.queryData[indexPath.row + 1]["Intro"].asString! != "" {
                var introLabel = NSMutableAttributedString(string: "Intro: ", attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(14)])
                var intro = NSMutableAttributedString(string: self.queryData[indexPath.row + 1]["Intro"].asString!)
                introLabel.appendAttributedString(intro)
                cell.introLabel.attributedText = introLabel
            } else {
                cell.introLabel.attributedText = NSMutableAttributedString(string: "")
            }
            
            // Set attributed text of question1Label
            var question1Label = NSMutableAttributedString(string: "Question 1: ", attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(14)])
            var question1 = NSMutableAttributedString(string: self.queryData[indexPath.row + 1]["Question1"].asString!)
            question1Label.appendAttributedString(question1)
            cell.question1Label.attributedText = question1Label
            
            // Set attributed text of answer1Label
            var answer1Label = NSMutableAttributedString(string: "Answer: ", attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(14)])
            var answer1 = NSMutableAttributedString(string: self.queryData[indexPath.row + 1]["Answer1"].asString!)
            answer1Label.appendAttributedString(answer1)
            cell.answer1Label.attributedText = answer1Label
            
            // Set attributed text of question2Label
            var question2Label = NSMutableAttributedString(string: "Question 2: ", attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(14)])
            var question2 = NSMutableAttributedString(string: self.queryData[indexPath.row + 1]["Question2"].asString!)
            question2Label.appendAttributedString(question2)
            cell.question2Label.attributedText = question2Label
            
            // Set attributed text of answer1Label
            var answer2Label = NSMutableAttributedString(string: "Answer: ", attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(14)])
            var answer2 = NSMutableAttributedString(string: self.queryData[indexPath.row + 1]["Answer2"].asString!)
            answer2Label.appendAttributedString(answer2)
            cell.answer2Label.attributedText = answer2Label
            
            // Set attributed text of question3Label
            var question3Label = NSMutableAttributedString(string: "Question 3: ", attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(14)])
            var question3 = NSMutableAttributedString(string: self.queryData[indexPath.row + 1]["Question3"].asString!)
            question3Label.appendAttributedString(question3)
            cell.question3Label.attributedText = question3Label
            
            // Set attributed text of answer1Label
            var answer3Label = NSMutableAttributedString(string: "Answer: ", attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(14)])
            var answer3 = NSMutableAttributedString(string: self.queryData[indexPath.row + 1]["Answer3"].asString!)
            answer3Label.appendAttributedString(answer3)
            cell.answer3Label.attributedText = answer3Label
            
            return cell
        }
        
    }

}
