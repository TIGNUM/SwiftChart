//
//  TabPageController.swift
//  QOT
//
//  Created by Lee Arromba on 27/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

enum PageDirection {
    case forward
    case backward
}

protocol PageViewControllerNotSwipeable {}

protocol PageViewControllerDelegate: class {

    func pageViewController(_ controller: UIPageViewController, didSelectPageIndex index: Int)
}

protocol PageScroll: class {

    func pageDidLoad(_ controller: UIViewController, scrollView: UIScrollView)

    func pageDidScroll(_ controller: UIViewController, scrollView: UIScrollView)
}

protocol PageScrollView: class {

    func scrollView() -> UIScrollView
}

final class PageViewController: UIPageViewController {

    private(set) var data: [UIViewController]?
    private(set) var currentPageIndex: Int
    private(set) var backgroundImageView: UIImageView
    private var headerView: UIView?
    private var headerViewTopConstraint: NSLayoutConstraint?
    private var direction: UIPageViewControllerNavigationDirection
    private var isPaging: Bool
    private let navItem: NavigationItem
    weak var pageDelegate: PageViewControllerDelegate?

    override var navigationItem: UINavigationItem {
        return navItem
    }

    var currentPage: UIViewController? {
        guard let data = data, currentPageIndex >= data.startIndex, currentPageIndex < data.endIndex else {
            return nil
        }
        return data[currentPageIndex]
    }

    init(headerView: UIView?,
         backgroundImage: UIImage?,
         pageDelegate: PageViewControllerDelegate?,
         transitionStyle style: UIPageViewControllerTransitionStyle,
         navigationOrientation: UIPageViewControllerNavigationOrientation,
         options: [String: Any]? = nil,
         navigationItem: NavigationItem) {
        self.headerView = headerView
        self.backgroundImageView = UIImageView(image: backgroundImage)
        self.pageDelegate = pageDelegate
        self.currentPageIndex = 0
        self.direction = .forward
        self.isPaging = false
        self.navItem = navigationItem
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
        delegate = self
        dataSource = self

        if let headerView = headerView {
            // @warning moved here instead of viewDidLoad - in iOS11, the first page loads before PageViewController viewDidLoad called, which causes `pageDidLoad(_ controller: UIViewController, scrollView: UIScrollView)` to be executed before `headerView` is laid out, messing up the top inset calculation. Perhaps here is the best place to accomodate the edge case, but it feels somewhat unsafe to add constraints before the view has loaded
            edgesForExtendedLayout = []
            view.addSubview(headerView)
            headerViewTopConstraint = NSLayoutConstraint(
                item: headerView,
                attribute: .top,
                relatedBy: .equal,
                toItem: view,
                attribute: .top,
                multiplier: 1.0,
                constant: 0.0
            )
            view.addConstraint(headerViewTopConstraint!)
            headerView.leftAnchor == view.leftAnchor
            headerView.rightAnchor == (view.rightAnchor - 10.0)
            headerView.layoutIfNeeded()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImageView)
        view.sendSubview(toBack: backgroundImageView)
        backgroundImageView.verticalAnchors == view.verticalAnchors
        backgroundImageView.horizontalAnchors == view.horizontalAnchors
        backgroundImageView.isHidden = (backgroundImageView.image == nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        childViewControllers.forEach { (childViewController: UIViewController) in
            if childViewController is PageViewControllerNotSwipeable {
                dataSource = nil
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setPages(_ viewControllers: [UIViewController]) {
        data = viewControllers
    }

    func setPageIndex(_ pageIndex: Int, animated: Bool) {
        guard let data = data, pageIndex >= data.startIndex, pageIndex < data.endIndex else { return }
        let page = data[pageIndex]
        setViewControllers([page], direction: (pageIndex < currentPageIndex) ? .reverse : .forward, animated: animated, completion: nil)
        currentPageIndex = pageIndex
    }

    // MARK: - private

    private func setHeaderY(_ yPos: CGFloat, animated: Bool) {
        guard let headerView = headerView, let headerViewTopConstraint = headerViewTopConstraint else {
            return
        }
        headerViewTopConstraint.constant = yPos
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            headerView.layoutIfNeeded()
        }
    }
}

// MARK: - UIPageViewControllerDelegate

extension PageViewController: UIPageViewControllerDelegate {

    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        isPaging = true
        guard let viewController = pendingViewControllers.first, let nextIndex = data?.index(of: viewController) else {
            return
        }
        direction = (currentPageIndex < nextIndex) ? .forward : .reverse
    }

    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        isPaging = false

        guard finished, completed, let viewController = previousViewControllers.first, let index = data?.index(of: viewController) else {
            return
        }

        currentPageIndex = (direction == .forward) ? index + 1 : index - 1
        pageDelegate?.pageViewController(self, didSelectPageIndex: currentPageIndex)

        if let scrollableViewController = currentPage as? PageScrollView {
            setHeaderY(scrollableViewController.scrollView().normalized, animated: true)
        }
    }
}

// MARK: - UIPageViewControllerDataSource

extension PageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let data = data, let index = data.index(of: viewController), index - 1 >= data.startIndex else {
            return nil
        }

        return data[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let data = data, let index = data.index(of: viewController), index + 1 < data.endIndex else {
            return nil
        }

        return data[index + 1]
    }
}

// MARK: - PageScroll

extension PageViewController: PageScroll {

    func pageDidLoad(_ controller: UIViewController, scrollView: UIScrollView) {
        guard let headerView = headerView else { return }
        scrollView.contentInset = UIEdgeInsets(
            top: headerView.bounds.size.height,
            left: scrollView.contentInset.left,
            bottom: scrollView.contentInset.bottom,
            right: scrollView.contentInset.right
        )
    }

    func pageDidScroll(_ controller: UIViewController, scrollView: UIScrollView) {
        guard isPaging == false else { return }
        setHeaderY(scrollView.normalized, animated: false)
    }
}

// MARK: - UIScrollView helper

private extension UIScrollView {

    var normalized: CGFloat {
        return -(self.contentInset.top + self.contentOffset.y)
    }
}
