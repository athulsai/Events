//
//  TrackedListViewController.swift
//  Events
//
//  Created by Athul Sai on 23/10/16.
//  Copyright © 2016 Athul Sai. All rights reserved.
//

import UIKit
import CoreData

class TrackedListViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var titleObject: String = ""
    let events = DataAccess.sharedAccess.currentUser?.mutableOrderedSetValue(forKey: "tracks")
    
    //MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupEmptyBackgroundView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titleLabel!.text = titleObject
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let indexPath = self.tableView.indexPathForSelectedRow
        if indexPath != nil {
            self.tableView.deselectRow(at: indexPath!, animated: true)
        }
    }
    
    //MARK: - Utilities
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEventDetails" {
            let detailsViewController = segue.destination as! DetailsTableViewController
            //let indexPath = sender as! NSIndexPath
            let indexPath: IndexPath = self.tableView.indexPathForSelectedRow!
            let selectedRow: NSManagedObject = events?.object(at: indexPath.row) as! NSManagedObject
            detailsViewController.eventDetails = selectedRow
        }
    }
    
    func setupEmptyBackgroundView() {
        let emptyBackgroundView = UIView(frame: CGRect(x: -40, y: (self.view.frame.height/2)-100, width: self.view.frame.size.width, height: 40))
        let emptyLabel = UILabel(frame: emptyBackgroundView.frame)
        emptyLabel.text = "Your followed events will be shown here..."
        emptyLabel.textAlignment = .center
        emptyLabel.font = UIFont.systemFont(ofSize: 22.0)
        emptyBackgroundView.addSubview(emptyLabel)
        tableView.backgroundView = emptyBackgroundView
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }

    @IBAction func editButtonPressed(_ sender: UIButton) {
        tableView.isEditing = !tableView.isEditing
    }
}

//MARK: - Table view data source and delegates
extension TrackedListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (events?.count)! == 0 {
            tableView.separatorStyle = .none
            tableView.backgroundView?.isHidden = false
            return 0
        } else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView?.isHidden = true
            return (events?.count)!
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TrackedListCell = self.tableView.dequeueReusableCell(withIdentifier: "Cell") as! TrackedListCell
        let itemToDisplay:NSManagedObject = events?.object(at: indexPath.row) as! NSManagedObject
        cell.eventImageView.image = UIImage(named:itemToDisplay.value(forKey: "image") as! String)
        cell.titleLabel.text = itemToDisplay.value(forKey: "title") as! String?
        cell.entryLabel.text = itemToDisplay.value(forKey: "type") as! String?
        cell.placeLabel.text = itemToDisplay.value(forKey: "location") as! String?
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = events?.object(at: sourceIndexPath.row) as! NSManagedObject
        events?.removeObject(at: sourceIndexPath.row)
        events?.insert(itemToMove, at: destinationIndexPath.row)
        DataAccess.sharedAccess.coreDataHelper.saveContext()
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            events?.removeObject(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            DataAccess.sharedAccess.coreDataHelper.saveContext()
        }
    }
    
}

extension TrackedListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showEventDetails", sender: self)
    }
}
