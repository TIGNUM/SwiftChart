//
//  MyDataSectorLabelsView.swift
//  QOT
//
//  Created by karmic on 15.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class MyDataSectorLabelsView: UIView, MyUniverseViewDelegate {

    // MARK: - Properties

    var sectorLabels = [UILabel]()
    internal var previousBounds = CGRect.zero
    fileprivate var sectors = [Sector]()
    fileprivate var myUniverseViewController: MyUniverseViewController

    // MARK: - Init

    init(sectors: [Sector], frame: CGRect, myUniverseViewController: MyUniverseViewController) {
        self.sectors = sectors
        self.myUniverseViewController = myUniverseViewController

        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout Subviews

    override func layoutSubviews() {
        super.layoutSubviews()

        guard previousBounds.equalTo(bounds) == false else {
            return
        }

        cleanUp()
        previousBounds = bounds
        let layout = Layout.MeSection(viewControllerFrame: bounds)
        addSectorLabels(layout: layout, sectors: sectors)
    }
}

// MARK: - MyUniverseViewDelegate

extension MyDataSectorLabelsView {

    func cleanUp() {
        removeSubLayers()
        removeSubViews()
    }
}

// MARK: - Build Labels

private extension MyDataSectorLabelsView {

    func addSectorLabels(layout: Layout.MeSection, sectors: [Sector]) {
        sectors.forEach { (sector: Sector) in
            let labelValues = MyUniverseHelper.labelValues(for: sector, layout: layout, myUniverseViewController: myUniverseViewController)
            let labelFarme = sectorLabelFrame(sector: sector, layout: layout)
            let sectorLabel = createSectorLabel(
                frame: labelFarme,
                attributedString: labelValues.attributedString,
                widthOffset: labelValues.widthOffset
            )
            print(sectorLabel.center, sectorLabel.frame.origin)
            addSubview(sectorLabel)
            sectorLabels.append(sectorLabel)
        }
    }

    func sectorLabelFrame(sector: Sector, layout: Layout.MeSection) -> CGRect {
        let distanceFromCenter = MyUniverseHelper.radius(for: sector.labelType.load, layout: layout)
        let labelCenter = layout.loadCenter.shifted(distanceFromCenter, with: sector.labelType.angle)
        return CGRect(x: labelCenter.x, y: labelCenter.y, width: 0, height: Layout.MeSection.labelHeight)
    }

    func createSectorLabel(frame: CGRect, attributedString: NSAttributedString, widthOffset: CGFloat) -> UILabel {
        let label = UILabel(frame: frame)
        label.attributedText = attributedString
        label.numberOfLines = 0
        label.textAlignment = .center
        label.frame = CGRect(x: frame.origin.x - widthOffset, y: frame.origin.y, width: frame.width, height: Layout.MeSection.labelHeight)
        label.sizeToFit()
        return label
    }
}
