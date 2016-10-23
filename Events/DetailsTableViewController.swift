//
//  DetailsTableViewController.swift
//  Events
//
//  Created by Athul Sai on 23/10/16.
//  Copyright © 2016 Athul Sai. All rights reserved.
//

import UIKit
import CoreData

class DetailsTableViewController: UITableViewController {

    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var trackButton: UIButton!
    
    var eventDetails:NSManagedObject?
    let events = DataAccess.sharedAccess.currentUser?.mutableOrderedSetValue(forKey: "tracks")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Details"

        if eventDetails != nil {
            eventImageView.image = UIImage(named:eventDetails?.value(forKey: "image") as! String)
            titleLabel.text = eventDetails?.value(forKey: "title") as! String?
            typeLabel.text = eventDetails?.value(forKey: "type") as! String?
            locationLabel.text = eventDetails?.value(forKey: "location") as! String?
            
            if (events?.contains(eventDetails!))! {
                self.trackButton.isEnabled = false
                self.trackButton.setTitle("✔︎ Followed", for: .normal)
            } else {
                self.trackButton.isEnabled = true
                self.trackButton.setTitle("✔︎ Follow", for: .normal)
            }

        }
    }
    
    @IBAction func trackButtonPressed(_ sender: UIButton) {
        DataAccess.sharedAccess.saveTrackedEvent(event: eventDetails!)
        self.trackButton.isEnabled = false
        self.trackButton.setTitle("✔︎ Followed", for: .normal)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}
