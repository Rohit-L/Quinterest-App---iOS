//
//  ViewController.swift
//  Quinterest App
//
//  Created by Rohit Lalchanadani on 6/12/15.
//  Copyright (c) 2015 Laucity. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: Outlets & Properties
    @IBOutlet weak var searchTerm: UITextField!
    @IBOutlet weak var searchTypeControl: UISegmentedControl!
    @IBOutlet weak var difficultyControl: UISegmentedControl!
    @IBOutlet weak var questionTypeControl: UISegmentedControl!
    @IBOutlet weak var categoryPickerView: UIView!
    @IBOutlet weak var tournamentPickerView: UIView!
    @IBOutlet weak var CategoriesPicker: UIPickerView!
    @IBOutlet weak var TournamentsPicker: UIPickerView!
    private var categories: JSON!
    private var tournaments: JSON!
    
    
    /************************************/
    /************************************/
    
    // MARK:-
    // MARK: UIViewController Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Set the width of the searchType segmented control
        searchTypeControl.apportionsSegmentWidthsByContent = true;
        
        // Load picker data
        loadCategories()
        loadTournaments(difficulty: "All", resultsType: "All")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /************************************/
    /************************************/
    
    // MARK:-
    // MARK: Keyboard Methods
    
    // Closes the keyboard when finished
    @IBAction func textFieldDoneEditing(sender: UITextField) {
        sender.resignFirstResponder()
        self.performSegueWithIdentifier("resultsSegue", sender: self)
    }
    
    // Keyboard if background is tapped
    @IBAction func backgroundPressedWithKeyboard(sender: UIControl) {
        searchTerm.resignFirstResponder()
    }
    
    
    /************************************/
    /************************************/
    
    // MARK:-
    // MARK: Animations
    
    // MARK: Picker Animations
    @IBAction func TournamentPickerInitiate(sender: UIButton) {
        UIView.animateWithDuration(0.5) {
            var tournamentPickerFrame = self.tournamentPickerView.frame
            tournamentPickerFrame.origin.y = self.view.frame.height - 300
            self.tournamentPickerView.frame = tournamentPickerFrame
        }
    }
    
    @IBAction func TournamentPickerTerminate(sender: UIBarButtonItem) {
        UIView.animateWithDuration(0.5) {
            var tournamentPickerFrame = self.tournamentPickerView.frame
            tournamentPickerFrame.origin.y = self.view.frame.height + 300
            self.tournamentPickerView.frame = tournamentPickerFrame
        }
    }
    
    @IBAction func CategoryPickerInitiate(sender: UIButton) {
        UIView.animateWithDuration(0.5) {
            var categoryPickerFrame = self.categoryPickerView.frame
            categoryPickerFrame.origin.y = self.view.frame.height - 300
            self.categoryPickerView.frame = categoryPickerFrame
        }
    }
    
    @IBAction func CategoryPickerTerminate(sender: UIBarButtonItem) {
        UIView.animateWithDuration(0.5) {
            var categoryPickerFrame = self.categoryPickerView.frame
            categoryPickerFrame.origin.y = self.view.frame.height + 300
            self.categoryPickerView.frame = categoryPickerFrame
        }
    }
    
    // MARK: Segue Methods
    
    // Reverse Segue Back to Search Form
    @IBAction func unwindToSearchForm(segue:UIStoryboardSegue) {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    
    /************************************/
    /************************************/
    
    // MARK:-
    // MARK: Picker Methods
    
    // MARK: Picker Data Source Methods
    
    // Returns number of components in picker
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Returns number of rows in picker
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == CategoriesPicker {
            return self.categories[0].asInt!
        } else {
            return self.tournaments[0].asInt!
        }

    }
    
    // MARK: Picker Delegate Methods
    
    // Returns data for picker rows
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if pickerView == CategoriesPicker {
            return self.categories[row + 1].asString!
        } else {
            return self.tournaments[row + 1]["name"].asString!
        }
    }
    
    
    /************************************/
    /************************************/
    
    // MARK:-
    // MARK: Load Tournament & Category Methods
    
    @IBAction func difficultyControlChanged(sender: UISegmentedControl) {
        loadTournaments(difficulty: sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)!, resultsType: questionTypeControl.titleForSegmentAtIndex(questionTypeControl.selectedSegmentIndex)!)
        TournamentsPicker.reloadAllComponents()
        TournamentsPicker.selectRow(0, inComponent: 0, animated: true)
    }
    
    @IBAction func questionTypeControlChanged(sender: UISegmentedControl) {
        loadTournaments(difficulty: difficultyControl.titleForSegmentAtIndex(difficultyControl.selectedSegmentIndex)!, resultsType: sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)!)
        TournamentsPicker.reloadAllComponents()
        TournamentsPicker.selectRow(0, inComponent: 0, animated: true)
    }
    
    // Loads the categories synchronously from MySQL database
    func loadCategories() {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://www.quinterest.org/quinterestApp/getCategories.php")!)
        var response: NSURLResponse?
        var error: NSErrorPointer = nil
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: error)
        var reply = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
        self.categories = JSON(string: reply)
    }
    
    // Loads the tournaments synchronously from MySQL database
    func loadTournaments(#difficulty:String, resultsType:String) {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://www.quinterest.org/quinterestApp/getTournaments.php")!)
        request.HTTPMethod = "POST"
        let postData = "difficulty=" + difficulty + "&resultsType=" + resultsType
        request.HTTPBody = postData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        var response: NSURLResponse?
        var error: NSErrorPointer = nil
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: error)
        var reply = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
        self.tournaments = JSON(string: reply)
    }
    
    /************************************/
    /************************************/

}
