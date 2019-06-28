//
//  WhatsHotLatestViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 27.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class WhatsHotLatestViewController: UIViewController {

    // MARK: - Properties

    var interactor: WhatsHotLatestInteractorInterface?
    private var model: WhatsHotLatestModel = WhatsHotLatestModel(title: "", body: "", image: nil, author: "", publisheDate: nil, timeToRead: 0, isNew: false, remoteID: 0)
    @IBOutlet private weak var whatsHotImage: UIImageView!
    @IBOutlet private var whatsHotTitle: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var dateAndDurationLabel: UILabel!
    @IBOutlet private weak var newLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .carbonDark
        newLabel.isHidden = true
        createModel()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.checkAction))
        self.view.addGestureRecognizer(gesture)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showItem()
    }
}

// MARK: - Private

private extension  WhatsHotLatestViewController {

    @objc func checkAction(sender: UITapGestureRecognizer) {
         interactor?.presentWhatsHotArticle(selectedID: model.remoteID ?? 0)
    }

    func createModel() {
         interactor?.latestWhatsHotContent(completion: { [weak self] (item) in
            self?.interactor?.getContentCollection(completion: { [weak self] (collection) in
                self?.model = WhatsHotLatestModel(title: collection?.title, body: item?.valueText, image: URL(string: collection?.thumbnailURLString ?? ""), author: collection?.author, publisheDate: item?.createdAt, timeToRead: collection?.secondsRequired, isNew: collection?.viewedAt == nil, remoteID: collection?.remoteID )
            })
        })
    }

    func showItem() {
        whatsHotImage.kf.setImage(with: model.image, placeholder: R.image.preloading())
        whatsHotTitle.text = model.title
        authorLabel.text = model.author
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        dateFormatter.dateFormat = "d. MMM"
        dateAndDurationLabel.text = dateFormatter.string(from: model.publisheDate ?? Date(timeInterval: -3600, since: Date())) + " | "  + "\((model.timeToRead ?? 0) / 60)" + " min read"
        if model.isNew == true { newLabel.isHidden = false }
    }

}
// MARK: - WhatsHotLatestViewControllerInterface

extension  WhatsHotLatestViewController: WhatsHotLatestViewControllerInterface {

}
