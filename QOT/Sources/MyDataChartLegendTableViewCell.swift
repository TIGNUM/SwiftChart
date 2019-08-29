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

final class MyDataChartLegendTableViewCell: MyDataBaseTableViewCell {
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
        var attributedString: NSMutableAttributedString = NSMutableAttributedString()
        guard let model = selectionModel else {
            label.attributedText = attributedString
            return
        }
        for sectionModel in  model.myDataSelectionItems {
            if let title = sectionModel.title {
                let attributtedTitle = NSAttributedString(string: title,
                                                          letterSpacing: 0.16,
                                                          font: .sfProtextRegular(ofSize: 11),
                                                          lineSpacing: 9,
                                                          textColor: MyDataExplanationModel.color(for: sectionModel.myDataExplanationSection),
                                                          alignment: .left)
                let newLine = attributedString.string.isEmpty ? NSAttributedString() : NSAttributedString.init(string: "\n")
                attributedString.append(newLine)
                attributedString.append(attributtedTitle)
            }
        }
        label.attributedText = attributedString
    }

    // MARK: Actions

    @IBAction func didTapAddButton(_ sender: UIButton) {
        delegate?.didTapAddButton()
    }
}
