//
//  MyUniverseViewController.swift
//  QOT
//
//  Created by Lee Arromba on 29/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage
import Kingfisher

protocol MyUniverseViewControllerDelegate: class {

    func myUniverseViewController(_ viewController: MyUniverseViewController?, didTap sector: StatisticsSectionType)

    func myUniverseViewControllerDidTapVision(_ viewController: MyUniverseViewController)

    func myUniverseViewController(_ viewController: MyUniverseViewController, didTapWeeklyChoiceAt index: Index)

    func myUniverseViewController(_ viewController: MyUniverseViewController, didTapQOTPartnerAt index: Index)

    func myUniverseViewController(_ viewController: MyUniverseViewController,
                                  didTapLeftBarButtonItem buttonItem: UIBarButtonItem,
                                  in topnavigationBar: NavigationItem)

    func myUniverseViewController(_ viewController: MyUniverseViewController,
                                  didTapRightBarButtonItem buttonItem: UIBarButtonItem,
                                  in topnavigationBar: NavigationItem)
}

extension MyUniverseViewController {

    struct Page {
        let pageName: PageName
        let pageTitle: String
        let widthPercentage: CGFloat

        static let myDataPage = MyUniverseViewController.Page(
            pageName: .myData,
            pageTitle: R.string.localized.topTabBarItemTitleMeMyData().uppercased(),
            widthPercentage: 1.0
        )
        static let myWhyPage = MyUniverseViewController.Page(
            pageName: .myWhy,
            pageTitle: R.string.localized.topTabBarItemTitleMeMyWhy().uppercased(),
            widthPercentage: 0.7
        )
    }
    struct Config {
        let pages: [Page]
        let loadingText: String
        let backgroundImage: UIImage?
        let profileImagePlaceholder: UIImage?
        let partnerImagePlaceholder: UIImage?
        let partnersTitle: String
        let weeklyChoicesTitle: String
        let myToBeVisionTitle: String

        static let `default` = Config(
            pages: [Page.myDataPage, Page.myWhyPage],
            loadingText: R.string.localized.meMyUniverseLoading(),
            backgroundImage: R.image.backgroundMyUniverse(),
            profileImagePlaceholder: R.image.universe_2state(),
            partnerImagePlaceholder: R.image.partnerPlaceholder(),
            partnersTitle: R.string.localized.meSectorMyWhyPartnersTitle().uppercased(),
            weeklyChoicesTitle: R.string.localized.meSectorMyWhyWeeklyChoicesTitle().uppercased(),
            myToBeVisionTitle: R.string.localized.meSectorMyWhyVisionTitle().uppercased()
        )
    }
}

final class MyUniverseViewController: UIViewController, FullScreenLoadable {

    @IBOutlet private weak var navBar: UINavigationBar! // FIXME: Remove nav bar from xib and place self in UINavigationController
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet weak var navItem: NavigationItem!
    private var config: Config
    let pageTracker: PageTracker
    private var pageNumber: Int {
        var pageNumber = 0
        var pageOffset: CGFloat = 0
        for (index, page) in config.pages.enumerated() {
            if scrollView.contentOffset.x > pageOffset {
                pageOffset += scrollView.frame.size.width * page.widthPercentage
            } else {
                pageNumber = index
                break
            }
        }
        return pageNumber
    }

    let contentView: MyUniverseContentView = {
        let nib = R.nib.myUniverseContentView()
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? MyUniverseContentView else {
            fatalError("error loading \(MyUniverseContentView.self)")
        }
        return view
    }()
    weak var delegate: MyUniverseViewControllerDelegate?
    var loadingView: BlurLoadingView?
    var isLoading: Bool = false {
        didSet {
            showLoading(isLoading, text: config.loadingText)
        }
    }
    var pageName: PageName {
        return config.pages[pageNumber].pageName
    }
    var viewData: MyUniverseViewData {
        didSet {
            guard view != nil else { return } // check to see if view has loaded
            reload()
        }
    }

