//
//  DailyBriefViewController.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import Anchorage
import qot_dal

final class DailyBriefNavigationController: UINavigationController {
    static var storyboardID = NSStringFromClass(DailyBriefNavigationController.classForCoder())
}

final class DailyBriefViewController: UIViewController, ScreenZLevel1, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    var delegate: CoachCollectionViewControllerDelegate?
    private var latestWhatsHotModel: WhatsHotLatestCellViewModel?
    @IBOutlet weak var tableView: UITableView!

    var interactor: DailyBriefInteractorInterface?

     // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.registerDequeueable(WhatsHotLatestCell.self)
        tableView.registerDequeueable(QuestionCell.self)
        tableView.registerDequeueable(ThoughtsCell.self)
        tableView.registerDequeueable(GoodToKnowCell.self)
        tableView.registerDequeueable(FromTignumCell.self)
        tableView.registerDequeueable(DepartureInfoCell.self)
        tableView.registerDequeueable(FeastCell.self)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.checkAction))
        self.view.addGestureRecognizer(gesture)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        CASE WHATSHOTARTICLE
        interactor?.createLatestWhatsHotModel( completion: { [weak self] (model) in
            self?.latestWhatsHotModel = model
            tableView.reloadData()
        })
        let cell: WhatsHotLatestCell = tableView.dequeueCell(for: indexPath)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.checkAction))
        cell.addGestureRecognizer(gesture)
        cell.configure(title: latestWhatsHotModel?.title,
                       image: latestWhatsHotModel?.image,
                       author: latestWhatsHotModel?.author,
                       publisheDate: latestWhatsHotModel?.publisheDate,
                       timeToRead: latestWhatsHotModel?.timeToRead,
                       isNew: latestWhatsHotModel?.isNew ?? false,
                       remoteID: latestWhatsHotModel?.remoteID ?? 0)
        cell.backgroundColor = .carbon
        return cell

        //        CASE RANDOM QUESTION
//                let cell: QuestionCell = tableView.dequeueCell(for: indexPath)
//                interactor?.randomQuestionModel(completion: { (model) in
//                    cell.configure(title: model?.text)
//                })
//                cell.backgroundColor = .carbon
//                return cell

        //        CASE THOUGHTS
        //        let cell: ThoughtsCell = tableView.dequeueCell(for: indexPath)
        //        interactor?.createThoughtsModel(completion: { (model) in
        //            cell.configure(thought: model?.thought, author: model?.author)
        //        })
        //        cell.backgroundColor = .carbon
        //        return cell

        //        CASE GOOD TO KNOW
        //        let cell: GoodToKnowCell = tableView.dequeueCell(for: indexPath)
        //        interactor?.createFactsModel(completion: { (model) in
        //            cell.configure(fact: model?.fact, image: model?.image)
        //        })
        //        cell.backgroundColor = .carbon
        //        return cell

        //        CASE FROM TIGNUM MESSAGE
        //        let cell: FromTignumCell = tableView.dequeueCell(for: indexPath)
        //        interactor?.lastMessage(completion: { (model) in
        //            cell.configure(text: model?.text)
        //            })
        //        cell.backgroundColor = .carbon
        //        return cell
        //
        //        CASE DEPARTURE INFO
        //        let cell: DepartureInfoCell = tableView.dequeueCell(for: indexPath)
        //        interactor?.getDepartureModel(completion: {(model) in
        //            cell.configure(text: model?.text, image: model?.image, link: model?.link)
        //        })
        //        cell.backgroundColor = .carbon
        //        return cell
        //        CASE FEAST FOR EYES
//        let cell: FeastCell = tableView.dequeueCell(for: indexPath)
//        interactor?.getFeastModel(completion: {(model) in
//            cell.configure(image: model?.image)
//        })
//        cell.backgroundColor = .carbon
//        return cell
    }
}

// MARK: - DumViewControllerInterface

extension  DailyBriefViewController: DailyBriefViewControllerInterface {

    @objc func checkAction(sender: UITapGestureRecognizer) {
        interactor?.createLatestWhatsHotModel(completion: { [weak self] (model) in
            self?.interactor?.presentWhatsHotArticle(selectedID: model?.remoteID ?? 0)
        })
    }
}
