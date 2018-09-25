//
//  SearchFieldViewController.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 5/24/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class SearchViewController: UIViewController, SearchViewControllerInterface {

    var interactor: SearchInteractorInterface?
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
	@IBOutlet private weak var topConstraint: NSLayoutConstraint!
    private var avPlayerObserver: AVPlayerObserver?
    private var searchBar = UISearchBar()
    private var searchResults = [Search.Result]()
    private var searchFilter = Search.Filter.all
    private var searchQuery = ""

    init(configure: Configurator<SearchViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegementedControl()
        setupSearchBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.alpha = 1
        searchBar.becomeFirstResponder()
        tableView.register(R.nib.searchTableViewCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.searchTableViewCell_Identifier.identifier)
        UIApplication.shared.setStatusBarStyle(.lightContent)
    }

    override func viewWillDisappear(_ animated: Bool) {
        searchBar.alpha = 0
    }

    override func willMove(toParentViewController parent: UIViewController?) {
        searchBar.resignFirstResponder()
    }

    func reload(_ searchResults: [Search.Result]) {
        self.searchResults = searchResults
        tableView.isUserInteractionEnabled = searchResults.isEmpty == false
        tableView.reloadData()
        if searchResults.isEmpty == true {
            let filter = Search.Filter(rawValue: segmentedControl.selectedSegmentIndex) ?? Search.Filter.all
            interactor?.sendUserSearchResult(contentId: nil,
                                             contentItemId: nil,
                                             filter: filter,
                                             query: searchQuery)
        }
    }
}

// MARK: - Private

private extension SearchViewController {

    func setupSegementedControl() {
        segmentedControl.tintColor = .clear
        segmentedControl.backgroundColor = .clear
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: Font.H8Title,
                                                 NSAttributedStringKey.foregroundColor: UIColor.white60],
                                                for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: Font.H8Title,
                                                 NSAttributedStringKey.foregroundColor: UIColor.white90],
                                                for: .selected)
    }

    func setupSearchBar() {
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.tintColor = .white
        searchBar.keyboardAppearance = .dark
        searchBar.barTintColor = .clear
        searchBar.changeSearchBarColor(color: .clear)
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        self.searchBar = searchBar
		if #available(iOS 11.0, *) {

		} else {
			topConstraint.constant = Layout.statusBarHeight + Layout.padding_24
		}
    }
}

// MARK: - Actions

extension SearchViewController {

    @IBAction func close(_ sender: UIButton) {
        interactor?.didTapClose()
    }

    @IBAction func segmentedControlDidChange(_ segmentedControl: UISegmentedControl) {
        searchFilter = Search.Filter(rawValue: segmentedControl.selectedSegmentIndex) ?? Search.Filter.all
        updateSearchResults()
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchQuery = searchText
        updateSearchResults()
    }

    func updateSearchResults() {
        interactor?.didChangeSearchText(searchText: searchQuery, searchFilter: searchFilter)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard searchBar.text?.isEmpty == false else { return }
        searchBar.endEditing(true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchResults.isEmpty == false {
            return searchResults.count
        } else if searchResults.isEmpty == true && searchQuery.isEmpty == false {
            return 1
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = R.reuseIdentifier.searchTableViewCell_Identifier.identifier
        guard let searchCell = tableView.dequeueReusableCell(withIdentifier: identifier,
                                                             for: indexPath) as? SearchTableViewCell else {
            fatalError("SettingsTableViewCell DOES NOT EXIST!!!")
        }

        if searchResults.isEmpty == true && searchQuery.isEmpty == false {
            searchCell.configure(title: R.string.localized.alertTitleNoContent(), contentType: nil, duration: nil)
        } else {
            let result = searchResults[indexPath.row]
            searchCell.configure(title: result.title, contentType: result.displayType.rawValue, duration: result.duration)
        }
        return searchCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedSearchResult = searchResults[indexPath.row]
        interactor?.sendUserSearchResult(contentId: selectedSearchResult.contentID,
                                         contentItemId: selectedSearchResult.contentItemID,
                                         filter: selectedSearchResult.filter,
                                         query: searchQuery)
        switch selectedSearchResult.filter {
        case .all: interactor?.handleSelection(searchResult: selectedSearchResult)
        case .audio,
             .video:
            if let url = selectedSearchResult.mediaURL {
                handleMediaSelection(mediaURL: url)
            }
        }
    }
}

// MARK: - Private

private extension SearchViewController {

    func handleMediaSelection(mediaURL: URL) {
        let playerViewController = stream(videoURL: mediaURL)
        if let playerItem = playerViewController.player?.currentItem {
            avPlayerObserver = AVPlayerObserver(playerItem: playerItem)
            avPlayerObserver?.onStatusUpdate { (player) in
                if playerItem.error != nil {
                    playerViewController.presentNoInternetConnectionAlert(in: playerViewController)
                }
            }
        }
    }
}

private extension UISearchBar {

    func changeSearchBarColor(color: UIColor) {
        UIGraphicsBeginImageContext(frame.size)
        color.setFill()
        UIBezierPath(rect: frame).fill()
        let bgImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        setSearchFieldBackgroundImage(bgImage, for: .normal)
        setBackgroundImage(bgImage, for: .top, barMetrics: .defaultPrompt)

        for view in subviews {
            for subview in view.subviews {
                if let textField = subview as? UITextField {
                    textField.backgroundColor = color
                    textField.textColor = .white
                }
            }
        }
    }
}
