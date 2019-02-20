//
//  ReadVisionViewController.swift
//  IntentUI
//
//  Created by Javier Sanz Rozalén on 08.02.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import Intents

final class ReadVisionViewController: UIViewController {

    // MARK: - Properties

    private let intentResponse: ReadVisionIntentResponse
    @IBOutlet private weak var readVisionView: ReadVisionView!

    // MARK: - Init

    init(for response: ReadVisionIntentResponse) {
        self.intentResponse = response
        super.init(nibName: "ReadVisionView", bundle: Bundle(for: ReadVisionViewController.self))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        readVisionView.configure(imageURL: intentResponse.imageURL,
                                 headline: intentResponse.headline,
                                 text: intentResponse.vision)
    }
}

// MARK: - ReadVisionView

final class ReadVisionView: UIView {

    // MARK: - Properties

    @IBOutlet private weak var visionImageView: UIImageView!
    @IBOutlet private weak var headlineLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!

    // MARK: - Configuration

    func configure(imageURL: URL?, headline: String?, text: String?) {
        visionImageView.setImage(from: imageURL, placeholder: UIImage(named: "tbv_placeholder"))
        headlineLabel.text = headline ?? "MY HEADLINE"
        textLabel.text = text
    }
}
