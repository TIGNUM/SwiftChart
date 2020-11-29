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
        switch model.domainModel?.bucketName {
        case DailyBriefBucketName.DAILY_CHECK_IN_1:
            if (model as? ImpactReadinessCellViewModel) != nil {
                guard let impactReadinessModel = model as? ImpactReadinessCellViewModel else {
                    return UITableViewCell.init()
                }
                switch indexPath.row {
                case 0:
                      guard let cell: NewBaseDailyBriefCell = R.nib.newBaseDailyBriefCell(owner: owner) else {
                    return UITableViewCell.init()
                }

                let body = impactReadinessModel.feedback?.isEmpty ?? true ? impactReadinessModel.readinessIntro : impactReadinessModel.feedback
                let standardModel1 = NewDailyBriefStandardModel.init(caption: impactReadinessModel.title ?? "",
                                                                     title: ImpactReadinessCellViewModel.createAttributedImpactReadinessTitle(for: impactReadinessModel.readinessScore,
                                                                                                                       impactReadinessNoDataTitle: impactReadinessModel.title),
                                                                     body: body,
                                                                     image: "https://homepages.cae.wisc.edu/~ece533/images/boy.bmp",
                                                                     detailsMode: true,
                                                                     domainModel: nil)
                cell.configure(with: [standardModel1])
                cell.collectionView.contentInsetAdjustmentBehavior = .never

                return cell
                case 1:
                    guard let cell: ImpactReadinessTableViewCell = R.nib.impactReadinessTableViewCell(owner: owner) else {
                        return UITableViewCell.init()
                    }

                    cell.configure(viewModel: impactReadinessModel)
                    return cell
                default:
                    break
                }
            } else if let scoreModel = model as? ImpactReadinessScoreViewModel {
                switch indexPath.row {
                case 0:
                    guard let cell: NewBaseDailyBriefCell = R.nib.newBaseDailyBriefCell(owner: owner) else {
                        return UITableViewCell.init()
                    }
                    let standardModel2 = NewDailyBriefStandardModel.init(caption: AppTextService.get(.daily_brief_section_impact_readiness_section_5_day_rolling_title),
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
                                                                 title: NSAttributedString.init(string: expertThoughtsModel.name ?? ""),
                                                                 body: expertThoughtsModel.description ?? "",
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
                                                                        image: meAtMyBestViewModel.image,
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
                guard let mindsetShifterModel = model as? MindsetShifterViewModel,
                      let cell: NewBaseDailyBriefCell = R.nib.newBaseDailyBriefCell(owner: owner) else {
                    return UITableViewCell.init()
                }
                let standardModel2 = NewDailyBriefStandardModel.init(caption: AppTextService.get(.daily_brief_section_mindset_shifter_card_caption),
                                                                     title: NSAttributedString.init(string: AppTextService.get(.daily_brief_section_mindset_shifter_card_title)),
                                                                     body: mindsetShifterModel.subtitle,
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
        case DailyBriefBucketName.GET_TO_LEVEL_5:
            switch indexPath.row {
            case 0:
                guard let cell: NewBaseDailyBriefCell = R.nib.newBaseDailyBriefCell(owner: owner),
                      let level5Model = model as? Level5ViewModel else {
                    return UITableViewCell.init()
                }
                let intro = level5Model.intro
                let messages = level5Model.levelMessages
                let question = level5Model.question
                var levelMessages: [Level5ViewModel.LevelDetail] = []
                let selectedValue = level5Model.domainModel?.currentGetToLevel5Value
                let levelDetailZero = Level5ViewModel.LevelDetail.init(levelTitle: question, levelContent: intro)
                levelMessages.append(levelDetailZero)
                levelMessages.append(contentsOf: messages)
                let standardModel = NewDailyBriefStandardModel.init(caption: level5Model.title,
                                                                     title: NSAttributedString.init(string: levelMessages[selectedValue ?? 0].levelTitle ?? ""),
                                                                     body: levelMessages[selectedValue ?? 0].levelContent,
                                                                     image: "https://homepages.cae.wisc.edu/~ece533/images/boy.bmp",
                                                                     detailsMode: true,
                                                                     domainModel: level5Model.domainModel)

                cell.configure(with: [standardModel])
                cell.collectionView.contentInsetAdjustmentBehavior = .never
                return cell
            case 1:
                guard let level5Model = model as? Level5ViewModel,
                      let cell: Level5TableViewCell = R.nib.level5TableViewCell(owner: owner) else {
                    return UITableViewCell.init()
                }

                cell.configure(with: level5Model)
                cell.delegate = owner

                return cell
            default:
                break
            }
        case DailyBriefBucketName.FROM_MY_COACH:
            switch indexPath.row {
            case 0:
                guard let cell: NewBaseDailyBriefCell = R.nib.newBaseDailyBriefCell(owner: owner),
                      let fromMyCoachModel = model as? FromMyCoachCellViewModel else {
                    return UITableViewCell.init()
                }
                let standardModel = NewDailyBriefStandardModel.init(caption: AppTextService.get(.daily_brief_section_from_my_tignum_coach_card_title),
                                                                title: NSAttributedString.init(string: fromMyCoachModel.detail.title),
                                                                body: nil,
                                                                image: "https://homepages.cae.wisc.edu/~ece533/images/boy.bmp",
                                                                detailsMode: true,
                                                                domainModel: fromMyCoachModel.domainModel)
                cell.configure(with: [standardModel])
                cell.collectionView.contentInsetAdjustmentBehavior = .never
                return cell
            default:
                guard let fromMyCoachModel = model as? FromMyCoachCellViewModel,
                      let cell: FromMyCoachTableViewCell = R.nib.fromMyCoachTableViewCell(owner: owner) else {
                    return UITableViewCell.init()
                }

                cell.configure(with: fromMyCoachModel.messages[indexPath.row - 1], hideSeparatorView: indexPath.row == fromMyCoachModel.messages.count)

                return cell
            }
        default:
            return UITableViewCell.init()
        }
        return UITableViewCell.init()
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
