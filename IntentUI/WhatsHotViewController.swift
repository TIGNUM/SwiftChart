//
//  WhatsHotViewController.swift
//  IntentUI
//
//  Created by Javier Sanz Rozalén on 12.02.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import Intents

@available(iOSApplicationExtension 12.0, *)
final class WhatsHotViewController: UIViewController {
    
    // MARK: - Properties
    
    private let intentResponse: WhatsHotIntentResponse
    @IBOutlet private weak var whatsHotView: WhatsHotView!

    // MARK: - Init

    init(for response: WhatsHotIntentResponse) {
        self.intentResponse = response
        super.init(nibName: "WhatsHotView", bundle: Bundle(for: WhatsHotViewController.self))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        whatsHotView.configure(areAllRead: intentResponse.code == .noNewArticles,
                               firstArticleImageURL: intentResponse.firstArticleImageURL,
                               firstArticleTitle: intentResponse.firstArticleTitle,
                               firstArticleTime: intentResponse.firstArticleDuration ?? "",
                               firstArticleAuthor: intentResponse.firstArticleAuthor ?? "",
                               secondArticleImageURL: intentResponse.secondArticleImageURL,
                               secondArticleTitle: intentResponse.secondArticleTitle,
                               secondArticleTime: intentResponse.secondArticleDuration ?? "",
                               secondArticleAuthor: intentResponse.secondArticleAuthor ?? "")
    }
}

final class WhatsHotView: UIView {

    // MARK: - Properties

    @IBOutlet private weak var firstArticleView: UIView!
    @IBOutlet private weak var firstArticleImageView: UIImageView!
    @IBOutlet private weak var firstArticleTitleLabel: UILabel!
    @IBOutlet private weak var firstArticleTimeAndAuthorLabel: UILabel!
    @IBOutlet private weak var secondArticleView: UIView!
    @IBOutlet private weak var secondArticleImageView: UIImageView!
    @IBOutlet private weak var secondArticleTitleLabel: UILabel!
    @IBOutlet private weak var secondArticleTimeAndAuthorLabel: UILabel!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    // MARK: - Setup

    func setupView() {
        firstArticleImageView.layer.cornerRadius = 6
        secondArticleImageView.layer.cornerRadius = 6
        firstArticleImageView.layer.masksToBounds = true
        secondArticleImageView.layer.masksToBounds = true
    }

    // MARK: - Configuration

    func configure(areAllRead: Bool,
                   firstArticleImageURL: URL?,
                   firstArticleTitle: String?,
                   firstArticleTime: String,
                   firstArticleAuthor: String,
                   secondArticleImageURL: URL?,
                   secondArticleTitle: String?,
                   secondArticleTime: String,
                   secondArticleAuthor: String) {
        if areAllRead == false {
            firstArticleImageView.setImage(from: firstArticleImageURL, placeholder: nil)
            firstArticleTitleLabel.text = firstArticleTitle
            firstArticleTimeAndAuthorLabel.text = firstArticleTime.lowercased() + " by " + firstArticleAuthor
            if secondArticleTitle == nil && secondArticleImageURL == nil {
                secondArticleView.isHidden = true
                bounds = firstArticleView.bounds
            } else {
                secondArticleImageView.setImage(from: secondArticleImageURL, placeholder: nil)
                secondArticleTitleLabel.text = secondArticleTitle
                secondArticleTimeAndAuthorLabel.text = secondArticleTime.lowercased() + " by " + secondArticleAuthor
            }
        }
    }
}
