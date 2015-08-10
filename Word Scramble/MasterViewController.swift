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

}

