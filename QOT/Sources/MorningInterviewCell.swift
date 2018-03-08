//
//  MorningInterviewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 16/02/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

class MorningInterviewCell: UICollectionViewCell, DialSelectionDelegate, Dequeueable {

    @IBOutlet private weak var dialView: InterviewDialView!
    let centerLabel = UILabel()
    var indexDidChange: ((_ index: Int) -> Void)?
    var didTouchUp: ((_ index: Int) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    private func setup() {
        dialView.delegate = self
        centerLabel.backgroundColor = .clear
        centerLabel.numberOfLines = 0
        centerLabel.minimumScaleFactor = 0.5
        centerLabel.adjustsFontSizeToFitWidth = true
        centerLabel.textAlignment = .center
        addSubview(centerLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let ringWidth: CGFloat = (bounds.width * 0.2)
        let innerRadius = (bounds.width - (2 * ringWidth)) / 2
        let centerLabelLength = lengthOfSquareFittingCircle(radius: innerRadius)
        dialView.updateConfig(InterviewDialView.Config(ringWidth: ringWidth))
        let centerLabelSize = CGSize(width: centerLabelLength, height: centerLabelLength)
        centerLabel.frame = CGRect(center: bounds.center, size: centerLabelSize).integral
    }

    func configure(centerLabelText: String) {
        let shadow = NSShadow()
        shadow.shadowBlurRadius = 10
        shadow.shadowColor = UIColor.white

        let attributes: [NSAttributedStringKey: Any] = [.foregroundColor: UIColor.white,
                                                        .font: Font.H5SecondaryHeadline,
                                                        .shadow: shadow]
        centerLabel.attributedText = NSAttributedString(string: centerLabelText, attributes: attributes)
    }

    func lengthOfSquareFittingCircle(radius: CGFloat) -> CGFloat {
        return sqrt(pow(radius, 2) / 2) * 2
    }

    func setSelected(index: Int) {
        dialView.setSelected(index: index)
    }

    // MARK: - DialSelectionDelegate

    func selectedIndexDidChange(_ index: Int?, view: InterviewDialView) {
        guard let index = index else { return }

        indexDidChange?(index)
    }

    func didTouchUp(index: Int?, view: InterviewDialView) {
        guard let index = index else { return }

        didTouchUp?(index)
    }
}
