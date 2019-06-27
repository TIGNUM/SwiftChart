//
//  ThoughtsViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 24.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class ThoughtsViewController: UIViewController {

    // MARK: - Properties

    var interactor: ThoughtsInteractorInterface?
    private var model = [ThoughtsModel]()
    private var arrayOfThoughts: [String?] = []
    private var arrayOfAuthors: [String?] = []
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var thoughtsLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .carbonDark
        thoughtsLabel.textColor = .sand
        interactor?.listOfThoughts(completion: { [weak self] (items) in
            self?.arrayOfThoughts = items
        })
        interactor?.listOfAuthors(completion: { [weak self] (array) in
            self?.arrayOfAuthors = array
            self?.createModel()
            self?.createRandomThought()
        })
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

// MARK: - Private

private extension  ThoughtsViewController {

    func createModel() {
        for i in 0 ..< arrayOfThoughts.count {
            self.model.append(ThoughtsModel(thought: arrayOfThoughts[i], author: arrayOfAuthors[i]))
        }
    }

    func createRandomThought() {
        let randomThought: ThoughtsModel? = model.randomElement()
        thoughtsLabel.text = randomThought?.thought
        authorLabel.text = randomThought?.author
    }
}
// MARK: - ThoughtsViewControllerInterface

extension  ThoughtsViewController: ThoughtsViewControllerInterface {

}
