//
//  GoodToKnowViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 25.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class GoodToKnowViewController: UIViewController {

    // MARK: - Properties

    var interactor: GoodToKnowInteractorInterface?
    @IBOutlet private weak var goodToKnowLabel: UILabel!
    @IBOutlet private weak var image: UIImageView!
    private var model: [GoodToKnowModel] = []
    private var arrayOfFacts: [String?] = []
    private var arrayOfPictures: [String?] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .carbonDark
        interactor?.listOfFacts(completion: { [weak self] (items) in
            self?.arrayOfFacts = items
        })
        interactor?.listOfPictures(completion: { [weak self] (array) in
            self?.arrayOfPictures = array
            self?.createModel()
            self?.createRandomFact()
        })
    }
}

// MARK: - Private

private extension  GoodToKnowViewController {

    func createModel() {
        for i in 0 ..< arrayOfFacts.count {
        self.model.append(GoodToKnowModel(fact: arrayOfFacts[i], image: URL(string: arrayOfPictures[i] ?? "")))
        }
    }

    func createRandomFact() {
        let randomFact: GoodToKnowModel? = model.randomElement()
        goodToKnowLabel.text = randomFact?.fact
        image.kf.setImage(with: randomFact?.image, placeholder: R.image.preloading())
    }

}
// MARK: - GoodToKnowViewControllerInterface

extension  GoodToKnowViewController: GoodToKnowViewControllerInterface {

}
