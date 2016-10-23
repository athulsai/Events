//
//  RootViewController.swift
//  Events
//
//  Created by Athul Sai on 21/10/16.
//  Copyright © 2016 Athul Sai. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UIPageViewControllerDelegate {

    var pageViewController: UIPageViewController?


    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure the page view controller and add it as a child view controller.
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageViewController!.delegate = self

        let startingViewController: UIViewController = self.modelController.viewControllerAtIndex(0, storyboard: self.storyboard!)!
        let viewControllers = [startingViewController]
        self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: false, completion: {done in })

        self.pageViewController!.dataSource = self.modelController

        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)

        // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
        //var pageViewRect = self.view.bounds
        let pageViewRect = CGRect(x: self.view.bounds.origin.x, y: self.view.bounds.origin.y + 64, width: self.view.frame.width, height: self.view.frame.height - 64)
        self.pageViewController!.view.frame = pageViewRect
        self.pageViewController!.didMove(toParentViewController: self)
    }
    
    var modelController: ModelController {
        // Return the model controller object, creating it if necessary.
        // In more complex implementations, the model controller may be passed to the view controller.
        if _modelController == nil {
            _modelController = ModelController()
        }
        return _modelController!
    }

    var _modelController: ModelController? = nil
    
    // MARK: - UIPageViewController delegate methods

    func pageViewController(_ pageViewController: UIPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
        if (orientation == .portrait) || (orientation == .portraitUpsideDown) || (UIDevice.current.userInterfaceIdiom == .phone) {
 
            let currentViewController = self.pageViewController!.viewControllers![0]
            let viewControllers = [currentViewController]
            self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: true, completion: {done in })

            self.pageViewController!.isDoubleSided = false
            return .min
        }

        let currentViewController = self.pageViewController!.viewControllers![0]
        var viewControllers: [UIViewController]

        let indexOfCurrentViewController = self.modelController.indexOfViewController(currentViewController)
        if (indexOfCurrentViewController == 0) || (indexOfCurrentViewController % 2 == 0) {
            let nextViewController = self.modelController.pageViewController(self.pageViewController!, viewControllerAfter: currentViewController)
            viewControllers = [currentViewController, nextViewController!]
        } else {
            let previousViewController = self.modelController.pageViewController(self.pageViewController!, viewControllerBefore: currentViewController)
            viewControllers = [previousViewController!, currentViewController]
        }
        self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: true, completion: {done in })

        return .mid
    }


}

