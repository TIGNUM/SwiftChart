//
//  Badge.swift
//  QOT
//
//  Created by Lee Arromba on 08/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import BadgeSwift
import Anchorage

final class Badge: BadgeSwift {

    enum BadgeType {
        case guide(parent: UIView, frame: CGRect)
        case learn(parent: UIView, frame: CGRect)
        case whatsHot(parent: UIView, frame: CGRect)
    }

    // MARK: - Init

    convenience init(_ badgeType: BadgeType, badgeValue: Int) {
        self.init(frame: .zero)
        setPosition(badgeType)
        update(badgeValue)
    }

    convenience init(_ badgeType: BadgeType) {
        self.init(frame: .zero)
        setPosition(badgeType)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

extension Badge {

    func update(_ badgeValue: Int) {
        isHidden = badgeValue <= 0
        text = formatBadgeValue(badgeValue)
    }
}

// MARK: - Private

private extension Badge {

    func formatBadgeValue(_ value: Int) -> String {
        return NSString(format: "%.0d", value) as String
    }

    func setup() {
        insets = CGSize(width: 2, height: 2)
        badgeColor = .cherryRed
        textColor = .white
        borderColor = .white
        borderWidth = 1
        font = UIFont.preferredFont(forTextStyle: .footnote)
    }

    func setPosition(_ badgeType: BadgeType) {
        switch badgeType {
        case .guide(let parent, let frame): positionGuideBadge(parent, frame: frame)
        case .learn(let parent, let frame): positionLearnBadge(parent, frame: frame)
        case .whatsHot(let parent, let frame): positionWhatsHotBadge(parent, frame: frame)
        }
    }

    func positionLearnBadge(_ parent: UIView, frame: CGRect) {
        parent.addSubview(self)
        topAnchor == parent.topAnchor - Layout.padding_12
        trailingAnchor == parent.trailingAnchor - Layout.padding_5
    }

    func positionGuideBadge(_ parent: UIView, frame: CGRect) {
        parent.addSubview(self)
        topAnchor == parent.topAnchor - Layout.padding_12
        trailingAnchor == parent.trailingAnchor - Layout.padding_5
    }

    func positionWhatsHotBadge(_ parent: UIView, frame: CGRect) {
        parent.addSubview(self)
        topAnchor == parent.topAnchor - Layout.padding_12
        trailingAnchor == parent.trailingAnchor + Layout.padding_12
    }
}
