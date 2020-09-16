//
//  TeamToBeVisionOptionTableViewCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 15.09.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation

final class TeamToBeVisionOptionTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ctaButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundView = UIView(frame: self.bounds)
        self.selectedBackgroundView = UIView(frame: self.bounds)
        ThemeView.level2Selected.apply(selectedBackgroundView!)
    }

    func configure(title: String, cta: String) {
        titleLabel.text = title
        ctaButton.setTitle(cta, for: .normal)
    }
    
}
