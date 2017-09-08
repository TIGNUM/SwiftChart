//
//  MorningInterviewCell.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 6/28/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

final class MorningInterviewCell: UICollectionViewCell, Dequeueable {
    
    fileprivate var topview: UIView = UIView()
    fileprivate var centerView: UIView = UIView()
    fileprivate var bottomView: UIView = UIView()
    fileprivate var numberlabel: UILabel = UILabel()
    fileprivate var subTitleLabel: UILabel = UILabel()
    fileprivate var maxLabel: UILabel = UILabel()
    fileprivate var question: InterviewQuestion?

    fileprivate var titlelabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5

        return label
    }()

    fileprivate var slider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = .white
        slider.maximumTrackTintColor = .gray
        slider.isContinuous = true

        return slider
    }()

    @objc func valueChanged(sender: UISlider) {
        let index = Int(sender.value.rounded())
        guard let question = question, question.answerIndex != index else {
            return
        }

        question.answerIndex = index
        if let answer = question.currentAnswer {
            numberlabel.attributedText = Style.num(String(index), .white60).attributedString(lineSpacing: -3.3)
            setup(answer: answer)
        }
    }

    fileprivate var minLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white60
        label.font = .bentonBookFont(ofSize: 11)
        label.textAlignment = .center
        return label
    }()

    func configure(question: InterviewQuestion, defaultAnswerIndex: Int) {
        setupHierarchy()
        setupLayout()

        self.question = question
        let startIndex = question.answers.startIndex
        minLabel.attributedText = Style.tag("\(startIndex + 1)", .white60).attributedString()
        slider.minimumValue = Float(startIndex)
        slider.addTarget (self, action: #selector(valueChanged), for: .valueChanged)
        
        let endIndex = question.answers.endIndex
        slider.maximumValue = Float(endIndex - 1)
        maxLabel.attributedText = Style.tag("\(endIndex)", .white60).attributedString()

        if let answer = question.currentAnswer {
            setCurrentAnswerLabels(answer: answer)
        } else {
            setCurrentAnswerLabels(answer: question.answers[defaultAnswerIndex])
            slider.value = Float(defaultAnswerIndex)
        }

        titlelabel.attributedText = NSMutableAttributedString(
            string: question.title,
            letterSpacing: 1.1,
            font: Font.H9Title,
            lineSpacing: 2.9,
            textColor: .white90,
            alignment: .center
        )
    }

    fileprivate func setCurrentAnswerLabels(answer: Answer) {
        subTitleLabel.numberOfLines = 0
        numberlabel.attributedText = NSMutableAttributedString(
            string: answer.title,
            letterSpacing: -3.3,
            font: Font.H0Number,
            textColor: .white,
            alignment: .center
        )
        subTitleLabel.attributedText = NSMutableAttributedString(
            string: answer.subtitle ?? "",
            letterSpacing: 3.3,
            font: Font.H8Subtitle,
            lineSpacing: 2.9,
            textColor: .white60,
            alignment: .center
        )
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
    }

    func setupLayout() {
        topview.topAnchor == topAnchor
        topview.leftAnchor == leftAnchor + 40
        topview.rightAnchor == rightAnchor - 40
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
        subTitleLabel.leftAnchor == leftAnchor + 16
        subTitleLabel.rightAnchor == rightAnchor - 16
        subTitleLabel.bottomAnchor == centerView.bottomAnchor

        bottomView.topAnchor == centerView.bottomAnchor
        bottomView.horizontalAnchors == horizontalAnchors
        bottomView.bottomAnchor == bottomAnchor

        slider.leftAnchor == minLabel.rightAnchor + 25
        slider.topAnchor == bottomView.topAnchor - 10
        slider.bottomAnchor == bottomView.bottomAnchor
        slider.rightAnchor == maxLabel.leftAnchor - 18

        minLabel.leftAnchor == bottomView.leftAnchor + 35
        minLabel.centerYAnchor == slider.centerYAnchor

        maxLabel.rightAnchor == bottomView.rightAnchor - 32
        maxLabel.centerYAnchor == slider.centerYAnchor
    }

    func setup(answer: Answer ) {
        setCurrentAnswerLabels(answer: answer)
    }
}
