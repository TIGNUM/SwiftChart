//
//  SolveTableViewCelll.swift
//  QOT
//
//  Created by Anais Plancoulaine on 12.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

import UIKit

final class SolveTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    weak var delegate: DailyBriefViewControllerDelegate?
    private var solve: QDMSolve?

    override func awakeFromNib() {
        super.awakeFromNib()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.accent.cgColor
        button.corner(radius: 20)
    }

    func configure(title: String?, date: String?, solve: QDMSolve?) {
        titleLabel.text = title?.uppercased()
        dateLabel.text = date
        self.solve = solve

    }

    @IBAction func checkIt(_ sender: Any) {
        if let solve = solve {
        delegate?.showSolveResults(solve: solve)
        }
    }
}
