//
//  LearnStrategyCoordinator.swift
//  QOT
//
//  Created by tignum on 3/30/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol LearnStrategyCoordinatorDelegate: ParentCoordinator {}

final class LearnStrategyCoordinator: ParentCoordinator {
    fileprivate let rootVC: LearnContentListViewController
    fileprivate let databaseManager: DatabaseManager
    fileprivate let eventTracker: EventTracker
    fileprivate let category: ContentCategory
    
    var children: [Coordinator] = []
    weak var delegate: LearnContentListCoordinatorDelegate?
    
    init(root: LearnContentListViewController, databaseManager: DatabaseManager, eventTracker: EventTracker, category: ContentCategory) {
        self.rootVC = root
        self.databaseManager = databaseManager
        self.eventTracker = eventTracker
        self.category = category
    }
    
    func start() {
        let viewModel = LearnStrategyViewModel()
        let vc = LearnStrategyViewController(viewModel: viewModel)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .custom
        vc.delegate =  self
        rootVC.present(vc, animated: true)
        
        // FIXME: Add page tracking
    }
}

extension LearnStrategyCoordinator: LearnContentListViewControllerDelegate {
    func didSelectContent(at index: Index, in viewController: LearnContentListViewController) {
        log("Did select content at index: \(index)")
    }
    
    func didTapBack(in: LearnContentListViewController) {
        rootVC.dismiss(animated: true)
        delegate?.removeChild(child: self)
    }
}

extension LearnStrategyCoordinator: LearnStrategyViewControllerDelegate {
    func didTapClose(in viewController: LearnStrategyViewController) {
        rootVC.dismiss(animated: true, completion: nil)
        delegate?.removeChild(child: self)
    }
    
    func didTapShare(in viewController: LearnStrategyViewController) {
        log("did tap share")
    }
    
    func didTapVideo(with video: LearnStrategyItem, from view: UIView, in viewController: LearnStrategyViewController) {
        log("did tap video: \(video)")
    }
    
    func didTapArticle(with article: LearnStrategyItem, from view: UIView, in viewController: LearnStrategyViewController) {
        log("did tap article: \(article)")
    }
}
