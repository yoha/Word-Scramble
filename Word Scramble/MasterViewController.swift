//
//  MasterViewController.swift
//  Word Scramble
//
//  Created by Yohannes Wijaya on 8/10/15.
//  Copyright © 2015 Yohannes Wijaya. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var userAnswers = [String]()
    var allIndividualWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "promptForAnswer")
        if let startWordsPath = NSBundle.mainBundle().pathForResource("start", ofType: "txt") {
            do {
                let startWords =  try NSString(contentsOfFile: startWordsPath, usedEncoding: nil)
                self.allIndividualWords = startWords.componentsSeparatedByString("\n") ?? ["silkworm"]
            }
            catch {}
        }
        self.startGame()
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userAnswers.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let userAnswer = self.userAnswers[indexPath.row]
        cell.textLabel!.text = userAnswer
        return cell
    }
    
    // MARK: - Local Methods
    
    func startGame() {
        self.allIndividualWords.shuffle()
        self.title = self.allIndividualWords[0]
        self.userAnswers.removeAll(keepCapacity: true)
        self.tableView.reloadData()
    }
    
    func promptForAnswer() {
        let alertController = UIAlertController(title: "Enter answer...", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addTextFieldWithConfigurationHandler(nil)
        let submitAlertAction = UIAlertAction(title: "Submit", style: UIAlertActionStyle.Default) { [unowned self, alertController] (_) -> Void in
            let answer = alertController.textFields![0]
            self.submitAnswer(answer.text!)
        }
        alertController.addAction(submitAlertAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func submitAnswer(answer: String) {
        let lowercaseAnswer = answer.lowercaseString
        if wordIsASubsetOfMaster(lowercaseAnswer) {
            if wordIsFirstUsed(lowercaseAnswer) {
                if wordIsValid(lowercaseAnswer) {
                    if wordIsTooShort(lowercaseAnswer) {
                        self.userAnswers.insert(lowercaseAnswer, atIndex: 0)
                        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                    }
                    else {
                        self.showErrorMessage("That word is too short", errorMessage: "3 or more characters only!")
                    }
                }
                else {
                    self.showErrorMessage("That word is not recognized.", errorMessage: "Don't try to fool me. :)")
                }
            }
            else {
                self.showErrorMessage("That word has been used.", errorMessage: "Be more original! :)")
            }
        }
        else {
            self.showErrorMessage("That word is not possible", errorMessage: "You can't spell that word from \(self.title!.lowercaseString)!")
        }
    }
    
    func wordIsASubsetOfMaster(answer: String) -> Bool {
        var tempMasterWord = self.title!.lowercaseString
        for eachLetter in answer.characters {
            if let letterPosition = tempMasterWord.rangeOfString(String(eachLetter)) {
                if letterPosition.isEmpty { return false }
                else { tempMasterWord.removeAtIndex(letterPosition.startIndex) }
            }
            else { return false }
        }
        return true
    }
    
    func wordIsFirstUsed(answer: String) -> Bool {
        return !self.userAnswers.contains(answer)
    }
    
    func wordIsValid(answer: NSString) -> Bool {
        let wordChecker = UITextChecker()
        let wordRange = NSMakeRange(0, answer.length)
        let misspelledRange = wordChecker.rangeOfMisspelledWordInString(String(answer), range: wordRange, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func wordIsTooShort(answer: NSString) -> Bool {
        return answer.length >=  3
    }
    
    func showErrorMessage(errorTitle: String, errorMessage: String) {
        let alertController = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}

