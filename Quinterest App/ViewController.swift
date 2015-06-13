//
//  ViewController.swift
//  Quinterest App
//
//  Created by Rohit Lalchanadani on 6/12/15.
//  Copyright (c) 2015 Laucity. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: Outlets & Properties

    @IBOutlet weak var searchTerm: SpringTextField!
    @IBOutlet weak var searchTypeControl: UISegmentedControl!
    @IBOutlet weak var difficultyControl: UISegmentedControl!
    @IBOutlet weak var questionTypeControl: UISegmentedControl!
    @IBOutlet weak var categoryPickerView: UIView!
    @IBOutlet weak var tournamentPickerView: UIView!
    @IBOutlet weak var categoriesPicker: UIPickerView!
    @IBOutlet weak var tournamentsPicker: UIPickerView!
    private var categories: JSON!
    private var tournaments: JSON!
    
    
    /************************************/
    /************************************/
    
    // MARK:-
    // MARK: UIViewController Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Set the width of the searchType segmented control
        //searchTypeControl.apportionsSegmentWidthsByContent = true;
        
        // Load picker data
        loadCategories()
        loadTournaments(difficulty: "All", resultsType: "All")
                
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func jiggleAnimation(#viewToAnimate: UIView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.02
        animation.repeatCount = 8
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(viewToAnimate.center.x - 10, viewToAnimate.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(viewToAnimate.center.x + 10, viewToAnimate.center.y))
        viewToAnimate.layer.addAnimation(animation, forKey: "position")
    }
    
    func wiggleAnimation(#viewToAnimate: UIView) {
        var transform:CATransform3D = CATransform3DMakeRotation(0.08, 0, 0, 1.0);
        var animation:CABasicAnimation = CABasicAnimation(keyPath: "transform");
        animation.toValue = NSValue(CATransform3D: transform);
        animation.autoreverses = true;
        animation.duration = 0.1;
        animation.repeatCount = 10;
        animation.delegate = self;
        viewToAnimate.layer.addAnimation(animation, forKey: "wiggleAnimation");
    }
    
    //func squeezeUpAnimation
    
    /************************************/
    /************************************/
    
    // MARK:-
    // MARK: Keyboard Methods
    
    // Closes the keyboard when finished
    @IBAction func textFieldDoneEditing(sender: SpringTextField) {
        if sender.text == "" {
            sender.animation = "shake"
            sender.curve = "spring"
            sender.duration = 1.0
            sender.animate()
        } else {
            self.performSegueWithIdentifier("resultsSegue", sender: self)
        }
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
        UIView.animateWithDuration(0.3) {
            var tournamentPickerFrame = self.tournamentPickerView.frame
            tournamentPickerFrame.origin.y = self.view.frame.height - tournamentPickerFrame.height
            self.tournamentPickerView.frame = tournamentPickerFrame
        }
    }
    
    @IBAction func TournamentPickerTerminate(sender: UIBarButtonItem) {
        UIView.animateWithDuration(0.3) {
            var tournamentPickerFrame = self.tournamentPickerView.frame
            tournamentPickerFrame.origin.y = self.view.frame.height + tournamentPickerFrame.height
            self.tournamentPickerView.frame = tournamentPickerFrame
        }
    }
    
    @IBAction func CategoryPickerInitiate(sender: UIButton) {
        //self.categoryPickerView.animation = "slideUp"
        //self.categoryPickerView.curve = "spring"
        //self.categoryPickerView.duration = 0.2
        //self.categoryPickerView.animate()
        UIView.animateWithDuration(0.3) {
            var categoryPickerFrame = self.categoryPickerView.frame
            categoryPickerFrame.origin.y = self.view.frame.height - categoryPickerFrame.height
            self.categoryPickerView.frame = categoryPickerFrame
        }
    }
    
    @IBAction func CategoryPickerTerminate(sender: UIBarButtonItem) {
        UIView.animateWithDuration(0.3) {
            var categoryPickerFrame = self.categoryPickerView.frame
            categoryPickerFrame.origin.y = self.view.frame.height + categoryPickerFrame.height
            self.categoryPickerView.frame = categoryPickerFrame
        }
    }
    
    // MARK: Segue Methods
    
    // Reverse Segue Back to Search Form
    @IBAction func unwindToSearchForm(segue:UIStoryboardSegue) {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "resultsSegue") {
            var resultsViewController = segue.destinationViewController as! ResultsViewController
            
            // Get the search term
            resultsViewController.searchTermText = searchTerm.text
            
            // Get the search type
            resultsViewController.searchType = searchTypeControl.titleForSegmentAtIndex(searchTypeControl.selectedSegmentIndex)!
            if (resultsViewController.searchType == "Question & Answer") {
                resultsViewController.searchType = "AnswerQuestion"
            }
            
            // Get the results type
            resultsViewController.resultsType = questionTypeControl.titleForSegmentAtIndex(questionTypeControl.selectedSegmentIndex)!
            
            // Get the difficulty
            resultsViewController.difficulty = difficultyControl.titleForSegmentAtIndex(difficultyControl.selectedSegmentIndex)!
            
            // Get the category
            resultsViewController.category = categories[categoriesPicker.selectedRowInComponent(0) + 1].asString!
            
            // Get the tournament
            resultsViewController.tournament = "All"
            if tournamentsPicker.selectedRowInComponent(0) != 0 {
                var tournamentYear = tournaments[tournamentsPicker.selectedRowInComponent(0) + 1]["year"].asString!
                var tournamentName = tournaments[tournamentsPicker.selectedRowInComponent(0) + 1]["tournament"].asString!
                resultsViewController.tournament = tournamentName + "," + tournamentYear
            }
            
        }
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
        if pickerView == categoriesPicker {
            return self.categories[0].asInt!
        } else {
            return self.tournaments[0].asInt!
        }

    }
    
    // MARK: Picker Delegate Methods
    
    // Returns data for picker rows
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if pickerView == categoriesPicker {
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
        tournamentsPicker.reloadAllComponents()
        tournamentsPicker.selectRow(0, inComponent: 0, animated: true)
    }
    
    @IBAction func questionTypeControlChanged(sender: UISegmentedControl) {
        loadTournaments(difficulty: difficultyControl.titleForSegmentAtIndex(difficultyControl.selectedSegmentIndex)!, resultsType: sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)!)
        tournamentsPicker.reloadAllComponents()
        tournamentsPicker.selectRow(0, inComponent: 0, animated: true)
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
