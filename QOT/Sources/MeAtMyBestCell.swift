//
//  MeAtMyBestCell.swift
//  QOT
//
//  Created by Srikanth Roopa on 30.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MeAtMyBestCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var meAtMyBestTitle: UILabel!
    @IBOutlet private weak var meAtMyBestLabel: UILabel!
    @IBOutlet private weak var meAtMyBestContent: UILabel!
    @IBOutlet private weak var meAtMyBestFuture: UILabel!
    @IBOutlet private weak var meAtMyBestButtonText: UIButton!
    var delegate: DailyBriefViewControllerDelegate?

    @IBAction func presentTBV(_ sender: Any) {
        delegate?.presentMyToBeVision()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }

    func setUp() {
        meAtMyBestButtonText.corner(radius: Layout.cornerRadius20, borderColor: .accent)
    }

    func configure(with viewModel: MeAtMyBestCellViewModel?) {
        meAtMyBestTitle.text = viewModel?.title
        meAtMyBestLabel.text = viewModel?.intro
        meAtMyBestContent.text = viewModel?.tbvStatement
        meAtMyBestFuture.text = viewModel?.intro2
        meAtMyBestButtonText.setTitle(viewModel?.buttonText, for: .normal)
    }
}
