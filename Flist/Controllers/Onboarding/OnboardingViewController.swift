//
//  OnboardingViewController.swift
//  Flist
//
//  Created by Роман Широков on 27.03.18.
//  Copyright © 2018 Flist. All rights reserved.
//

import UIKit

class OnboardingViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    
    lazy var subViewControllers:[UIViewController] = {
        
        return [
            UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "OnboardingOne") as! OnboardingContentViewController,
            UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "OnboardingTwo") as! OnboardingContentViewController,
            UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "OnboardingThree") as! OnboardingContentViewController,
            UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "OnboardingFour") as! OnboardingContentViewController
        ]
        
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        self.dataSource = self
        
        for subViewController in subViewControllers {
            (subViewController as! OnboardingContentViewController).SetPageViewController(pageViewController: self)
        }
        
        setViewControllers([subViewControllers[0]], direction: .forward, animated: true, completion: nil)
    
    }
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subViewControllers.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let curIndex: Int = subViewControllers.index(of: viewController) ?? 0
        
        if (curIndex <= 0) {
            return nil
        }
        
        return subViewControllers[curIndex-1]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let curIndex: Int = subViewControllers.index(of: viewController) ?? 0
        
        if (curIndex >= subViewControllers.count - 1) {
            return nil
        }
        
        return subViewControllers[curIndex+1]
        
    }
    
    public func NextPage() {
        guard let currentViewController = self.viewControllers?.first else { return print("Failed to get current view controller") }
        
        guard let nextViewController = self.dataSource?.pageViewController( self, viewControllerAfter: currentViewController) else { return }
        
        setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        
    }
    
    public func SkipToLast() {
        setViewControllers([subViewControllers.last!], direction: .forward, animated: true, completion: nil)
    }
}
