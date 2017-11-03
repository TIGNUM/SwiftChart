//
//  MyUniverseViewController.swift
//  QOT
//
//  Created by karmic on 22/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import ReactiveKit

protocol MyUniverseViewControllerDelegate: class {

    func didTapSector(startingSection: StatisticsSectionType?, in viewController: MyUniverseViewController)

    func didTapMyToBeVision(vision: MyToBeVision?, from view: UIView, in viewController: MyUniverseViewController)

    func didTapWeeklyChoices(weeklyChoice: WeeklyChoice?, from view: UIView, in viewController: MyUniverseViewController)

    func didTapQOTPartner(selectedIndex: Index, partners: [Partner], from view: UIView, in viewController: MyUniverseViewController)

    func didTapRightBarButton(_ button: UIBarButtonItem, from topNavigationBar: TopNavigationBar, in viewController: MyUniverseViewController)
}

protocol MyWhyViewDelegate: class {

    func didTapMyToBeVision(vision: MyToBeVision?, from view: UIView)

    func didTapWeeklyChoices(weeklyChoice: WeeklyChoice?, from view: UIView)

    func didTapQOTPartner(selectedIndex: Index, partners: [Partner], from view: UIView)
}

final class MyUniverseViewController: UIViewController {
    
    // MARK: - Properties

    private let disposeBag = DisposeBag()
    private let myDataViewModel: MyDataViewModel
    private let myWhyViewModel: MyWhyViewModel
    private var lastContentOffset: CGFloat = 0
    var pageName: PageName = .myData
    weak var delegate: MyUniverseViewControllerDelegate?
    let pageTracker: PageTracker

    private lazy var topBar: TopNavigationBar = {
        let topBar = TopNavigationBar(frame: CGRect(
            x: 0.0,
            y: 20.0,
            width: self.view.bounds.size.width,
            height: 44.0
        ))
        topBar.items = [UINavigationItem()]
        topBar.topNavigationBarDelegate = self
        let rightButton = UIBarButtonItem(withImage: R.image.ic_menu())
        topBar.setRightButton(rightButton)
        topBar.setMiddleButtons(self.middleButtons)

        return topBar
    }()
    
    private lazy var middleButtons: [UIButton] = {
        let myDataButton = UIButton(type: .custom)
        myDataButton.setTitle(R.string.localized.topTabBarItemTitleMeMyData().uppercased(), for: .normal)
        myDataButton.setTitleColor(.white, for: .selected)
        myDataButton.setTitleColor(.gray, for: .normal)
        myDataButton.titleLabel?.font = Font.H5SecondaryHeadline
        myDataButton.backgroundColor = .clear
        
        let myWhyButton = UIButton(type: .custom)
        myWhyButton.setTitle(R.string.localized.topTabBarItemTitleMeMyWhy().uppercased(), for: .normal)
        myWhyButton.setTitleColor(.white, for: .selected)
        myWhyButton.setTitleColor(.gray, for: .normal)
        myWhyButton.titleLabel?.font = Font.H5SecondaryHeadline
        myWhyButton.backgroundColor = .clear
        
        return [myDataButton, myWhyButton]
    }()
    
    lazy var myDataView: MyDataView = {
        return MyDataView(
            delegate: self,
            sectors: self.myDataViewModel.sectors,
            myDataViewModel: self.myDataViewModel,
            frame: CGRect(
                x: self.view.bounds.origin.x,
                y: 15.0,
                width: self.view.bounds.width,
                height: self.view.bounds.height - Layout.TabBarView.height
            )
        )
    }()

    lazy var myWhyView: MyWhyView = {
        let myWhyViewFrame = CGRect(
            x: self.view.bounds.width,
            y: self.view.bounds.origin.y,
            width: self.view.bounds.width,
            height: self.view.bounds.height
        )

        return MyWhyView(
            myWhyViewModel: self.myWhyViewModel,
            frame: myWhyViewFrame,
            screenType: self.screenType,
            delegate: self
        )
    }()

