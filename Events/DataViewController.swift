//
//  DataViewController.swift
//  Events
//
//  Created by Athul Sai on 21/10/16.
//  Copyright © 2016 Athul Sai. All rights reserved.
//

import UIKit
import CoreData

class DataViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layoutSwitchControl: UISegmentedControl!
    
    var titleObject: String = ""
    var events: [NSManagedObject] = []
    var isGridFlowLayoutUsed: Bool = false
    let gridFlowLayout = EventsGridFlowLayout()
    let listFlowLayout = EventsListFlowLayout()
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        collectionView.reloadData()
        setupInitialLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titleLabel!.text = titleObject
    }
    
    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    //MARK: - Utilities
    func registerCells() {
        self.collectionView.register(UINib.init(nibName: "ListCell", bundle: nil), forCellWithReuseIdentifier: "ListCell")
        self.collectionView.register(UINib.init(nibName: "GridCell", bundle: nil), forCellWithReuseIdentifier: "GridCell")
    }
    
    func setupInitialLayout() {
        isGridFlowLayoutUsed = false
        collectionView.collectionViewLayout = listFlowLayout
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let detailsViewController = segue.destination as! DetailsTableViewController
            //let indexPath = sender as! NSIndexPath
            let indexPath: IndexPath = (self.collectionView.indexPathsForSelectedItems!.first! as NSIndexPath) as IndexPath
            let selectedRow: NSManagedObject = events[indexPath.row] 
            detailsViewController.eventDetails = selectedRow 
        }
    }
    
    @IBAction func layoutSwitchPressed(_ sender: UISegmentedControl) {
        if layoutSwitchControl.selectedSegmentIndex == 0 {
            isGridFlowLayoutUsed = false
            self.collectionView?.reloadData()
            collectionView?.performBatchUpdates({
                
            }) { completed in
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.setCollectionViewLayout(self.listFlowLayout, animated: true)
            }
        } else {
            isGridFlowLayoutUsed = true
            self.collectionView?.reloadData()
            collectionView?.performBatchUpdates({
               
            }) { completed in
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.setCollectionViewLayout(self.gridFlowLayout, animated: true)
            }
        }
    }
}

//MARK: - Collection view data source & delegate
extension DataViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if isGridFlowLayoutUsed {
            let gridCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as! GridCell
            let itemToDisplay = events[indexPath.row]
            gridCell.thumbnailImage.image = UIImage(named:itemToDisplay.value(forKey: "image") as! String)
            gridCell.titleLabel.text = itemToDisplay.value(forKey: "title") as! String?
            return gridCell
        } else {
            let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as! ListCell
            let itemToDisplay = events[indexPath.row]
            listCell.thumbnailImage.image = UIImage(named:itemToDisplay.value(forKey: "image") as! String)
            listCell.titleLabel.text = itemToDisplay.value(forKey: "title") as! String?
            listCell.entryLabel.text = itemToDisplay.value(forKey: "type") as! String?
            listCell.placeLabel.text = itemToDisplay.value(forKey: "location") as! String?
            return listCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }

}

extension DataViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: self)
    }
}

