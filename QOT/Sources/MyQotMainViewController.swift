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

    private var qotBoxSize: CGSize {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }

        let widthAvailbleForAllItems =  (collectionView.frame.width - layout.minimumInteritemSpacing - layout.sectionInset.left - layout.sectionInset.right)
        let widthForOneItem = widthAvailbleForAllItems / 2
        let heightAvailableForAllItems = (collectionView.frame.height -
                                            (layout.minimumLineSpacing + layout.sectionInset.top + layout.sectionInset.bottom) * 2 -
                                            ThemeView.level1.headerBarHeight)
        let heightForOneItem = heightAvailableForAllItems / 3

        return CGSize(width: widthForOneItem, height: heightForOneItem)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return ColorMode.dark.statusBarStyle
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        self.showLoadingSkeleton(with: [.padHeading, .myQOT, .myQOT, .myQOT])

        getImpactReadinessScore(completion: { (score) in
            self.impactReadinessScore = Int(score ?? 0)
            self.collectionView.reloadData()
            self.removeLoadingSkeleton()
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
        super.viewWillAppear(animated)
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
        collectionView.isScrollEnabled = false
        collectionView.registerDequeueable(MyQotMainCollectionViewCell.self)
        collectionView.registerDequeueable(NavBarCollectionViewCell.self)

        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = .init(top: 10, left: 24, bottom: 0, right: 24)
    }

    func setup(for myQotSection: MyQotViewModel) {
        myQotModel = myQotSection
    }
}

extension MyQotMainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return MyQotViewModel.Section.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case MyQotViewModel.Section.header.rawValue:
            return 1
        default:
            return myQotModel?.myQotItems.count ?? 0
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case MyQotViewModel.Section.header.rawValue:
            let cell: NavBarCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            let title = R.string.localized.myQOTTitle()
            cell.configure(title: title, leftArrow: true, rightArrow: false)
            return cell
        default:
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
                        cell.configure(title: (self.myQotModel?.myQotItems[indexPath.row].title) ?? "", subtitle: self.subtitleVision ?? subtitles[indexPath.row] ?? "", isRed: true)
                    }
                })
            }
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case MyQotViewModel.Section.header.rawValue:
            return CGSize(width: view.frame.width, height: ThemeView.level1.headerBarHeight)
        default:
            return qotBoxSize
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case MyQotViewModel.Section.header.rawValue:
            return
        default:
            let qotSection = MyQotSection.allCases[indexPath.row]
            switch qotSection {
            case .profile:
                interactor?.presentMyProfile()
            case .library:
                interactor?.presentMyLibrary()
            case .preps:
                interactor?.presentMyPreps()
            case .sprints:
                interactor?.presentMySprints()
            case .data:
                interactor?.presentMyDataScreen()
            case .toBeVision:
                interactor?.presentMyToBeVision()
            }
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? NavBarCollectionViewCell {
            cell.updateAlpha(basedOn: scrollView.contentOffset.y)
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
