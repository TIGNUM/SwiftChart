//
//  MyDataHeatMapLegendTableViewCell.swift
//  QOT
//
//  Created by Voicu on 21.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyDataHeatMapLegendTableViewCell: MyDataBaseTableViewCell {
    // MARK: - Properties

    @IBOutlet private weak var topColorView: UIView!
    @IBOutlet private weak var bottomColorView: UIView!
    @IBOutlet private weak var topColorLabel: UILabel!
    @IBOutlet private weak var bottomColorLabel: UILabel!

    // MARK: Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        skeletonManager.addSubtitle(topColorLabel)
        skeletonManager.addSubtitle(bottomColorLabel)
        skeletonManager.addOtherView(topColorView)
        skeletonManager.addOtherView(bottomColorView)
    }

    func configure() {
        skeletonManager.hide()
        ThemeText.myDataHeatMapLegendText.apply(AppTextService.get(AppTextKey.my_qot_my_data_section_heat_map_label_heatmap_high), to: topColorLabel)
        ThemeText.myDataHeatMapLegendText.apply(AppTextService.get(AppTextKey.my_qot_my_data_section_heat_map_label_heatmap_low), to: bottomColorLabel)
        ThemeView.myDataHeatMapLegendHigh.apply(topColorView)
        ThemeView.myDataHeatMapLegendLow.apply(bottomColorView)
    }
}
