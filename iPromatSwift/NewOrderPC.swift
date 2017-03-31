//
//  NewOrderPC.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 23.03.17.
//  Copyright © 2017 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit

class NewOrderPC: UIPageViewController {

    var delegateOrder: NewOrderPCDelegate?
    
    var currentIndex: Int = 0
    
    lazy var vcs: [UIViewController] = {
        return [
            //"timeVC", 
            "addressVC",
            "dateVC",
            "commentVC",
            "confirmVC",
            ].flatMap {
            UIStoryboard(name: "NewOrder", bundle: nil) .
                instantiateViewController(withIdentifier: $0)
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        let pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [NewOrderPC.self])
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black

        
        if let vc = vcs.first {
            setViewControllers([vc],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        didNewPage()
        
        if let vc = vcs.last as? NewOrderConfirmVC {
            vc.pc = self
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    func didNewPage () {
        
        guard let vc = self.viewControllers?.last else {
            return
        }

        currentIndex = vcs.index(of: vc)!
        
        if let delegate = delegateOrder {
            delegate.didNewViewController(vc)
        }
     }
    
    func nextPage () {
        
        if currentIndex < vcs.count - 1 {
            currentIndex += 1
            setViewControllers([vcs[currentIndex]], direction: .forward, animated: false, completion: nil)
            
            didNewPage()
        } else {
            if let vc = vcs.last as? NewOrderConfirmVC {
                vc.requestOrder()
            }
        }
    }

}

extension NewOrderPC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let ind = vcs.index(of: viewController) else {
            return nil
        }
        
        let previousInd = ind - 1
        
        guard previousInd >= 0 &&
            vcs.count > previousInd else {
                return nil
        }
        
        return vcs[previousInd]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let ind = vcs.index(of: viewController) else {
            return nil
        }
        
        let nextInd = ind + 1
        
        guard vcs.count > nextInd else {
            return nil
        }
        
        
        return vcs[nextInd]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return vcs.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstVC = viewControllers?.first,
            let firstVCInd = vcs.index(of: firstVC) else {
                return 0
        }
        
        return firstVCInd
    }
    
    
    
}

extension NewOrderPC: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
            didNewPage()
        }
    }
}

protocol NewOrderPCDelegate {
    
    func didNewViewController (_ viewController: UIViewController)
}
