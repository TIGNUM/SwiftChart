//
//  TeamToBeVisionNavigationBarView.swift
//  QOT
//
//  Created by Anais Plancoulaine on 20.07.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol TeamToBeVisionNavigationBarViewProtocol: class {
    func didShare()
}

final class TeamToBeVisionNavigationBarView: UIView {

    weak var delegate: TeamToBeVisionNavigationBarViewProtocol?

    @IBOutlet private var title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .carbon
        title.text = AppTextService.get(.my_qot_my_tbv_section_navigation_bar_title)
    }

    @IBAction func shareButtonAction(_ sender: UIButton) {
        delegate?.didShare()
    }

}
