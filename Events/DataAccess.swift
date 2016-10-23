//
//  DataAccess.swift
//  Events
//
//  Created by Athul Sai on 23/10/16.
//  Copyright © 2016 Athul Sai. All rights reserved.
//
//  Core Data access manager

import CoreData

class DataAccess: NSObject {
    
    var currentUser: NSManagedObject?
    var events: [NSManagedObject]?
    lazy var coreDataHelper = CoreDataHelper()

    //Singleton Class
    static let sharedAccess = DataAccess()
    
    func fetchEventsList() {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Event")
        do {
            let results =
                try coreDataHelper.managedObjectContext.fetch(fetchRequest)
            events = results as? [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    func fetchUserData(name:String) {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "User")
        let predicate:NSPredicate = NSPredicate(format: "name == %@", name.lowercased())
        fetchRequest.predicate = predicate
        do {
            let results =
                try coreDataHelper.managedObjectContext.fetch(fetchRequest)
            currentUser = (results as! [NSManagedObject]).first
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func saveUserData(name:String) {
        let entity = NSEntityDescription.entity(forEntityName: "User", in: coreDataHelper.managedObjectContext)
        let user = NSManagedObject(entity: entity!, insertInto:coreDataHelper.managedObjectContext)
        user.setValue(name, forKey: "name")
        do {
            try coreDataHelper.managedObjectContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }

    }
    
    func saveTrackedEvent(event:NSManagedObject) {
        let tracks = self.currentUser?.mutableOrderedSetValue(forKey: "tracks")
        tracks?.add(event)
        do {
            try coreDataHelper.managedObjectContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }

    }
    
    //MARK: - Populate local storage with sample data
    func insertEventListToStorage() {
        let eventList = getValuesInPlistFile()
        if eventList != nil {
            for element in eventList! {
                let listItem = element as! NSDictionary
                let entity = NSEntityDescription.entity(forEntityName: "Event", in: coreDataHelper.managedObjectContext)
                let event = NSManagedObject(entity: entity!, insertInto:coreDataHelper.managedObjectContext)
                event.setValue(listItem["title"], forKey: "title")
                event.setValue(listItem["location"], forKey: "location")
                event.setValue(listItem["image"], forKey: "image")
                event.setValue(listItem["type"], forKey: "type")
                
                do {
                    try coreDataHelper.managedObjectContext.save()
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    func getValuesInPlistFile() -> NSArray? {
        let destPath = Bundle.main.path(forResource: "Events", ofType: "plist")
        if destPath != nil {
            let list = NSArray(contentsOfFile: destPath!)
            return list
        } else {
            return .none
        }
    }


}
