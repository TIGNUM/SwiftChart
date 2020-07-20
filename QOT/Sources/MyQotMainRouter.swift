//
//  MyQotMainRouter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyQotMainRouter: BaseRouter {

    // MARK: - Properties
    private weak var myQotViewController: MyQotMainViewController?
    weak var delegate: CoachCollectionViewControllerDelegate?

    // MARK: - Init
    init(viewController: MyQotMainViewController, delegate: CoachCollectionViewControllerDelegate) {
        super.init(viewController: viewController)
        self.myQotViewController = viewController
        self.delegate = delegate
    }
}

// MARK: - MyQotMainRouterInterface
extension MyQotMainRouter: MyQotMainRouterInterface {

    func presentMyPreps() {
        let storyboardID = R.storyboard.myPreps.myPrepsViewControllerID.identifier
        let myPrepsViewController = R.storyboard
            .myPreps().instantiateViewController(withIdentifier: storyboardID) as? MyPrepsViewController
        if let myPrepsViewController = myPrepsViewController {
            MyPrepsConfigurator.configure(viewController: myPrepsViewController, delegate: delegate)
            viewController?.pushToStart(childViewController: myPrepsViewController)
        }
    }

    func presentMyProfile() {
        let storyboardID = R.storyboard.myQot.myQotProfileID.identifier
        let myQotProfileViewController = R.storyboard
            .myQot().instantiateViewController(withIdentifier: storyboardID) as? MyQotProfileViewController
        if let myQotProfileViewController = myQotProfileViewController {
            MyQotProfileConfigurator.configure(delegate: delegate, viewController: myQotProfileViewController)
            viewController?.pushToStart(childViewController: myQotProfileViewController)
        }
    }

    func presentMySprints() {
        guard let mySprintsController = R.storyboard.mySprints.mySprintsListViewController() else {
            return
        }
        let configurator = MySprintsListConfigurator.make()
        configurator(mySprintsController)
        viewController?.pushToStart(childViewController: mySprintsController)
    }

    func presentMyLibrary() {
        let storyboardId = R.storyboard.myLibrary.myLibraryCategoryListViewController.identifier
        let myLibraryController = R.storyboard.myLibrary()
            .instantiateViewController(withIdentifier: storyboardId) as? MyLibraryCategoryListViewController
        if let myLibraryController = myLibraryController {
            let configurator = MyLibraryCategoryListConfigurator.make(with: nil)
            configurator(myLibraryController)
            viewController?.pushToStart(childViewController: myLibraryController)
        }
    }

    func presentMyDataScreen() {
        let storyboardID = R.storyboard.myDataScreen.myDataScreenViewControllerID.identifier
        let myDataScreenViewController = R.storyboard
            .myDataScreen().instantiateViewController(withIdentifier: storyboardID) as? MyDataScreenViewController
        if let myDataScreenViewController = myDataScreenViewController {
            let configurator = MyDataScreenConfigurator.make()
            configurator(myDataScreenViewController)
            viewController?.pushToStart(childViewController: myDataScreenViewController)
        }
    }

    func presentEditTeam(_ type: TeamEdit.View, team: QDMTeam?) {
        let identifier = R.storyboard.team.teamEditViewControllerID.identifier
        let controller = R.storyboard.team().instantiateViewController(withIdentifier: identifier) as? TeamEditViewController
        if let controller = controller {
            let configurator = TeamEditConfigurator.make(type: type, team: team)
            configurator(controller)
            viewController?.present(controller, animated: true)
        }
    }

    func presentTeamPendingInvites() {
        let identifier = R.storyboard.team.teamInviteViewControllerID.identifier
        let controller = R.storyboard.team().instantiateViewController(withIdentifier: identifier) as? TeamInvitesViewController
        if let controller = controller {
            let configurator = TeamInvitesConfigurator.make()
            configurator(controller)
            viewController?.pushToStart(childViewController: controller)
        }
    }
}
