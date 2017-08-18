//
//  LearnContentItemCoordinator.swift
//  QOT
//
//  Created by tignum on 3/30/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import RealmSwift
import SafariServices

final class LearnContentItemCoordinator: ParentCoordinator {
    
    let rootVC: UIViewController
    fileprivate let services: Services
    fileprivate let category: ContentCategory
    fileprivate var categoryTitle: String
    fileprivate var selectedContent: ContentCollection
    fileprivate let fullViewController: LearnContentItemViewController
    fileprivate let bulletViewController: LearnContentItemViewController
    fileprivate let audioViewController: LearnContentItemViewController
    fileprivate var viewModel: LearnContentItemViewModel
    fileprivate var presentationManager: CircularPresentationManager?
    fileprivate weak var topBarDelegate: TopNavigationBarDelegate?
    var children: [Coordinator] = []
    var topTabBarController: UINavigationController!

    init(root: UIViewController, services: Services, content: ContentCollection, category: ContentCategory, presentationManager: CircularPresentationManager? = nil, topBarDelegate: TopNavigationBarDelegate? = nil) {
        self.rootVC = root
        self.services = services
        self.category = category
        self.categoryTitle = category.title.capitalized
        self.presentationManager = presentationManager
        self.selectedContent = content
        self.topBarDelegate = topBarDelegate
        self.viewModel = LearnContentItemViewModel(
            services: services,
            contentCollection: selectedContent,
            categoryID: category.forcedRemoteID
        )
        
        let headerView = LearnContentItemHeaderView.fromXib(contentTitle: selectedContent.title.capitalized, categoryTitle: categoryTitle.capitalized)

        fullViewController = LearnContentItemViewController(
            viewModel: viewModel,
            tabType: .full
        )
        fullViewController.title = R.string.localized.learnContentItemTitleFull()
        
        bulletViewController = LearnContentItemViewController(
            viewModel: viewModel,
            tabType: .bullets
        )
        bulletViewController.title = R.string.localized.learnContentItemTitleBullets()
        
        audioViewController = LearnContentItemViewController(
            viewModel: viewModel,
            tabType: .audio
        )
        audioViewController.title = R.string.localized.learnContentItemTitleAudio()
        
        let leftButton = UIBarButtonItem(withImage: R.image.ic_minimize())
        topTabBarController = UINavigationController(withPages: [fullViewController, bulletViewController, audioViewController], headerView: headerView, topBarDelegate: topBarDelegate ?? self, pageDelegate: self, backgroundColor: .white, backgroundImage: nil, leftButton: leftButton)
        if let navigationBar = topTabBarController.navigationBar as? TopNavigationBar {
            navigationBar.setStyle(tintColor: .black70, backgroundColor: .white)
        }
        
        fullViewController.delegate = self
        bulletViewController.delegate = self
        audioViewController.delegate = self
    }

    func start() {
        if rootVC is UIViewControllerTransitioningDelegate {
            topTabBarController.modalPresentationStyle = .fullScreen  // Custom animations doesn't work when this value is set to .custom

            // If rootVC has a custom defined transition that one will be used
            // We have a custom transition from PrepareContent (when pressing readMore button)
            guard let transitionDelegate = rootVC as? UIViewControllerTransitioningDelegate else { return }
            topTabBarController.transitioningDelegate = transitionDelegate
        } else if let presentationManager = presentationManager {
            topTabBarController.transitioningDelegate = presentationManager
        } else {
            topTabBarController.modalPresentationStyle = .custom
        }

        rootVC.present(topTabBarController, animated: true)
        // FIXME: Add page tracking
    }
}

// MARK: - TopNavigationBarDelegate

extension LearnContentItemCoordinator: TopNavigationBarDelegate {

    func topNavigationBar(_ navigationBar: TopNavigationBar, leftButtonPressed button: UIBarButtonItem) {
        topTabBarController.dismiss(animated: true) { 
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }
    
    func topNavigationBar(_ navigationBar: TopNavigationBar, middleButtonPressed button: UIButton, withIndex index: Int, ofTotal total: Int) {
        guard let pageViewController = topTabBarController.viewControllers.first as? PageViewController else {
            return
        }
        pageViewController.setPageIndex(index, animated: true)
    }
    
    func topNavigationBar(_ navigationBar: TopNavigationBar, rightButtonPressed button: UIBarButtonItem) {
        print("did select book mark")
    }
}

// MARK: - LearnContentItemViewControllerDelegate

extension LearnContentItemCoordinator: LearnContentItemViewControllerDelegate {

    func didTapFinish(from view: UIView) {
        print("didTapFinish")
    }

    func didTapShare(in viewController: LearnContentItemViewController) {
        print("didTapShare")
    }

    func didSelectReadMoreContentCollection(with collectionID: Int, in viewController: LearnContentItemViewController) {
        guard let contentCollection = services.contentService.contentCollection(id: collectionID) else {
            return
        }

        selectedContent = contentCollection
        viewModel = LearnContentItemViewModel(
            services: services,
            contentCollection: selectedContent,
            categoryID: category.forcedRemoteID
        )
        // TODO: this
        //topTabBarControllerDelegate?.updateHeaderView(title: categoryTitle, subTitle: selectedContent.title)
        fullViewController.reloadData(viewModel: viewModel)
        bulletViewController.reloadData(viewModel: viewModel)
        audioViewController.reloadData(viewModel: viewModel)
    }

    func didTapVideo(with video: ContentItem, from view: UIView, in viewController: LearnContentItemViewController) {
        print("didTapVideo")
    }

    func didTapArticle(with article: ContentItem, from view: UIView, in viewController: LearnContentItemViewController) {
        print("didTapArticle")
    }

    func didTapPDF(withURL url: URL, in viewController: LearnContentItemViewController) {

        // SFSafariViewController will crash if url doesn't hae one of these schemes
        guard ["http", "https"].contains(url.scheme?.lowercased() ?? "") else { return }

        let webViewController = SFSafariViewController(url: url)

        viewController.present(webViewController, animated: true, completion: nil)
    }
}

// MARK: - PageViewControllerDelegate

extension LearnContentItemCoordinator: PageViewControllerDelegate {

    func pageViewController(_ controller: UIPageViewController, didSelectPageIndex index: Int) {
        guard let navigationController = controller.navigationController, let topNavigationBar = navigationController.navigationBar as? TopNavigationBar else {
            return
        }
        topNavigationBar.setIndicatorToButtonIndex(index)
    }
}
