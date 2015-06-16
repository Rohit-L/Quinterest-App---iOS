//
//  ViewController.swift
//  Quinterest App
//
//  Created by Rohit Lalchanadani on 6/12/15.
//  Copyright (c) 2015 Laucity. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: Branding Outlets
    @IBOutlet weak var logo: SpringImageView!
    @IBOutlet weak var subtitle: SpringLabel!
    var animationNumber = 0
    
    @IBOutlet weak var searchFormView: SpringView!
    // MARK: User Input Outlets
    @IBOutlet weak var searchTerm: SpringTextField!
    @IBOutlet weak var searchTypeControl: UISegmentedControl!
    @IBOutlet weak var difficultyControl: UISegmentedControl!
    @IBOutlet weak var questionTypeControl: UISegmentedControl!
    @IBOutlet weak var categoryPickerView: UIView!
    @IBOutlet weak var tournamentPickerView: UIView!
    @IBOutlet weak var categoriesPicker: UIPickerView!
    @IBOutlet weak var tournamentsPicker: UIPickerView!
    
    // MARK: Search Form Data
    private var categories: JSON!
    private var tournaments: JSON!
    
    // MARK:-
    // MARK: UIViewController Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Load picker data
        loadCategories()
        loadTournaments(difficulty: "All", resultsType: "All")
        
        // Set tap recognition on logo and subtitle
        var logoTarget = UITapGestureRecognizer(target: self, action: Selector("logoTapped:"))
        logo.addGestureRecognizer(logoTarget)
        
        var formTarget = UITapGestureRecognizer(target: self, action: Selector("formTapped:"))
        searchFormView.addGestureRecognizer(formTarget)
        
        NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: Selector("logoTapped"), userInfo: nil, repeats: true)
                
    }
    
    // MARK:-
    // MARK: Keyboard Methods
    
    // Performs segue to resultsViewController when editing is done if input is valid
    @IBAction func textFieldDoneEditing(sender: SpringTextField) {
        if sender.text == "" {
            
            // Shake animation if text box is empty
            sender.animation = "shake"
            sender.curve = "spring"
            sender.duration = 1.0
            sender.animate()
            sender.placeholder = "You Must Enter a Search Term!"
            
        } else {
            
            // Text box contains valid search term; perform segue
            self.performSegueWithIdentifier("resultsSegue", sender: self)
        }
    }
    
    // Close keyboard if background is tapped while editing
    @IBAction func backgroundPressedWithKeyboard(sender: UIControl) {
        searchTerm.resignFirstResponder()
    }
    
    // Close keyboard if form tapped while editing
    func formTapped(form: AnyObject) {
        searchTerm.resignFirstResponder()
    }
    
    // MARK:-
    // MARK: Animation Methods
    
    // Opens the tournament picker
    @IBAction func TournamentPickerInitiate(sender: UIButton) {
        UIView.animateWithDuration(0.3) {
            var tournamentPickerFrame = self.tournamentPickerView.frame
            tournamentPickerFrame.origin.y = self.view.frame.height - tournamentPickerFrame.height
            self.tournamentPickerView.frame = tournamentPickerFrame
        }
    }
    
    // Closes the tournamnet picker
    @IBAction func TournamentPickerTerminate(sender: UIBarButtonItem) {
        UIView.animateWithDuration(0.3) {
            var tournamentPickerFrame = self.tournamentPickerView.frame
            tournamentPickerFrame.origin.y = self.view.frame.height + tournamentPickerFrame.height
            self.tournamentPickerView.frame = tournamentPickerFrame
        }
    }
    
    // Opens the category picker
    @IBAction func CategoryPickerInitiate(sender: UIButton) {
        UIView.animateWithDuration(0.3) {
            var categoryPickerFrame = self.categoryPickerView.frame
            categoryPickerFrame.origin.y = self.view.frame.height - categoryPickerFrame.height
            self.categoryPickerView.frame = categoryPickerFrame
        }
    }
    
    // Closes the category picker
    @IBAction func CategoryPickerTerminate(sender: UIBarButtonItem) {
        UIView.animateWithDuration(0.3) {
            var categoryPickerFrame = self.categoryPickerView.frame
            categoryPickerFrame.origin.y = self.view.frame.height + categoryPickerFrame.height
            self.categoryPickerView.frame = categoryPickerFrame
        }
    }
    
    // Animates the logo and subtitle when tapped
    func logoTapped(image: AnyObject?) {
        
        // Valid animations for logo / subtitle
        var animationSelection = ["pop", "wobble", "morph", "swing", "zoomIn"]
        
        // Select from valid animation
        var animation = animationSelection[animationNumber % 5]
        animationNumber++
        
        // Animate logo and subtitle
        logo.animation = animation
        subtitle.animation = animation
        logo.curve = "spring"
        subtitle.curve = "spring"
        logo.duration = 2.0
        subtitle.duration = 2.0
        logo.animate()
        subtitle.animate()
    }
    
    func logoTapped() {
        logoTapped(nil)
    }

    // MARK:-
    // MARK: Segue Methods
    
    // Reverse Segue Back to Search Form
    @IBAction func unwindToSearchForm(segue:UIStoryboardSegue) {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    // Send input data to resultsViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "resultsSegue") {
            
            // Gets reference to Results View Controller
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
    
    // MARK:-
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
        if data == nil {
            loadCategories()
            return
        }
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
        if data == nil {
            loadTournaments(difficulty: difficulty, resultsType: resultsType)
            return
        }
        var reply = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
        self.tournaments = JSON(string: reply)
    }
    
}