    init(config: Config, viewData: MyUniverseViewData, pageTracker: PageTracker) {
        self.config = config
        self.viewData = viewData
        self.pageTracker = pageTracker
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        reload()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        setupScrollViewContent()
        updateAlphaValues()
        contentView.setupMyData(for: viewData.sectors)
    }

    func scrollToPageNumber(_ number: Int, animated: Bool) {
        guard number < config.pages.count else { return }
        let offset: CGFloat
        switch number {
        case 0: offset = 0
        case 1: offset = config.pages[1].widthPercentage * scrollView.bounds.width
        default:
            assertionFailure("more than 2 pages is unhandled / untested / unexpected")
            offset = config.pages[1..<number].reduce(0, {
                $0 + $1.widthPercentage * scrollView.bounds.width
            })
        }
        scrollView.setContentOffset(CGPoint(
            x: offset,
            y: scrollView.contentOffset.y
        ), animated: animated)
    }
}

// MARK: - private

private extension MyUniverseViewController {

    func reload() {
        isLoading = viewData.isLoading
        contentView.profileButton.kf.setBackgroundImage(
            with: viewData.profileImageURL,
            for: .normal,
            placeholder: config.profileImagePlaceholder) { [weak self] (image, _, _, _) in
                guard let `self` = self, let image = image else { return }
                DispatchQueue.global(qos: .userInitiated).async {
                    let processed = UIImage.makeGrayscale(image)
                    DispatchQueue.main.async {
                        self.contentView.profileButtonOverlay.image = processed
                    }
                }
        }

        for (index, partner) in viewData.partners.enumerated() {
            guard let partnerButtons = contentView.partnerButtons,
                index < contentView.partnerButtons.count,
                index >= partnerButtons.startIndex,
                index <= partnerButtons.endIndex else {
                    break
            }
            contentView.partnerButtons[index].configure(for: partner, placeholder: config.partnerImagePlaceholder)
        }

        for (index, weeklyChoice) in viewData.weeklyChoices.enumerated() {
            guard let weeklyChoiceButtons = contentView.weeklyChoiceButtons,
                index >= weeklyChoiceButtons.startIndex,
                index <= weeklyChoiceButtons.endIndex else {
                    break
            }
            contentView.weeklyChoiceButtons[index].configure(for: weeklyChoice)
        }
        contentView.setVisionText(viewData.myToBeVisionText)
        contentView.setVisionHeadline(viewData.myToBeVisionHeadline)
        contentView.setupMyData(for: viewData.sectors)
    }

    func setupView() {
        // scroll view
        automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        scrollView.addSubview(contentView)

        // content view
        contentView.delegate = self
        contentView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(contentViewTapped(_:)))
        )
        contentView.backgroundImageView.image = config.backgroundImage
        contentView.partnersTitleLabel.text = config.partnersTitle
        contentView.weeklyChoiceButtons.forEach {
            $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        contentView.weeklyChoicesTitleLabel.text = config.weeklyChoicesTitle
        contentView.visionTypeLabel.text = config.myToBeVisionTitle

        // top bar
        navBar.applyDefaultStyle()
        navItem.delegate = self
        navItem.configure(leftButton: UIBarButtonItem.info,
                          rightButton: UIBarButtonItem(withImage: R.image.ic_menu()),
                          tabTitles: config.pages.map { $0.pageTitle },
                          style: .dark)
        contentView.partnerButtons.forEach { $0.applyHexagonMask() }
        contentView.partnerButtons.forEach { $0.setBackgroundImage(config.partnerImagePlaceholder, for: .normal) }
    }

    func setupScrollViewContent() {
        // set scrollView content size
        let contentSize = CGSize(
            width: config.pages.reduce(0.0, { $0 + scrollView.bounds.width * $1.widthPercentage }),
            height: scrollView.bounds.height
        )
        if scrollView.contentSize != contentSize {
            scrollView.contentSize = contentSize
        }

        // set contentView frame
        let frame = CGRect(
            origin: scrollView.frame.origin,
            size: contentSize
        )
        if contentView.frame != frame {
            contentView.frame = frame
            contentView.layoutIfNeeded()
        }
    }

    func updateAlphaValues() {
        let alpha = scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.bounds.width)
        let inverseAlpha = 1 - alpha
        let normalizedAlpha = max(inverseAlpha, 0.45)
        contentView.visionLine.opacity = Float(alpha)
        contentView.weeklyChoicesLine.opacity = Float(alpha)
        contentView.partnersLine.opacity = Float(alpha)
        contentView.profileButtonOverlay.alpha = inverseAlpha
        contentView.visionWrapperView.alpha = alpha
        contentView.partnersWrapperView.alpha = alpha
        contentView.weeklyChoicesWrapperView.alpha = alpha
        contentView.sectors.forEach { $0.label.alpha = inverseAlpha }
        contentView.sectors.forEach { $0.lines.forEach { $0.layer.opacity = Float(normalizedAlpha) } }
        contentView.sectors.forEach { $0.lines.forEach { $0.point.layer.opacity = Float(normalizedAlpha) } }
    }
}

