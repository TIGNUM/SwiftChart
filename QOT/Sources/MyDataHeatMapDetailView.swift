//
//  MyDataHeatMapDetailView.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 25/08/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyDataHeatMapDetailView: UIView {
    private let animationTimeInterval = 0.2
    private let backgroundAlphaValue: CGFloat = 1.0

    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    public func setValue(_ value: Double, forDate: Date) {
        let dateText = DateFormatter.ddMM.string(from: forDate)
        ThemeText.myDataHeatMapDetailCellDate.apply(dateText, to: dateLabel)
        ThemeText.myDataHeatMapDetailCellValue.apply("\(Int(value))", to: valueLabel)
        self.alpha = 0.0
        self.backgroundColor = MyDataScreenWorker.heatMapColor(forImpactReadiness: value)
        self.valueLabel.backgroundColor = MyDataScreenWorker.heatMapColor(forImpactReadiness: value)
        UIView.animate(withDuration: animationTimeInterval) { [weak self] in
            guard let s = self else {
                return
            }
            s.alpha = s.backgroundAlphaValue
        }
    }
}