    private lazy var myDataSectorLabelsView: MyDataSectorLabelsView = {
        return MyDataSectorLabelsView(
            sectors: self.myDataViewModel.sectors,
            frame: myDataView.frame,
            screenType: self.screenType
        )
    }()
    
    private lazy var scrollView: UIScrollView = {
        let layout = Layout.MeSection(viewControllerFrame: self.view.bounds)
        let contentScrollView = MyUniverseHelper.createScrollView(self.view.bounds, layout: layout)
        contentScrollView.delegate = self
        contentScrollView.isPagingEnabled = true
        contentScrollView.contentInset = UIEdgeInsets(
            top: self.topBar.bounds.size.height + 20.0,
            left: contentScrollView.contentInset.left,
            bottom: contentScrollView.contentInset.bottom,
            right: contentScrollView.contentInset.right
        )

        return contentScrollView
    }()

    private lazy var backgroundScrollView: UIScrollView = {
        let layout = Layout.MeSection(viewControllerFrame: self.view.bounds)
        let backgroundScrollView = MyUniverseHelper.createScrollView(self.view.frame, layout: layout)
        backgroundScrollView.isUserInteractionEnabled = false
        backgroundScrollView.delegate = nil

        return backgroundScrollView
    }()

    private lazy var backgroundImage: UIView = {
        let frame = self.view.frame
        let imageViewFrame = CGRect(x: frame.minX, y: frame.minY, width: frame.width * 2, height: frame.height)
        let imageView = UIImageView(frame: imageViewFrame)
        imageView.image = R.image.backgroundMyUniverse()
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()

    // MARK: - Life Cycle

    init(myDataViewModel: MyDataViewModel, myWhyViewModel: MyWhyViewModel, pageTracker: PageTracker) {
        self.myDataViewModel = myDataViewModel
        self.myWhyViewModel = myWhyViewModel
        self.pageTracker = pageTracker

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addTabRecognizer()
        addSubViews()

        myWhyViewModel.updates.observeNext { [weak self, weak myWhyViewModel] (_: CollectionUpdate) in
            if let resource = myWhyViewModel?.myToBeVision?.profileImageResource {
                self?.myDataView.updateProfileImageResource(resource)
            }
        }.dispose(in: disposeBag)
    }
}

// MARK: - Private

private extension MyUniverseViewController {

    func addSubViews() {
        backgroundScrollView.addSubview(backgroundImage)
        view.addSubview(backgroundScrollView)
        view.addSubview(scrollView)
        view.addSubview(topBar)
        scrollView.addSubview(myWhyView)
        scrollView.addSubview(myDataSectorLabelsView)
        scrollView.addSubview(myDataView)
    }
    
    func updatePageTracking() {
        switch pageIndex {
        case 0: pageName = .myData
        default: pageName = .myWhy
        }

        pageTracker.track(self)
    }
}

// MARK: - TabRecognizer

private extension MyUniverseViewController {

    func addTabRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapSector))
        scrollView.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func didTapSector(recognizer: UITapGestureRecognizer) {
        guard pageIndex == 0 else {
            return
        }
        let point = recognizer.location(in: myDataView)
        if let section = myDataSectorLabelsView.labelForPoint(point)?.sector.labelType.sectionType {
            delegate?.didTapSector(startingSection: section, in: self)
        } else if let section = myDataView.dataPointForPoint(point)?.sector.labelType.sectionType {
            delegate?.didTapSector(startingSection: section, in: self)
        }
    }
}

// MARK: - ScrollViewDelegate

extension MyUniverseViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setBackgroundParallaxEffect(scrollView)
        updateProfileImageViewAlphaValue(scrollView)
        updateSectorLabelsAlphaValue(scrollView)
        updateMyWhyViewAlphaValue(scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updatePageTracking()
        guard scrollView.contentOffset.x > 0.0 else {
            topBar.setIndicatorToButtonIndex(0)
            return
        }
        
        topBar.setIndicatorToButtonIndex(pageIndex)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updatePageTracking()
    }
    
    var pageIndex: Int {
        guard scrollView.contentOffset.x > 0.0 else {
            return 0
        }
        return Int(floor(scrollView.frame.size.width / scrollView.contentOffset.x))
    }
    
    func pageOffsetForIndex(_ index: Int) -> CGFloat {
        switch index {
        case 1:
            // @warning hacky - but not sure how else to handle this. returning myDataView.width, or myWhyView.x doesnt work - the page offset is too large
            return scrollView.contentSize.width - view.bounds.size.width
        default:
            return 0.0
        }
    }
}

