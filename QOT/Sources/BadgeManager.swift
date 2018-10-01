//
//  BadgeManager.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 22/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import ReactiveKit

final class BadgeManager {

    // MARK: - Properties

    private let tokenBin = TokenBin()
    private let services: Services
    private var guideBadge: Badge?
    private var learnBadge: Badge?
    private var whatsHotBadge: Badge?
    private var newGuideItems = [Guide.Item]()

    var guideBadgeContainer: (view: UIView, frame: CGRect) = (view: UIView(), frame: .zero) {
        didSet {
            let badgeType = Badge.BadgeType.guide(parent: guideBadgeContainer.view,
                                                  frame: guideBadgeContainer.frame)
            guideBadge = Badge(badgeType, badgeValue: newGuideItems.count)
        }
    }

    var learnBadgeContainer: (view: UIView, frame: CGRect) = (view: UIView(), frame: .zero) {
        didSet {
            let badgeType = Badge.BadgeType.learn(parent: learnBadgeContainer.view,
                                                  frame: learnBadgeContainer.frame)
            learnBadge = Badge(badgeType, badgeValue: badgeValueWhatsHot)
        }
    }

    var whatsHotBadgeContainer: (view: UIView, frame: CGRect) = (view: UIView(), frame: .zero) {
        didSet {
            let badgeType = Badge.BadgeType.whatsHot(parent: whatsHotBadgeContainer.view,
                                                     frame: whatsHotBadgeContainer.frame)
            whatsHotBadge = Badge(badgeType, badgeValue: badgeValueWhatsHot)
        }
    }

    var tabDisplayed: TabBar = .guide {
        didSet {
            update()
        }
    }

    // MARK: - Init

    init(services: Services) {
        self.services = services
        observeWhatsHotArticleUpdates()
    }

    func updateWhatsHotBadge(isHidden: Bool) {
        if newWhatsHotArticles.count == 0 {
            whatsHotBadge?.isHidden = true
        } else {
            whatsHotBadge?.isHidden = isHidden
        }
    }

    func updateGuideBadgeValue(newGuideItems: [Guide.Item]) {
        var todaysDailyPrep: Guide.Item?
        let dialyPrepItems = newGuideItems.filter { $0.isDailyPrep == true }
        dialyPrepItems.forEach { (guideItem: Guide.Item) in
            let dateStirng = guideItem.identifier.replacingOccurrences(of: NotificationID.Prefix.dailyPrep.rawValue + "#", with: "")
            if DateFormatter.dialyPrep.date(from: dateStirng)?.isSameDay(Date()) == true {
                todaysDailyPrep = guideItem
            }
        }
        self.newGuideItems = newGuideItems.filter { $0.isDailyPrep == false }
        if let todaysDailyPrep = todaysDailyPrep, self.newGuideItems.contains(todaysDailyPrep) == false {
            self.newGuideItems.append(todaysDailyPrep)
        }
        guideBadge?.update(self.newGuideItems.count)
        guideBadge?.isHidden = tabDisplayed == .guide || self.newGuideItems.isEmpty
        UserDefault.guideBadgeNumber.setDoubleValue(value: Double(self.newGuideItems.count))
    }
}

// MARK: - Private

private extension BadgeManager {

    var newWhatsHotArticles: Results<ContentCollection> {
        return services.contentService.whatsHotArticlesNew()
    }

    var badgeValueWhatsHot: Int {
        return newWhatsHotArticles.count
    }

    func observeWhatsHotArticleUpdates() {
        tokenBin.addToken(newWhatsHotArticles.observe { [weak self] changes in
            switch changes {
            case .update(let articles, _, _, _):
                self?.whatsHotBadge?.update(articles.count)
                self?.learnBadge?.update(articles.count)
                self?.whatsHotBadge?.isHidden = self?.whatsHotBadge?.isHidden ?? true
                self?.learnBadge?.isHidden = self?.tabDisplayed == .learn
                UserDefault.whatsHotBadgeNumber.setDoubleValue(value: Double(articles.count))
            default: break
            }
        })
    }

    func update() {
        switch tabDisplayed {
        case .guide:
            guideBadge?.isHidden = true
            learnBadge?.isHidden = badgeValueWhatsHot == 0
        case .learn:
            guideBadge?.isHidden = newGuideItems.isEmpty
            learnBadge?.isHidden = true
        case .me, .prepare:
            guideBadge?.isHidden = newGuideItems.isEmpty
            learnBadge?.isHidden = badgeValueWhatsHot == 0
        }
    }
}
