//
//  MyVisionNullStateView.swift
//  QOT
//
//  Created by Ashish Maheshwari on 20.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

protocol MyVisionNullStateViewProtocol: class {
    func editMyVisionAction()
    func autogenerateMyVisionAction()
}

final class MyVisionNullStateView: UIView {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var toBeVisionLabel: UILabel!
    @IBOutlet weak var writeButton: UIButton!
    @IBOutlet weak var autoGenerateButton: UIButton!
    @IBOutlet weak var nullStateImageView: UIImageView!

    weak var delegate: MyVisionNullStateViewProtocol?

    func setupView(with header: String, message: String, writeMessage: String, delegate: MyVisionNullStateViewProtocol?) {
        self.delegate = delegate
        ThemeView.level2.apply(self)
        ThemeText.tbvSectionHeader.apply(AppTextService.get(.my_x_team_tbv_section_header_title), to: toBeVisionLabel)
        writeButton.setAttributedTitle(ThemeText.tbvButton.attributedString(writeMessage), for: .normal)
        autoGenerateButton.setAttributedTitle(ThemeText.tbvButton.attributedString(AppTextService.get(.my_qot_my_tbv_null_state_button_auto_generate)), for: .normal)
        ThemeBorder.accent40.apply(writeButton)
        ThemeBorder.accent40.apply(autoGenerateButton)
        ThemeText.tbvHeader.apply(header, to: headerLabel)
        ThemeText.tbvVision.apply(message, to: detailLabel)
    }
}

private extension MyVisionNullStateView {
    @IBAction func editMyVisionAction(_ sender: Any) {
        delegate?.editMyVisionAction()
    }

    @IBAction func autogenerateMyVisionAction() {
        delegate?.autogenerateMyVisionAction()
    }
}
