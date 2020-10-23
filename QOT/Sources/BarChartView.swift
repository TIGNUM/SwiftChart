//
//  DrawChartsView.swift
//  QOT
//
//  Created by Anais Plancoulaine on 28.09.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal
import UIKit

struct BarEntry {
    let scoreIndex: Int
    let votes: Int
    let isMyVote: Bool
}

class BarChartView: UIView {

    private let mainLayer: CALayer = CALayer()
    private let space: CGFloat = 18.0
    private let barHeight: CGFloat = 16.0
    private let contentSpace: CGFloat = 120.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
     }
     required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
     }

     private func setupView() {
         self.layer.addSublayer(mainLayer)
     }

    var dataEntries: [BarEntry] = [] {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: { () -> Void in
                self.mainLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
                self.mainLayer.frame = CGRect(x: self.frame.origin.x, y: 0, width: UIScreen.main.bounds.width, height: self.frame.size.height)
                for i in 0..<self.dataEntries.count {
                    self.showEntry(index: i, entry: self.dataEntries[i])
                }
            })
        }
    }

    func percentage(_ votes: Int) -> Int {
        var totalVotes = 0
        dataEntries.forEach { (item) in
            totalVotes = totalVotes + item.votes
        }
        return (votes * 100)/totalVotes
    }

    var maxVotes: Int {
        var votesArray: [Int] = []
        dataEntries.forEach {(item) in
            votesArray.append(item.votes)
        }
        return votesArray.sorted {$0 > $1}.first ?? 0
    }

    private func showEntry(index: Int, entry: BarEntry) {
        let xPos: CGFloat = translateWidthValueToXPosition(value:
            Float(entry.votes) / Float(maxVotes))
        let yPos: CGFloat = CGFloat(index) * (barHeight + space) - 60
        let myVote =  entry.isMyVote ? entry.scoreIndex : nil
        drawBar(xPos: xPos, yPos: yPos, myVote: myVote, scoreIndex: entry.scoreIndex)
        drawDetails(xPos: UIScreen.main.bounds.width - contentSpace, yPos: yPos, votes: entry.votes, myVote: myVote, scoreIndex: entry.scoreIndex)
        drawIndex(xPos: 24, yPos: yPos, width: 30.0, scoreIndex: entry.scoreIndex, myVote: myVote)
    }

    private func drawBar(xPos: CGFloat, yPos: CGFloat, myVote: Int?, scoreIndex: Int) {
        let barLayer = CALayer()
        barLayer.frame = CGRect(x: 48, y: yPos, width: xPos, height: barHeight)
        barLayer.backgroundColor = myVote == scoreIndex ? UIColor.white.cgColor : UIColor.sand40.cgColor
        mainLayer.addSublayer(barLayer)
    }

    private func drawDetails(xPos: CGFloat, yPos: CGFloat, votes: Int, myVote: Int?, scoreIndex: Int) {
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: xPos, y: yPos - 2, width: 110, height: barHeight)
        textLayer.foregroundColor = myVote == scoreIndex ? UIColor.white.cgColor : UIColor.sand70.cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.font = UIFont.sfProtextRegular(ofSize: 12.0)
        textLayer.fontSize = 12
        let percentageString = String(percentage(votes))
        textLayer.string = AppTextService.get(.my_x_team_vision_tracker_votes)
            .replacingOccurrences(of: "${numberOfVotes}", with: String(votes))
            .replacingOccurrences(of: "${percentageString}", with: percentageString)
        mainLayer.addSublayer(textLayer)
    }

    private func drawIndex(xPos: CGFloat,
                           yPos: CGFloat,
                           width: CGFloat,
                           scoreIndex: Int,
                           myVote: Int?) {
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: xPos, y: yPos - 2, width: width, height: barHeight)
        textLayer.foregroundColor = myVote == scoreIndex ? UIColor.white.cgColor : UIColor.sand70.cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.alignmentMode = CATextLayerAlignmentMode.left
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.font = UIFont.sfProtextRegular(ofSize: 16.0)
        textLayer.fontSize = 16
        textLayer.string = String(scoreIndex)
        mainLayer.addSublayer(textLayer)
    }

    private func translateWidthValueToXPosition(value: Float) -> CGFloat {
        let width = CGFloat(value) * (mainLayer.frame.width)/2.2
        return abs(width)
    }
}