// MARK: - actions

private extension MyUniverseViewController {

    @objc func contentViewTapped(_ sender: UIGestureRecognizer) {
        guard pageNumber == 0 else { return }
        let point = sender.location(in: contentView)
        for dataSector in contentView.sectors {
            if dataSector.contains(point) {
                delegate?.myUniverseViewController(self, didTap: dataSector.type)
                break
            }
        }
    }
}

// MARK: - MyUniverseContentViewDelegate

extension MyUniverseViewController: MyUniverseContentViewDelegate {

    func myUniverseContentViewDidTapProfile(_ viewController: MyUniverseContentView) {
        delegate?.myUniverseViewControllerDidTapVision(self)
    }

    func myUniverseContentViewDidTapWeeklyChoice(_ viewController: MyUniverseContentView, at index: Int) {
        delegate?.myUniverseViewController(self, didTapWeeklyChoiceAt: index)
    }

    func myUniverseContentViewDidTapPartner(_ viewController: MyUniverseContentView, at index: Int) {
        delegate?.myUniverseViewController(self, didTapQOTPartnerAt: index)
    }
}

// MARK: - ScrollViewDelegate

extension MyUniverseViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateAlphaValues()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        navItem.setIndicatorToButtonIndex(pageNumber)
        pageTracker.track(self)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageTracker.track(self)
    }
}

// MARK: - TopNavigationBarDelegate

extension MyUniverseViewController: NavigationItemDelegate {

    func navigationItem(_ navigationItem: NavigationItem, leftButtonPressed button: UIBarButtonItem) {
        delegate?.myUniverseViewController(self, didTapLeftBarButtonItem: button, in: navigationItem)
    }

    func navigationItem(_ navigationItem: NavigationItem, middleButtonPressedAtIndex index: Int, ofTotal total: Int) {
        scrollToPageNumber(index, animated: true)
    }

    func navigationItem(_ navigationItem: NavigationItem, rightButtonPressed button: UIBarButtonItem) {
        delegate?.myUniverseViewController(self, didTapRightBarButtonItem: button, in: navigationItem)
    }
}

// MARK: - UIButton

private extension UIButton {

    func configure(for partner: MyUniverseViewData.Partner, placeholder: UIImage?) {
        if let url = partner.imageURL {
            setTitle(nil, for: .normal)
            kf.setBackgroundImage(with: url, for: .normal, placeholder: placeholder)
        } else if partner.initials.isEmpty == false {
            setBackgroundImage(R.image.partnerEmpty(), for: .normal)
            setTitle(partner.initials, for: .normal)
        } else {
            setTitle(nil, for: .normal)
            setBackgroundImage(placeholder, for: .normal)
        }
    }

    func configure(for weeklyChoice: WeeklyChoice) {
        setTitle(weeklyChoice.title?.uppercased(), for: .normal)
    }
}
