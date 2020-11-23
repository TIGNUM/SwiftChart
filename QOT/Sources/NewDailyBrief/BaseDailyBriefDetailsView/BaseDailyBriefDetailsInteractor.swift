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
        case DailyBriefBucketName.ME_AT_MY_BEST:
            if (model as? MeAtMyBestCellViewModel) != nil {
                return 2
            }
            return 1
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
                                                                     title: ImpactReadinessCellViewModel.createAttributedImpactReadinessTitle(for: impactReadinessModel.readinessScore,
                                                                                                                       impactReadinessNoDataTitle: impactReadinessModel.title),
                                                                     body: impactReadinessModel.feedback ?? "",
                                                                     image: impactReadinessModel.dailyCheckImageURL?.absoluteString ?? "https://homepages.cae.wisc.edu/~ece533/images/boy.bmp",
                                                                     detailsMode: true,
                                                                     domainModel: nil)
                cell.configure(with: [standardModel1])
                cell.collectionView.contentInsetAdjustmentBehavior = .never

                return cell
            } else if let scoreModel = model as? ImpactReadinessScoreViewModel {
                switch indexPath.row {
                case 0:
                    guard let cell: NewBaseDailyBriefCell = R.nib.newBaseDailyBriefCell(owner: owner) else {
                        return UITableViewCell.init()
                    }
                    let standardModel2 = NewDailyBriefStandardModel.init(caption: AppTextService.get(.daily_brief_section_impact_readiness_section_5_day_rolling_title).lowercased().capitalizingFirstLetter(),
                                                                         title: NSAttributedString.init(string: AppTextService.get(.daily_brief_section_impact_readiness_section_5_day_rolling_subtitle)),
                                                                         body: scoreModel.howYouFeelToday,
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
        case DailyBriefBucketName.EXPERT_THOUGHTS:
            guard let expertThoughtsModel = model as? ExpertThoughtsCellViewModel,
                  let cell: NewBaseDailyBriefCell = R.nib.newBaseDailyBriefCell(owner: owner),
                  indexPath == IndexPath.init(row: 0, section: 0) else {
                return UITableViewCell.init()
            }
            let standardModel = NewDailyBriefStandardModel.init(caption: expertThoughtsModel.title ?? "",
                                                                 title: NSAttributedString.init(string: expertThoughtsModel.description ?? ""),
                                                                 body: expertThoughtsModel.name ?? "",
                                                                 image: "https://homepages.cae.wisc.edu/~ece533/images/boy.bmp",
                                                                 detailsMode: true,
                                                                 domainModel: nil)
            cell.configure(with: [standardModel])
            cell.collectionView.contentInsetAdjustmentBehavior = .never
            return cell
        case DailyBriefBucketName.LEADERS_WISDOM:
            guard let leadersWisdomViewModel = model as? LeaderWisdomCellViewModel,
                  let cell: NewBaseDailyBriefCell = R.nib.newBaseDailyBriefCell(owner: owner),
                  indexPath == IndexPath.init(row: 0, section: 0) else {
                return UITableViewCell.init()
            }

            let standardModel = NewDailyBriefStandardModel.init(caption: leadersWisdomViewModel.title ?? "",
                                                                 title: NSAttributedString.init(string: leadersWisdomViewModel.subtitle ?? ""),
                                                                 body: leadersWisdomViewModel.description ?? "",
                                                                 image: "https://homepages.cae.wisc.edu/~ece533/images/boy.bmp",
                                                                 detailsMode: true,
                                                                 domainModel: leadersWisdomViewModel.domainModel)
            cell.configure(with: [standardModel])
            return cell
        case DailyBriefBucketName.ME_AT_MY_BEST:
            if model.domainModel?.toBeVisionTrack?.sentence?.isEmpty == false {
                switch indexPath.row {
                case 0:
                    guard let cell: NewBaseDailyBriefCell = R.nib.newBaseDailyBriefCell(owner: owner),
                          let meAtMyBestViewModel = model as? MeAtMyBestCellViewModel else {
                        return UITableViewCell.init()
                    }
                    let standardModel = NewDailyBriefStandardModel.init(caption: meAtMyBestViewModel.title ?? "",
                                                                        title: NSAttributedString.init(string: AppTextService.get(.daily_brief_section_my_best_card_title)),
                                                                        body: meAtMyBestViewModel.tbvStatement ?? "",
                                                                        image: "https://homepages.cae.wisc.edu/~ece533/images/boy.bmp",
                                                                        detailsMode: true,
                                                                        domainModel: meAtMyBestViewModel.domainModel)

                    cell.configure(with: [standardModel])
                    cell.collectionView.contentInsetAdjustmentBehavior = .never
                    return cell
                case 1:
                    guard let meAtMyBestViewModel = model as? MeAtMyBestCellViewModel,
                          let cell: MeAtMyBestTableViewCell = R.nib.meAtMyBestTableViewCell(owner: owner) else {
                        return UITableViewCell.init()
                    }

                    cell.configure(with: meAtMyBestViewModel)
                    cell.delegate = owner
                    return cell
                default:
                    break
                }
            } else {
                guard let cell: NewBaseDailyBriefCell = R.nib.newBaseDailyBriefCell(owner: owner),
                      let meAtMyBestCellEmptyViewModel = model as? MeAtMyBestCellEmptyViewModel else {
                    return UITableViewCell.init()
                }
                let standardModel = NewDailyBriefStandardModel.init(caption: meAtMyBestCellEmptyViewModel.title ?? "",
                                                                    title: NSAttributedString.init(string: meAtMyBestCellEmptyViewModel.buttonText ?? ""),
                                                                    body: meAtMyBestCellEmptyViewModel.intro ?? "",
                                                                     image: "https://homepages.cae.wisc.edu/~ece533/images/boy.bmp",
                                                                     detailsMode: true,
                                                                     domainModel: meAtMyBestCellEmptyViewModel.domainModel)

                cell.configure(with: [standardModel])
                cell.collectionView.contentInsetAdjustmentBehavior = .never
                return cell
            }
        case DailyBriefBucketName.MINDSET_SHIFTER:
            switch indexPath.row {
            case 0:
                guard let cell: NewBaseDailyBriefCell = R.nib.newBaseDailyBriefCell(owner: owner) else {
                    return UITableViewCell.init()
                }
                let standardModel2 = NewDailyBriefStandardModel.init(caption: AppTextService.get(.daily_brief_section_impact_readiness_section_5_day_rolling_title).uppercased(),
                                                                     title: NSAttributedString.init(string: AppTextService.get(.daily_brief_section_impact_readiness_section_5_day_rolling_subtitle)),
                                                                     body: AppTextService.get(.daily_brief_section_impact_readiness_section_5_day_rolling_body),
                                                                     image: "https://homepages.cae.wisc.edu/~ece533/images/boy.bmp",
                                                                     detailsMode: true,
                                                                     domainModel: nil)

                cell.configure(with: [standardModel2])
                cell.collectionView.contentInsetAdjustmentBehavior = .never
                return cell
            case 1:
                guard let mindsetShifterModel = model as? MindsetShifterViewModel,
                      let cell: MindsetShifterTableViewCell = R.nib.mindsetShifterTableViewCell(owner: owner) else {
                    return UITableViewCell.init()
                }

                cell.configure(with: mindsetShifterModel)
                cell.delegate = owner

                return cell
            default:
                break
            }
        case DailyBriefBucketName.MY_PEAK_PERFORMANCE:
            switch indexPath.row {
            case 0:
                guard let cell: NewBaseDailyBriefCell = R.nib.newBaseDailyBriefCell(owner: owner),
                      let peakPerformanceModel = model as? PeakPerformanceViewModel else {
                    return UITableViewCell.init()
                }
                let standardModel = NewDailyBriefStandardModel.init(caption: peakPerformanceModel.title,
                                                                     title: NSAttributedString.init(string: peakPerformanceModel.eventTitle ?? ""),
                                                                     body: peakPerformanceModel.contentSentence,
                                                                     image: "https://homepages.cae.wisc.edu/~ece533/images/boy.bmp",
                                                                     detailsMode: true,
                                                                     domainModel: nil)

                cell.configure(with: [standardModel])
                cell.collectionView.contentInsetAdjustmentBehavior = .never
                return cell
            case 1:
                guard let peakPerformanceModel = model as? PeakPerformanceViewModel,
                      let cell: PeakPerformanceTableViewCell = R.nib.peakPerformanceTableViewCell(owner: owner) else {
                    return UITableViewCell.init()
                }

                cell.configure(with: peakPerformanceModel)
                cell.delegate = owner

                return cell
            default:
                break
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