// MARK: - ScrollView Effects

private extension MyUniverseViewController {

    func scrollFactor(_ contentScrollView: UIScrollView) -> CGFloat {
        let maxX = contentScrollView.frame.maxX - view.frame.width * 0.24
        guard maxX > 0 else {
            return 0
        }

        return 1 - (contentScrollView.contentOffset.x/maxX)
    }

    func setBackgroundParallaxEffect(_ contentScrollView: UIScrollView) {
        let backgroundContentOffset = CGPoint(x: contentScrollView.contentOffset.x * 1.2, y: contentScrollView.contentOffset.y)
        backgroundScrollView.setContentOffset(backgroundContentOffset, animated: false)
    }

    func updateProfileImageViewAlphaValue(_ contentScrollView: UIScrollView) {
        let alpha = scrollFactor(contentScrollView)
        myDataView.profileImageViewOverlay.alpha = alpha
        myDataView.profileImageViewOverlayEffect.alpha = alpha
    }

    func updateSectorLabelsAlphaValue(_ contentScrollView: UIScrollView) {
        let alpha = scrollFactor(contentScrollView)
        myDataSectorLabelsView.sectorLabels.forEach({ (sectorLabel: SectorLabel) in
            sectorLabel.label.alpha = alpha
        })
    }

    func updateMyWhyViewAlphaValue(_ contentScrollView: UIScrollView) {
        let alpha = scrollFactor(contentScrollView)
        myWhyView.alpha = 1 - alpha
    }
}

// MARK: - MyWhyViewDelegate

extension MyUniverseViewController: MyWhyViewDelegate {

    func didTapMyToBeVision(vision: MyToBeVision?, from view: UIView) {
        delegate?.didTapMyToBeVision(vision: vision, from: view, in: self)
    }

    func didTapWeeklyChoices(weeklyChoice: WeeklyChoice?, from view: UIView) {
        delegate?.didTapWeeklyChoices(weeklyChoice: weeklyChoice, from: view, in: self)
    }

    func didTapQOTPartner(selectedIndex: Index, partners: [Partner], from view: UIView) {
        delegate?.didTapQOTPartner(selectedIndex: selectedIndex, partners: partners, from: view, in: self)
    }
}

extension MyUniverseViewController: MyDataViewDelegate {

    func myDataView(_ view: MyDataView, pressedProfileButton button: UIButton) {
        delegate?.didTapMyToBeVision(vision: myWhyViewModel.myToBeVision, from: button, in: self)
    }
}

// MARK: - TopNavigationBarDelegate

extension MyUniverseViewController: TopNavigationBarDelegate {
    func topNavigationBar(_ navigationBar: TopNavigationBar, leftButtonPressed button: UIBarButtonItem) {
    }
    
    func topNavigationBar(_ navigationBar: TopNavigationBar, middleButtonPressed button: UIButton, withIndex index: Int, ofTotal total: Int) {
        guard let index = middleButtons.index(of: button) else {
            return
        }
        scrollView.setContentOffset(CGPoint(
            x: pageOffsetForIndex(index),
            y: scrollView.contentOffset.y
        ), animated: true)
    }
    
    func topNavigationBar(_ navigationBar: TopNavigationBar, rightButtonPressed button: UIBarButtonItem) {
        delegate?.didTapRightBarButton(button, from: navigationBar, in: self)
    }
}

// MARK: - animation helper

private extension UIViewController {

    func contains(_ classId: AnyClass) -> Bool {
        if let navigationController = self as? UINavigationController, let pageViewController = navigationController.viewControllers.first as? PageViewController, let viewController = pageViewController.data?.first, viewController.classForCoder == classId {
            return true
        }
        return false
    }
}
