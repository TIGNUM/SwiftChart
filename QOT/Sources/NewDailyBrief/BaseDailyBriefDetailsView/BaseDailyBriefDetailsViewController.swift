//
//  BaseDailyBriefDetailsViewController.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 09/11/2020.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class BaseDailyBriefDetailsViewController: BaseViewController, ScreenZLevel1 {

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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ThemeView.level1.apply(self.view)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerDequeueable(NewBaseDailyBriefCell.self)
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
}

// MARK: - BaseDailyBriefDetailsViewControllerInterface
extension BaseDailyBriefDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath == IndexPath(row: 0, section: 0) {
            return getDetailsMainCell(forBucketName: interactor.getModel().domainModel?.bucketName)
        }
        return UITableViewCell.init()
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

// MARK: Helpers

    func getDetailsMainCell(forBucketName: DailyBriefBucketName?) -> UITableViewCell {
        let model = interactor.getModel()
        switch forBucketName {
        case DailyBriefBucketName.DAILY_CHECK_IN_1:
            guard let impactReadinessModel = model as? ImpactReadinessCellViewModel,
                  let cell: NewBaseDailyBriefCell = R.nib.newBaseDailyBriefCell(owner: self) else {
                return UITableViewCell.init()
            }
            let standardModel1 = NewDailyBriefStandardModel.init(caption: impactReadinessModel.title ?? "",
                                                                 title: impactReadinessModel.title ?? "",
                                                                 body: impactReadinessModel.feedback ?? "",
                                                                 image: impactReadinessModel.dailyCheckImageURL?.absoluteString ?? "https://homepages.cae.wisc.edu/~ece533/images/boy.bmp",
                                                                 detailsMode: true,
                                                                 domainModel: nil)
            cell.configure(with: [standardModel1])
            cell.collectionView.contentInsetAdjustmentBehavior = .never

            return cell
        default:
            return UITableViewCell.init()
        }
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
