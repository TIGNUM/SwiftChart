//
//  MyQotMainViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import Anchorage
import qot_dal

final class MyQotNavigationController: UINavigationController {
    static var storyboardID = NSStringFromClass(MyQotNavigationController.classForCoder())
}

final class MyQotMainViewController: UIViewController, ScreenZLevel1 {

    // MARK: - Properties

    var interactor: MyQotMainInteractorInterface?
    var delegate: CoachCollectionViewControllerDelegate?
    @IBOutlet private weak var collectionView: UICollectionView!
    private var myQotModel: MyQotViewModel?
    private var dateOfPrep: String?
    private var eventType: String?
    private var toBeVisionModified: Date?
    private var timeSinceMonth: Int?
    private var subtitleVision: String?
    private var impactReadinessScore: Int?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return ColorMode.dark.statusBarStyle
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
        getImpactReadinessScore(completion: { (score) in
            self.impactReadinessScore = Int(score ?? 0)
            self.collectionView.reloadData()
        })
        nextPrepDate(completion: { (dateString) in
            self.dateOfPrep = dateString
        })
        nextPrepType(completion: { (eventType) in
            self.eventType = eventType
        })
        toBeVisionDate(completion: { (date) in
            self.toBeVisionModified = date
            self.timeSinceMonth = Int(self.timeElapsed(date: date).rounded())
            if let time = self.timeSinceMonth {
                if time == 1 {
                    self.subtitleVision = "One month ago"
                } else if time  > 1 {
                    self.subtitleVision = R.string.localized.myQotVisionMorethan() + String(describing: time) + R.string.localized.myQotVisionMonthsSince()
                } else { self.subtitleVision = R.string.localized.myQotVisionLessThan()}
            }
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setStatusBar(colorMode: ColorMode.dark)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }
}

    // MARK: - MyQotMainViewControllerInterface

extension MyQotMainViewController: MyQotMainViewControllerInterface {

        func setupView() {
            view.addFadeView(at: .bottom, height: 120, primaryColor: .carbonDark)
            collectionView.bounces = false
            collectionView.alwaysBounceVertical = false
            collectionView.registerDequeueable(MyQotMainCollectionViewCell.self)
        }

        func setup(for myQotSection: MyQotViewModel) {
            myQotModel = myQotSection
        }
    }

extension MyQotMainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myQotModel?.myQotItems.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let qotSection = MyQotSection.allCases[indexPath.row]
        let cell: MyQotMainCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        switch qotSection {
        case .profile:
            interactor?.getUserName(completion: {(name) in
                self.interactor?.getSubtitles(completion: {(subtitles) in
                    if subtitles.count > 0 {
                    cell.configure(title: (self.myQotModel?.myQotItems[indexPath.row].title) ?? "", subtitle: "Hello " + (name ?? "") + ",\n" + (subtitles[indexPath.row]?.lowercased() ?? ""))
                    }
                })
            })

        case .library:
            cell.configure(title: (myQotModel?.myQotItems[indexPath.row].title) ?? "", subtitle: "")
        case .preps:
            nextPrepDate(completion: { (dateString) in
                cell.configure(title: (self.myQotModel?.myQotItems[indexPath.row].title) ?? "", subtitle: (dateString ?? "") + " " + (self.eventType ?? ""))
            })

        case .sprints:
            interactor?.getSubtitles(completion: {(subtitles) in
                 if subtitles.count > 0 {
                 cell.configure(title: (self.myQotModel?.myQotItems[indexPath.row].title) ?? "", subtitle: subtitles[indexPath.row] ?? "")
                }
            })
        case .data:
            let subtitle = R.string.localized.myQotDataImpact()
            cell.configure(title: (myQotModel?.myQotItems[indexPath.row].title) ?? "", subtitle: String(impactReadinessScore ?? 0) + subtitle)
        case .toBeVision:
            interactor?.getSubtitles(completion: {(subtitles) in
                 if subtitles.count > 0 {
                cell.configure(title: (self.myQotModel?.myQotItems[indexPath.row].title) ?? "", subtitle: self.subtitleVision ?? subtitles[indexPath.row] ?? "")
                cell.subtitleLabel.textColor = .redOrange
                }
            })
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize()
        }
        let widthAvailbleForAllItems =  (collectionView.frame.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right)
        let widthForOneItem = widthAvailbleForAllItems / 2 - flowLayout.minimumInteritemSpacing
        let heightAvailableForAllItems = (collectionView.frame.height - flowLayout.sectionInset.top - flowLayout.sectionInset.right)
        let heightForOneItem = heightAvailableForAllItems/3 - flowLayout.minimumInteritemSpacing
                return CGSize(width: widthForOneItem, height: heightForOneItem)
    }

     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let qotSection = MyQotSection.allCases[indexPath.row]
        switch qotSection {
        case .profile:
            interactor?.presentMyProfile()
        case .library:
            interactor?.presentMyLibrary()
        case .sprints:
            interactor?.presentMySprints()
        case .toBeVision:
            interactor?.presentMyToBeVision()
        default:
            interactor?.presentMyPreps()
        }
    }
}

extension MyQotMainViewController {

    func getImpactReadinessScore(completion: @escaping(Double?) -> Void) {
        interactor?.getImpactReadinessScore(completion: completion)
    }

    func nextPrepDate(completion: @escaping (String?) -> Void) {
        interactor?.nextPrep(completion: completion)
    }

    func nextPrepType(completion: @escaping (String?) -> Void) {
        interactor?.nextPrepType(completion: completion)
    }

    func toBeVisionDate(completion: @escaping (Date?) -> Void) {
        interactor?.toBeVisionDate(completion: completion)
    }

    func timeElapsed(date: Date?) -> Double {
        if let monthSince = date?.months(to: Date()), monthSince > 1 {
            return Double(monthSince)
        }
        return 0
    }
}
