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
    @IBOutlet private weak var suggestionsTableView: UITableView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var indicatorView: UIView!
    @IBOutlet private weak var topConstraint: NSLayoutConstraint!
    @IBOutlet private weak var indicatorWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var indicatorViewLeadingConstraing: NSLayoutConstraint!
    let pageName: PageName
    private let suggestionsHeader = SuggestionsHeaderView.instantiateFromNib()
    private var avPlayerObserver: AVPlayerObserver?
    private var searchBar = UISearchBar()
    private var searchResults = [Search.Result]()
    private var searchSuggestions: SearchSuggestions?
    private var searchFilter = Search.Filter.all
    private var searchQuery = ""

    init(configure: Configurator<SearchViewController>, pageName: PageName) {
        self.pageName = pageName
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .navy
        setupSegementedControl()
        setupSearchBar()
        interactor?.showSuggestions()
        suggestionsHeader.autoresizingMask = []
        suggestionsTableView.tableHeaderView = suggestionsHeader
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.alpha = 1
        tableView.registerDequeueable(SearchTableViewCell.self)
        suggestionsTableView.registerDequeueable(SuggestionSearchTableViewCell.self)
        UIApplication.shared.setStatusBarStyle(.lightContent)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        segmentedControl.alpha = 1
        if searchQuery.isEmpty == false {
            searchBar.becomeFirstResponder()
            updateViewsState(true)
        } else {
            updateViewsState(false)
        }
        updateIndicator()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.alpha = 0
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        segmentedControl.alpha = 0
    }

    override func willMove(toParentViewController parent: UIViewController?) {
        searchBar.resignFirstResponder()
    }

    func reload(_ searchResults: [Search.Result]) {
        self.searchResults = searchResults
        tableView.isUserInteractionEnabled = searchResults.isEmpty == false
        tableView.reloadData()
    }

    func load(_ searchSuggestions: SearchSuggestions) {
        self.searchSuggestions = searchSuggestions
        suggestionsHeader.configure(title: searchSuggestions.header)
    }
}

// MARK: - Private

private extension SearchViewController {

    func setupSegementedControl() {
        segmentedControl.tintColor = .clear
        segmentedControl.backgroundColor = .clear
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.H8Title,
                                                 NSAttributedStringKey.foregroundColor: UIColor.white60],
                                                for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.H8Title,
                                                 NSAttributedStringKey.foregroundColor: UIColor.white90],
                                                for: .selected)
    }

    func setupSearchBar() {
        let searchBar = UISearchBar()
        setCustomBackButton()
        searchBar.tintColor = .navy
        searchBar.keyboardAppearance = .dark
        searchBar.barTintColor = .gray
        searchBar.delegate = self
        searchBar.placeholder = R.string.localized.searchPlaceholder()
        navigationItem.titleView = searchBar
        self.searchBar = searchBar
    }

    func sendSearchResult(for query: String) {
        let filter = Search.Filter(rawValue: segmentedControl.selectedSegmentIndex) ?? Search.Filter.all
        interactor?.sendUserSearchResult(contentId: nil, contentItemId: nil, filter: filter, query: query)
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
        updateIndicator()
        tableView.scrollToTop(animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if searchQuery.isEmpty == true {
            segmentedControl.selectedSegmentIndex = 0
        }
        updateIndicator()
        updateViewsState(true)
        return true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchQuery = searchText
        updateSearchResults()
        updateViewsState(true)
        updateIndicator()
        if searchText.isEmpty == true {
            segmentedControl.selectedSegmentIndex = 0
            searchBar.perform(#selector(self.resignFirstResponder), with: nil, afterDelay: 0)
            updateViewsState(false)
        }
    }

    func updateSearchResults() {
        interactor?.didChangeSearchText(searchText: searchQuery, searchFilter: searchFilter)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tableView:
            if searchResults.isEmpty == false {
                return searchResults.count
            } else if searchResults.isEmpty == true && searchQuery.isEmpty == false {
                return 1
            }
        case self.suggestionsTableView:
            return searchSuggestions?.suggestions.count ?? 0
        default:
            preconditionFailure()
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case self.tableView:
            let searchCell: SearchTableViewCell = tableView.dequeueCell(for: indexPath)
            if searchResults.isEmpty == true && searchQuery.isEmpty == false {
                searchCell.configure(title: R.string.localized.alertTitleNoContent(), contentType: nil, duration: nil)
            } else {
                let result = searchResults[indexPath.row]
                searchCell.configure(title: result.title,
                                     contentType: result.displayType.rawValue,
                                     duration: result.duration)
            }
            return searchCell
        case self.suggestionsTableView:
            let suggestionCell: SuggestionSearchTableViewCell = tableView.dequeueCell(for: indexPath)
            suggestionCell.configrue(suggestion: searchSuggestions?.suggestions[indexPath.row] ?? "")
            return suggestionCell
        default:
            preconditionFailure()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case self.tableView:
            return 80
        case self.suggestionsTableView:
            return UITableViewAutomaticDimension
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch tableView {
        case self.tableView:
            handleSelection(for: indexPath)
        case self.suggestionsTableView:
            let suggestion = searchSuggestions?.suggestions[indexPath.row] ?? ""
            sendSearchResult(for: suggestion)
            searchBar.text = suggestion
            searchQuery = suggestion
            searchBar.becomeFirstResponder()
            updateSearchResults()
        default:
            preconditionFailure()
        }
        updateIndicator()
        updateViewsState(true)
    }
}

// MARK: - Private

private extension SearchViewController {

    func handleMediaSelection(mediaURL: URL, contentItem: ContentItem?) {
        let playerViewController = stream(videoURL: mediaURL, contentItem: contentItem, pageName: pageName)
        if let playerItem = playerViewController.player?.currentItem {
            avPlayerObserver = AVPlayerObserver(playerItem: playerItem)
            avPlayerObserver?.onStatusUpdate { (player) in
                if playerItem.error != nil {
                    playerViewController.presentNoInternetConnectionAlert(in: playerViewController)
                }
            }
        }
    }

    func updateIndicator() {
        let width = segmentedControl.bounds.width / CGFloat(segmentedControl.numberOfSegments)
        let xPosition = CGFloat(segmentedControl.selectedSegmentIndex * Int(width))
        indicatorViewLeadingConstraing.constant = xPosition
        indicatorWidthConstraint.constant = width
        UIView.animate(withDuration: Animation.duration_00) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    func updateViewsState(_ suggestionShouldHide: Bool) {
        suggestionsTableView.isHidden = suggestionShouldHide
        indicatorView.isHidden = suggestionsTableView.isHidden == false
        segmentedControl.isHidden = suggestionsTableView.isHidden == false
        tableView.isHidden = suggestionsTableView.isHidden == false
    }

    func handleSelection(for indexPath: IndexPath) {
        let selectedSearchResult = searchResults[indexPath.row]
        interactor?.sendUserSearchResult(contentId: selectedSearchResult.contentID,
                                         contentItemId: selectedSearchResult.contentItemID,
                                         filter: selectedSearchResult.filter,
                                         query: searchQuery)
        switch selectedSearchResult.filter {
        case .all, .read, .tools:
            interactor?.handleSelection(searchResult: selectedSearchResult)
        case .watch, .listen:
            if let url = selectedSearchResult.mediaURL {
                handleMediaSelection(mediaURL: url, contentItem: interactor?.contentItem(for: selectedSearchResult))
            }
        }
    }
}
