//
//  MorningInterviewCell.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 6/28/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

protocol MorningInterviewCellDelegate: class {
    func didSelectAnswer(index: Int, cell: MorningInterviewCell)
}

final class MorningInterviewCell: UICollectionViewCell, Dequeueable {
    
    fileprivate var topview: UIView = UIView()
    fileprivate var centerView: UIView = UIView()
    fileprivate var bottomView: UIView = UIView()
    fileprivate var numberlabel: UILabel = UILabel()
    fileprivate var subTitleLabel: UILabel = UILabel()
    fileprivate var maxLabel: UILabel = UILabel()
    fileprivate var question: MorningInterviewViewModel.Question?
    weak var delegate: MorningInterviewCellDelegate?

    fileprivate var titlelabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.5
        return label
    }()

    fileprivate var slider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = .white
        slider.maximumTrackTintColor = .gray
        slider.minimumValue = 0
        return slider
    }()

    @objc func valueChanged(sender: UISlider) {
        guard let question = question else {
            return
        }
        let index = Int(sender.value.rounded())
        let answer = question.answers[index]
        numberlabel.attributedText = Style.num(String(index), .white).attributedString(lineSpacing: -3.3)
        setup(answer: answer)
    }

    @objc func valueDidChange(sender: UISlider) {
        let index = Int(sender.value.rounded())
        delegate?.didSelectAnswer(index: index, cell: self)
    }

    fileprivate var minLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white90
        label.font = .bentonBookFont(ofSize: 11)
        label.textAlignment = .center
        label.text = "0"
        return label
    }()

    func configure(question: MorningInterviewViewModel.Question, answerIndex: Int? = 0) {
        setupHierarchy()
        setupLayout()
        self.question = question
        if let answerIndex = answerIndex {
            let answer = question.answers[answerIndex]
            let attributedTitle = NSMutableAttributedString(
                string: answer.title,
                letterSpacing: -3.3,
                font: Font.H0Number,
                textColor: .white,
                alignment: .center
            )
            let attributedSubtitle = NSMutableAttributedString(
                string: answer.subtitle,
                letterSpacing: 3.3,
                font: Font.H8Subtitle,
                textColor: .white60,
                alignment: .center
            )
            numberlabel.attributedText = attributedTitle
            subTitleLabel.attributedText = attributedSubtitle
        }
        slider.maximumValue = Float(question.answers.count - 1)
        let text = String(question.answers.count - 1)
        maxLabel.attributedText = Style.tag(text, .white90).attributedString(lineSpacing: 2)
        let attributedTitle = NSMutableAttributedString(
            string: question.title,
            letterSpacing: 1.1,
            font: Font.H9Title,
            textColor: .white90,
            alignment: .center
        )
        titlelabel.attributedText = attributedTitle
    }
}

private extension MorningInterviewCell {

    func setupHierarchy() {
        addSubview(topview)
        topview.addSubview(titlelabel)
        addSubview(centerView)
        centerView.addSubview(numberlabel)
        centerView.addSubview(subTitleLabel)
        addSubview(bottomView)
        bottomView.addSubview(slider)
        bottomView.addSubview(minLabel)
        bottomView.addSubview(maxLabel)
        slider.addTarget (self, action: #selector(valueChanged), for: .valueChanged)
    }

    func setupLayout() {

        topview.topAnchor == topAnchor
        topview.leftAnchor == leftAnchor + 49
        topview.rightAnchor == rightAnchor - 49
        topview.heightAnchor == bottomView.heightAnchor

        titlelabel.topAnchor == topview.topAnchor + 20
        titlelabel.horizontalAnchors == topview.horizontalAnchors
        titlelabel.bottomAnchor == topview.bottomAnchor

        centerView.topAnchor == topview.bottomAnchor
        centerView.horizontalAnchors == horizontalAnchors
        centerView.heightAnchor == 150

        numberlabel.topAnchor == centerView.topAnchor + 10
        numberlabel.horizontalAnchors == centerView.horizontalAnchors
        numberlabel.heightAnchor == 110

        subTitleLabel.topAnchor == numberlabel.bottomAnchor - 25
        subTitleLabel.horizontalAnchors == centerView.horizontalAnchors
        subTitleLabel.bottomAnchor == centerView.bottomAnchor

        bottomView.topAnchor == centerView.bottomAnchor
        bottomView.horizontalAnchors == horizontalAnchors
        bottomView.bottomAnchor == bottomAnchor

        minLabel.leftAnchor == bottomView.leftAnchor + 35
        minLabel.widthAnchor == 7
        minLabel.topAnchor == bottomView.topAnchor - 10
        minLabel.bottomAnchor == bottomView.bottomAnchor

        slider.leftAnchor == minLabel.rightAnchor + 25
        slider.topAnchor == bottomView.topAnchor - 10
        slider.bottomAnchor == bottomView.bottomAnchor
        slider.rightAnchor == maxLabel.leftAnchor - 18

        maxLabel.widthAnchor == 7
        maxLabel.rightAnchor == bottomView.rightAnchor - 32
        maxLabel.topAnchor == bottomView.topAnchor - 10
        maxLabel.bottomAnchor == bottomView.bottomAnchor
    }

    func setup(answer: MorningInterviewViewModel.Answer ) {

        let attributedTitle = NSMutableAttributedString(
            string: answer.title,
            letterSpacing: -3.3,
            font: Font.H0Number,
            textColor: .white,
            alignment: .center
        )

        let attributedSubtitle = NSMutableAttributedString(
            string: answer.subtitle,
            letterSpacing: 3.3,
            font: Font.H8Subtitle,
            textColor: .white60,
            alignment: .center
        )
        numberlabel.attributedText = attributedTitle
        subTitleLabel.attributedText = attributedSubtitle
    }
}
