//
//  BaseDailyBriefDetailsInteractor.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 09/11/2020.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class BaseDailyBriefDetailsInteractor {

    // MARK: - Properties
    private lazy var worker = BaseDailyBriefDetailsWorker(model: model)
    private let presenter: BaseDailyBriefDetailsPresenterInterface!
    let model: BaseDailyBriefViewModel

    // MARK: - Init
    init(presenter: BaseDailyBriefDetailsPresenterInterface, model: BaseDailyBriefViewModel) {
        self.presenter = presenter
        self.model = model
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - BaseDailyBriefDetailsInteractorInterface
extension BaseDailyBriefDetailsInteractor: BaseDailyBriefDetailsInteractorInterface {
    func getNumberOfRows() -> Int {
        switch model.domainModel?.bucketName {
        case DailyBriefBucketName.DAILY_CHECK_IN_1:
            if (model as? ImpactReadinessCellViewModel) != nil {
               return 1
            } else if (model as? ImpactReadinessScoreViewModel) != nil {
                return 2
            }
            return 0
        default:
            return 1
        }
    }

    func getDetailsTableViewCell(for indexPath: IndexPath, owner: BaseDailyBriefDetailsViewController) -> UITableViewCell {
        switch model.domainModel?.bucketName {
        case DailyBriefBucketName.DAILY_CHECK_IN_1:
            if (model as? ImpactReadinessCellViewModel) != nil {
                guard let impactReadinessModel = model as? ImpactReadinessCellViewModel,
                      let cell: NewBaseDailyBriefCell = R.nib.newBaseDailyBriefCell(owner: owner),
                      indexPath == IndexPath.init(row: 0, section: 0) else {
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
            } else if (model as? ImpactReadinessScoreViewModel) != nil {
                switch indexPath.row {
                case 0:
                    guard let cell: NewBaseDailyBriefCell = R.nib.newBaseDailyBriefCell(owner: owner) else {
                        return UITableViewCell.init()
                    }
                    let standardModel2 = NewDailyBriefStandardModel.init(caption: AppTextService.get(.daily_brief_section_impact_readiness_section_5_day_rolling_title).uppercased(),
                                                                         title: "Your load and recovery in detail",
                                                                         body: "The last 5 days are key on how you fell today",
                                                                         image: "https://homepages.cae.wisc.edu/~ece533/images/boy.bmp",
                                                                         detailsMode: true,
                                                                         domainModel: nil)

                    cell.configure(with: [standardModel2])
                    cell.collectionView.contentInsetAdjustmentBehavior = .never
                    return cell
                case 1:
                    guard let impactReadiness2Model = model as? ImpactReadinessScoreViewModel,
                          let cell: ImpactReadiness5DaysRollingTableViewCell = R.nib.impactReadiness5DaysRollingTableViewCell(owner: owner) else {
                        return UITableViewCell.init()
                    }

                    cell.configure(viewModel: impactReadiness2Model)
                    cell.delegate = owner
                    return cell
                default:
                    break
                }
            }
        default:
            return UITableViewCell.init()
        }
        return UITableViewCell.init()
    }

    func getModel() -> BaseDailyBriefViewModel {
        return self.model
    }

    func customizeSleepQuestion(completion: @escaping (RatingQuestionViewModel.Question?) -> Void) {
        worker.customizeSleepQuestion(completion: completion)
    }
}
