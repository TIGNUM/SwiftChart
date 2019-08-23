//
//  MyDataChartLegendTableViewCell.swift
//  QOT
//
//  Created by Voicu on 21.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol MyDataChartLegendTableViewCellDelegate: class {
    func didTapAddButton()
}

class MyDataChartLegendTableViewCell: UITableViewCell, Dequeueable {
    // MARK: - Properties

    @IBOutlet private weak var label: UILabel!
    @IBOutlet weak var addButton: UIButton!
    weak var delegate: MyDataChartLegendTableViewCellDelegate?

    // MARK: Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        addButton.layer.cornerRadius = 20.0
        addButton.layer.borderWidth = 1.0
        addButton.layer.borderColor = UIColor.accent40.cgColor
    }

    func configure(selectionModel: MyDataSelectionModel?) {
        var labelString = ""
        guard let model = selectionModel else {
            label.text = labelString
            return
        }
        for sectionModel in  model.myDataSelectionItems {
            if let title = sectionModel.title {
                let newLine = labelString.isEmpty ? "" : "\n"
                labelString = labelString + newLine + title
            }
        }
        label.attributedText = NSAttributedString(string: labelString,
                                                       letterSpacing: 0.16,
                                                       font: .sfProtextRegular(ofSize: 11),
                                                       lineSpacing: 9,
                                                       textColor: .sand60,
                                                       alignment: .left)
    }

    // MARK: Actions

    @IBAction func didTapAddButton(_ sender: UIButton) {
        delegate?.didTapAddButton()
    }
}
