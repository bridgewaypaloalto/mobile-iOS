//
//  DailybiblePageViewController.swift
//  bcsv.org
//
//  Created by admin on 8/7/19.
//  Copyright © 2019 Haksoo Kim. All rights reserved.
//

import UIKit

class DailybiblePageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    lazy var orderedViewControllers: [UIViewController] = {
        return [self.newVC(viewController: "SB_dailyBible1")]
        
        //SB_dailyBible2 is intentionally blocked due to license issue with SU.OR.KR
//        return [self.newVC(viewController: "SB_dailyBible1"),
//                self.newVC(viewController: "SB_dailyBible2")]
    }()
    
    var pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        if let firstViewController = orderedViewControllers.first{
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        self.delegate = self
        configurePageControl()
        // Do any additional setup after loading the view.
    }
    
    func configurePageControl(){
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 50, width: UIScreen.main.bounds.width, height: 50))
        
        pageControl.numberOfPages = orderedViewControllers.count
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.white
        self.view.addSubview(pageControl)
    }
    
    func newVC(viewController: String) -> UIViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController)
            else{
                return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else{
            //If infinite swipe is desired, reutrn orderedViewControllers.last.
            //Otherwise, return nil
            //return orderedViewControllers.last
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else{
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController)
            else{
                return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard orderedViewControllers.count != nextIndex else{
            //If infinite swipe is desired, reutrn orderedViewControllers.first.
            //Otherwise, return nil
            //return orderedViewControllers.first
            return nil
        }
        
        guard orderedViewControllers.count > nextIndex else{
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.firstIndex(of:pageContentViewController)!
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}
