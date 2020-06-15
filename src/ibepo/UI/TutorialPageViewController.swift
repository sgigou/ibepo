//
//  TutorialPageViewController.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-06-15.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit


// MARK: - TutorialPageViewController

class TutorialPageViewController: UIPageViewController {
  
  private var pages = [UIViewController]()
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadPages()
    dataSource = self
    if let firstViewController = pages.first {
      setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
    }
  }
  
  // MARK: Loading
  
  private func loadPages() {
    for pageIndex in 1...2 {
      if let page = storyboard?.instantiateViewController(withIdentifier: "page\(pageIndex)") {
        pages.append(page)
      }
    }
  }
  
}


// MARK: -

extension TutorialPageViewController: UIPageViewControllerDataSource {
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let index = pages.firstIndex(of: viewController) else { return nil }
    if index == 0 { return nil }
    return pages[index - 1]
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let index = pages.firstIndex(of: viewController) else { return nil }
    if index == pages.count - 1 { return nil }
    return pages[index + 1]
  }
  
}
