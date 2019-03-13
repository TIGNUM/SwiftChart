//
//  DailyPrepViewController.swift
//  IntentUI
//
//  Created by Javier Sanz Rozalén on 19.02.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import Intents

@available(iOSApplicationExtension 12.0, *)
final class DailyPrepViewController: UIViewController {

    // MARK: - Properties

    private let intentResponse: DailyPrepIntentResponse
    @IBOutlet private weak var dailyPrepView: DailyPrepView!

    // MARK: - Init

    init(for response: DailyPrepIntentResponse) {
        self.intentResponse = response
        super.init(nibName: "DailyPrepView", bundle: Bundle(for: DailyPrepView.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        dailyPrepView.configure(loadValue: intentResponse.loadValue?.floatValue,
                                recoveryValue: intentResponse.recoveryValue?.floatValue,
                                feedback: intentResponse.feedback)
    }
}

final class DailyPrepView: UIView {

    // MARK: - Properties

    @IBOutlet private weak var loadProgressView: GuideProgressView!
    @IBOutlet private weak var recoveryProgressView: GuideProgressView!
    @IBOutlet private weak var feedbackLabel: UILabel!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        loadProgressView.setGradient(with: [.recoveryGreen, .recoveryRed], progressColor: .lightGray)
        recoveryProgressView.setGradient(with: [.recoveryRed, .recoveryGreen], progressColor: .lightGray)
    }

    // MARK: - Configuration

    func configure(loadValue: Float?, recoveryValue: Float?, feedback: String?) {
        if let loadValue = loadValue, let recoveryValue = recoveryValue {
            loadProgressView.setProgress(inverted(loadValue), animated: true)
            recoveryProgressView.setProgress(inverted(recoveryValue), animated: true)
            feedbackLabel.text = feedback
        }
    }

    private func inverted(_ value: Float) -> Float {
        let maxAnswerValue: Float = 10
        return (maxAnswerValue - value) / maxAnswerValue
    }
}
