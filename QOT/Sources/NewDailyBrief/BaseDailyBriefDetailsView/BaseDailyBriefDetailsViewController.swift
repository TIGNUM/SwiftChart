//
//  BaseDailyBriefDetailsViewController.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 09/11/2020.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class BaseDailyBriefDetailsViewController: BaseViewController, ScreenZLevel3 {

    // MARK: - Properties
    var interactor: BaseDailyBriefDetailsInteractorInterface!
    private lazy var router: BaseDailyBriefDetailsRouterInterface = BaseDailyBriefDetailsRouter(viewController: self)
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Init
    init(configure: Configurator<BaseDailyBriefDetailsViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshBottomNavigationItems()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ThemeView.level1.apply(self.view)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerDequeueable(NewBaseDailyBriefCell.self)
        tableView.registerDequeueable(ImpactReadiness5DaysRollingTableViewCell.self)
        tableView.insetsContentViewsToSafeArea = false
        interactor.viewDidLoad()
    }

    override func didTapBackButton() {
        self.dismiss(animated: true, completion: nil)
    }

    override var statusBarAnimatableConfig: StatusBarAnimatableConfig {
        return StatusBarAnimatableConfig(prefersHidden: true,
                                         animation: .slide)
    }
}

// MARK: - Private
private extension BaseDailyBriefDetailsViewController {

}

// MARK: - Actions
private extension BaseDailyBriefDetailsViewController {

}

// MARK: - BaseDailyBriefDetailsViewControllerInterface
extension BaseDailyBriefDetailsViewController: BaseDailyBriefDetailsViewControllerInterface {
    func setupView() {
        // Do any additional setup after loading the view.
    }

    func reloadTableView() {
        tableView.reloadData()
    }

    func showAlert(message: String?) {
        let closeButtonItem = createCloseButton(#selector(dismissAlert))
        QOTAlert.show(title: nil, message: message, bottomItems: [closeButtonItem])
    }

    @objc func dismissAlert() {
        QOTAlert.dismiss()
    }

    func presentMyDataScreen() {
        router.showMyDataScreen()
    }

    func showCustomizeTarget() {
        interactor.customizeSleepQuestion { [weak self] (question) in
            self?.router.presentCustomizeTarget(question)
        }
    }

    func showTBV() {
        router.showTBV()
    }

    func presentMindsetResults(for mindsetShifter: QDMMindsetShifter?) {
        router.presentMindsetResults(for: mindsetShifter)
    }

    func presentPrepareResults(for preparation: QDMUserPreparation?) {
        router.presentPrepareResults(for: preparation)
    }

    func saveAnswerValue(_ value: Int, from cell: UITableViewCell) {
        interactor.saveAnswerValue(value)
    }

    func didUpdateLevel5(with model: Level5ViewModel) {
        interactor.updateModel(model)
        tableView.beginUpdates()
        tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .fade)
        tableView.endUpdates()
    }

    func didUpdateImpactReadiness(with model: ImpactReadinessCellViewModel) {
        if interactor.getModel() as? ImpactReadinessCellViewModel != nil {
            interactor.updateModel(model)
            tableView.reloadData()
        }
    }

    func presentStrategyList(strategyID: Int?) {
        if let contentId = strategyID {
            router.presentContent(contentId)
        }
    }

    func openTools(toolID: Int?) {
        if let contentId = toolID {
            router.presentContent(contentId)
        }
    }
}

// MARK: - BaseDailyBriefDetailsViewControllerInterface
extension BaseDailyBriefDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.getNumberOfRows() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return interactor?.getDetailsTableViewCell(for: indexPath, owner: self) ?? UITableViewCell.init()
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard interactor?.getDetailsTableViewCell(for: indexPath, owner: self) as? SprintChallengeTableViewCell != nil,
              let model = interactor?.getModel() as? SprintChallengeViewModel ,
              indexPath.row > 0 else {
            return
        }
        let relatedItem = model.relatedStrategiesModels[indexPath.row - 1]
        handleActionForRelatedItem(relatedItem)
    }

    func handleActionForRelatedItem(_ relatedItem: SprintChallengeViewModel.RelatedItemsModel) {
        if let contentItemId = relatedItem.contentItemId,
            let launchURL = URLScheme.contentItem.launchURLWithParameterValue(String(contentItemId)) {
            UIApplication.shared.open(launchURL, options: [:], completionHandler: nil)
            switch relatedItem.format {
            case .video:
                var userEventTrack = QDMUserEventTracking()
                userEventTrack.name = .PLAY
                userEventTrack.value = relatedItem.contentItemId
                userEventTrack.valueType = .VIDEO
                userEventTrack.action = .TAP
                NotificationCenter.default.post(name: .reportUserEvent, object: userEventTrack)
            default:
                break
            }
        } else if let contentCollectionId = relatedItem.contentId {
            if relatedItem.section == .LearnStrategies {
                presentStrategyList(strategyID: contentCollectionId)
            } else if relatedItem.section == .QOTLibrary {
                openTools(toolID: contentCollectionId)
            } else if relatedItem.link !=  nil {
                relatedItem.link?.launch()
            } else if let launchURL = URLScheme.randomContent.launchURLWithParameterValue(String(contentCollectionId)) {
                UIApplication.shared.open(launchURL, options: [:], completionHandler: nil)
            }
        }

    }
}

extension BaseDailyBriefDetailsViewController: QuestionnaireAnswer {

    func isPresented(for questionIdentifier: Int?, from viewController: UIViewController) {
    }

    func isSelecting(answer: Int, for questionIdentifier: Int?, from viewController: UIViewController) {
    }

    func didSelect(answer: Int, for questionIdentifier: Int?, from viewController: UIViewController) {
        let index = 0
        if index == NSNotFound { return }
        interactor.customizeSleepQuestion { (question) in
            let answers = question?.answers?.count ?? 0
            question?.selectedAnswerIndex = (answers - 1) - answer
        }
    }

    func saveTargetValue(value: Int?) {
        interactor.saveTargetValue(value: value)
    }
}

extension BaseDailyBriefDetailsViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        refreshBottomNavigationItems()
    }
}

// MARK: - BottomNavigation
extension BaseDailyBriefDetailsViewController {
    @objc override public func didTapDismissButton() {
        trackUserEvent(.CLOSE, action: .TAP)
        dismiss(animated: true, completion: nil)
    }

    @objc override public func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return [dismissNavigationItem()]
    }
}
