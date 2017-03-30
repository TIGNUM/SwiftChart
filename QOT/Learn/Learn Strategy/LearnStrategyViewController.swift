//
//  LearnStrategyViewController.swift
//  QOT
//
//  Created by karmic on 29/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol LearnStrategyViewControllerDelegate: class {
    func didTapClose(in viewController: LearnStrategyViewController)
    func didTapShare(in viewController: LearnStrategyViewController)
    func didTapVideo(with video: LearnStrategyItem, from view: UIView, in viewController: LearnStrategyViewController)
    func didTapArticle(with article: LearnStrategyItem, from view: UIView, in viewController: LearnStrategyViewController)
}

final class LearnStrategyViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel: LearnStrategyViewModel
    weak var delegate: LearnStrategyViewControllerDelegate?
    
    init(viewModel: LearnStrategyViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeView))
        view.addGestureRecognizer(tapGestureRecognizer)
        view.backgroundColor = .black
        //tableView.delegate = self
        //tableView.dataSource = self
        tableView.backgroundColor = .blue
        tableView.register(LearnStrategyCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func closeView(gestureRecognizer: UITapGestureRecognizer) {
        delegate?.didTapClose(in: self)
    }
}

extension LearnStrategyViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
}

extension LearnStrategyViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let  cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
          cell.backgroundColor = UIColor.red
        cell.contentView.backgroundColor = .green
        return cell
    }
}
