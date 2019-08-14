//
//  MeAtMyBestEmptyCell.swift
//  QOT
//
//  Created by Srikanth Roopa on 12.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MeAtMyBestEmptyCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var intro: UILabel!
    @IBOutlet private weak var buttonText: UIButton!
    var delegate: DailyBriefViewControllerDelegate?

    @IBAction func presentTBV(_ sender: Any) {
        delegate?.presentMyToBeVision()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }

    func setUp() {
        buttonText?.corner(radius: Layout.cornerRadius20, borderColor: .accent)
    }

    func configure(with: MeAtMyBestCellEmptyViewModel?) {
        title.text = with?.title
        intro.text = with?.intro
        buttonText.setTitle(with?.buttonText, for: .normal)
    }
}
