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
    private var model: BaseDailyBriefViewModel

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
            if let impactReadinessModel = model as? ImpactReadinessCellViewModel {
                return impactReadinessModel.feedbackRelatedLink != nil ? 2 : 1
            }
            return ((model as? ImpactReadinessScoreViewModel) != nil) ? 2 : 1
        case DailyBriefBucketName.GET_TO_LEVEL_5, DailyBriefBucketName.MY_PEAK_PERFORMANCE:
            return 2
        case DailyBriefBucketName.ME_AT_MY_BEST:
            if (model as? MeAtMyBestCellViewModel) != nil {
                return 2
            }
            return 1
        case DailyBriefBucketName.FROM_MY_COACH:
            if let fromMyCoachModel = model as? FromMyCoachCellViewModel {
                return fromMyCoachModel.messages.count + 1
            }
            return 1
        case DailyBriefBucketName.MINDSET_SHIFTER:
            return model as? MindsetShifterViewModel != nil ? 2 : 1
        default:
            return 1
        }
    }

    func getDetailsTableViewCell(for indexPath: IndexPath, owner: BaseDailyBriefDetailsViewController) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell: NewBaseDailyBriefCell = R.nib.newBaseDailyBriefCell(owner: owner) else {
                return UITableViewCell.init()
            }

            switch model.domainModel?.bucketName {
            case DailyBriefBucketName.GET_TO_LEVEL_5:
                guard let level5Model = model as? Level5ViewModel else {
                    return UITableViewCell.init()
                }

                let selectedValue = level5Model.domainModel?.currentGetToLevel5Value

                let standardModel = NewDailyBriefStandardModel.init(caption: level5Model.caption,
                                                                     title: level5Model.levelMessages[selectedValue ?? 0].levelTitle ?? "",
                                                                     body: level5Model.levelMessages[selectedValue ?? 0].levelContent,
                                                                     image: level5Model.image,
                                                                     detailsMode: true,
                                                                     domainModel: level5Model.domainModel)

                cell.configure(with: [standardModel])
                cell.collectionView.contentInsetAdjustmentBehavior = .never
                return cell
            default:
                let standardModel = NewDailyBriefStandardModel.init(caption: model.caption,
                                                             title: model.title,
                                                             body: model.body,
                                                             image: model.image,
                                                             detailsMode: true,
                                                             domainModel: model.domainModel)
                cell.configure(with: [standardModel])
                cell.collectionView.contentInsetAdjustmentBehavior = .never

                return cell
            }
        default:
            switch model.domainModel?.bucketName {
            case DailyBriefBucketName.DAILY_CHECK_IN_1:
                if (model as? ImpactReadinessCellViewModel) != nil {
                    guard let impactReadinessModel = model as? ImpactReadinessCellViewModel,
                          let cell: ImpactReadinessTableViewCell = R.nib.impactReadinessTableViewCell(owner: owner) else {
                        return UITableViewCell.init()
                    }
                    cell.configure(viewModel: impactReadinessModel)
                    return cell
                } else if let scoreModel = model as? ImpactReadinessScoreViewModel {
                    guard let cell: ImpactReadiness5DaysRollingTableViewCell = R.nib.impactReadiness5DaysRollingTableViewCell(owner: owner) else {
                        return UITableViewCell.init()
                    }

                    cell.configure(viewModel: scoreModel)
                    cell.delegate = owner
                    return cell
                }
            case DailyBriefBucketName.ME_AT_MY_BEST:
                if model.domainModel?.toBeVisionTrack?.sentence?.isEmpty == false {
                    guard let meAtMyBestViewModel = model as? MeAtMyBestCellViewModel,
                          let cell: MeAtMyBestTableViewCell = R.nib.meAtMyBestTableViewCell(owner: owner) else {
                        return UITableViewCell.init()
                    }

                    cell.configure(with: meAtMyBestViewModel)
                    cell.delegate = owner
                    return cell
                }
            case DailyBriefBucketName.MINDSET_SHIFTER:
                guard let mindsetShifterModel = model as? MindsetShifterViewModel,
                      let cell: MindsetShifterTableViewCell = R.nib.mindsetShifterTableViewCell(owner: owner) else {
                    return UITableViewCell.init()
                }

                cell.configure(with: mindsetShifterModel)
                cell.delegate = owner

                return cell
            case DailyBriefBucketName.MY_PEAK_PERFORMANCE:
                guard let peakPerformanceModel = model as? PeakPerformanceViewModel,
                      let cell: PeakPerformanceTableViewCell = R.nib.peakPerformanceTableViewCell(owner: owner) else {
                    return UITableViewCell.init()
                }

                cell.configure(with: peakPerformanceModel)
                cell.delegate = owner

                return cell
            case DailyBriefBucketName.GET_TO_LEVEL_5:
                guard let level5Model = model as? Level5ViewModel,
                      let cell: Level5TableViewCell = R.nib.level5TableViewCell(owner: owner) else {
                    return UITableViewCell.init()
                }

                cell.configure(with: level5Model)
                cell.delegate = owner

                return cell
            case DailyBriefBucketName.FROM_MY_COACH:
                guard let fromMyCoachModel = model as? FromMyCoachCellViewModel,
                      let cell: FromMyCoachTableViewCell = R.nib.fromMyCoachTableViewCell(owner: owner) else {
                    return UITableViewCell.init()
                }

                cell.configure(with: fromMyCoachModel.messages[indexPath.row - 1], hideSeparatorView: indexPath.row == fromMyCoachModel.messages.count)

                return cell
            default:
                return UITableViewCell.init()
            }
        return UITableViewCell.init()
        }
    }

    func getModel() -> BaseDailyBriefViewModel {
        return self.model
    }

    func updateModel(_ model: BaseDailyBriefViewModel) {
        self.model = model
    }

    func customizeSleepQuestion(completion: @escaping (RatingQuestionViewModel.Question?) -> Void) {
        worker.customizeSleepQuestion(completion: completion)
    }

    func saveAnswerValue(_ value: Int) {
        worker.saveAnswerValue(value)
    }
}
