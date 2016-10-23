//
//  ModelController.swift
//  Events
//
//  Created by Athul Sai on 21/10/16.
//  Copyright © 2016 Athul Sai. All rights reserved.
//

import UIKit
import CoreData

class ModelController: NSObject, UIPageViewControllerDataSource {

    let pageData: [String] = ["Events","Followed"]

    override init() {
        super.init()
        // Insert sample data to local storage
        let defaults = UserDefaults.standard
        if (defaults.object(forKey: "firstRun") == nil) {
            defaults.set(Date(), forKey: "firstRun")
            DataAccess.sharedAccess.insertEventListToStorage()
            DataAccess.sharedAccess.fetchEventsList()
        } else {
            DataAccess.sharedAccess.fetchEventsList()
        }
    }
    
    func viewControllerAtIndex(_ index: Int, storyboard: UIStoryboard) -> UIViewController? {
        // Return the data view controller for the given index.
        if (self.pageData.count == 0) || (index >= self.pageData.count) {
            return nil
        }

        // Create a new view controller and pass suitable data.
        if index == 0 {
            let dataViewController = storyboard.instantiateViewController(withIdentifier: "DataViewController") as! DataViewController
            dataViewController.titleObject = self.pageData[index]
            dataViewController.events = DataAccess.sharedAccess.events!
            return dataViewController
        } else if index == 1 {
            let listViewController = storyboard.instantiateViewController(withIdentifier: "TrackedListViewController") as! TrackedListViewController
            listViewController.titleObject = self.pageData[index]
            return listViewController
        } else {
            return nil
        }
    }

    func indexOfViewController(_ viewController: UIViewController) -> Int {
        if viewController is DataViewController {
            return pageData.index(of: (viewController as! DataViewController).titleObject) ?? NSNotFound
        } else {
            return pageData.index(of: (viewController as! TrackedListViewController).titleObject) ?? NSNotFound
        }
    }

    // MARK: - Page View Controller Data Source

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController)
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        if index == self.pageData.count {
            return nil
        }
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }

}

