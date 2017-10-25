//
//  MyDataSectorLabelsView.swift
//  QOT
//
//  Created by karmic on 15.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class MyDataSectorLabelsView: UIView, MyUniverseView {
    // MARK: - Properties

    var sectorLabels = [SectorLabel]()
    var previousBounds = CGRect.zero
    fileprivate var sectors = [Sector]()
    let screenType: MyUniverseViewController.ScreenType

    // MARK: - Init

    init(sectors: [Sector], frame: CGRect, screenType: MyUniverseViewController.ScreenType) {
        self.sectors = sectors
        self.screenType = screenType

        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout Subviews

    override func layoutSubviews() {
        super.layoutSubviews()

        cleanUpAndDraw()
    }

    func draw() {
        let layout = Layout.MeSection(viewControllerFrame: bounds)
        
        sectors.forEach { (sector: Sector) in
            let label = UILabel()
            label.attributedText = MyUniverseHelper.attributedString(for: sector, layout: layout, screenType: screenType)
            label.numberOfLines = 0
            label.textAlignment = .center
            label.sizeToFit()

            let distanceFromCenter = MyUniverseHelper.radius(for: sector.labelType.load, layout: layout)
            label.center = layout.loadCenter.shifted(distanceFromCenter, with: sector.labelType.angle(for: sector))
            addSubview(label)

            sectorLabels.append(
                SectorLabel(label: label, sector: sector)
            )
        }
    }

    func labelForPoint(_ point: CGPoint) -> SectorLabel? {
        for sectorLabel in sectorLabels {
            if sectorLabel.label.frame.contains(point) {
                return sectorLabel
            }
        }
        return nil
    }
}
