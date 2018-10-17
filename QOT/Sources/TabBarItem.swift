//
//  TabBarItem.swift
//  QOT
//
//  Created by Lee Arromba on 20/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class TabBarItem: UITabBarItem {

    private let config: Config
    var badgeCounter = 0
    var badge: Badge?

    struct Config {
        var title: String?
        var isTitleUppercased: Bool
        var titlePositionAdjustment: UIOffset
        var normalTitleTextAttributes: [NSAttributedStringKey: Any]
        var selectedTitleTextAttributes: [NSAttributedStringKey: Any]
        var image: UIImage?
        var selectedImage: UIImage?
        var tag: Int

        static var `default` = Config(
            title: nil,
            isTitleUppercased: true,
            titlePositionAdjustment: UIOffset(horizontal: 0, vertical: 4),
            normalTitleTextAttributes: [.font: UIFont.TabBar,
                                        .foregroundColor: UIColor.white],
            selectedTitleTextAttributes: [.font: UIFont.TabBar,
                                          .foregroundColor: UIColor.azure],
            image: nil,
            selectedImage: R.image.tabBarButtonItemHighlight(),
            tag: 0
        )
    }

    init(config: Config) {
        self.config = config
        super.init()
        apply(config)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - private

    private func apply(_ config: Config) {
        title = config.isTitleUppercased ? config.title?.uppercased() : config.title
        titlePositionAdjustment = config.titlePositionAdjustment
        setTitleTextAttributes(config.normalTitleTextAttributes, for: .normal)
        setTitleTextAttributes(config.selectedTitleTextAttributes, for: .selected)
        image = config.image?.withRenderingMode(.alwaysTemplate)
        selectedImage = config.image
        tag = config.tag
    }
}
