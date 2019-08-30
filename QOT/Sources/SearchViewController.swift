//
//  SearchFieldViewController.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 5/24/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class SearchViewController: UIViewController, ScreenZLevelOverlay, SearchViewControllerInterface {

    var interactor: SearchInteractorInterface?
    weak var delegate: CoachCollectionViewControllerDelegate?
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var suggestionsTableView: UITableView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var indicatorView: UIView!
    @IBOutlet private weak var indicatorWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var mySearchBar: UISearchBar!
    @IBOutlet private weak var indicatorViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var activeView: UIView!
    @IBOutlet private weak var constraintSearch: NSLayoutConstraint!

    let pageName: PageName
    private let suggestionsHeader = SuggestionsHeaderView.instantiateFromNib()
    private var avPlayerObserver: AVPlayerObserver?
    private var searchResults = [Search.Result]()
    private var searchSuggestions: SearchSuggestions?
    private var searchFilter = Search.Filter.all
    private var searchQuery = ""

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return ColorMode.dark.statusBarStyle
    }

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
        ThemeView.level2.apply(self.view)

        ThemeView.level2.apply(view)
        self.navigationItem.hidesBackButton = true
        self.navigationController?.view.backgroundColor = UIColor.carbonNew
        setupSegementedControl()
        interactor?.showSuggestions()
        suggestionsHeader.autoresizingMask = []
        suggestionsTableView.tableHeaderView = suggestionsHeader
        tableView.registerDequeueable(SearchTableViewCell.self)
        suggestionsTableView.registerDequeueable(SuggestionSearchTableViewCell.self)
        setupSearchBar()
        setStatusBar(colorMode: ColorMode.dark)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
        segmentedControl.alpha = 1
        let hasUserInput = mySearchBar.text?.isEmpty == false
        if hasUserInput {
            mySearchBar.becomeFirstResponder()
        }
        updateViewsState(hasUserInput)
        updateIndicator()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        segmentedControl.alpha = 0
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

// MARK: - animation from parent

extension SearchViewController {
    func activate(_ duration: Double) {
        constraintSearch.constant = activeView.frame.size.height - mySearchBar.frame.size.height
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
        if let cancelButton = mySearchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.isEnabled = true
        }
    }

    private func deactivate() {
        mySearchBar.resignFirstResponder()
        updateViewsState(false)
        mySearchBar.text = ""
        constraintSearch.constant = 0
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Bottom Navigation

extension SearchViewController {
    @objc override public func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return nil
    }

    @objc override public func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return nil
    }
}

// MARK: - Private

private extension SearchViewController {

    func setupSegementedControl() {
        ThemeSegment.accent.apply(segmentedControl)
    }

    func setupSearchBar() {
        ThemeSearchBar.accent.apply(mySearchBar)

        constraintSearch.constant = 0.0
        mySearchBar.setNeedsUpdateConstraints()

        mySearchBar.placeholder = R.string.localized.searchPlaceholder()
        mySearchBar.delegate = self
    }

    func sendSearchResult(for query: String) {
        let filter = Search.Filter(rawValue: segmentedControl.selectedSegmentIndex) ?? Search.Filter.all
        interactor?.sendUserSearchResult(contentId: nil, contentItemId: nil, filter: filter, query: query)
    }
}

// MARK: - Actions

extension SearchViewController {

    @IBAction func close(_ sender: UIButton) {
        trackUserEvent(.CLOSE, action: .TAP)
        interactor?.didTapClose()
    }

    @IBAction func segmentedControlDidChange(_ segmentedControl: UISegmentedControl) {
        searchFilter = Search.Filter(rawValue: segmentedControl.selectedSegmentIndex) ?? Search.Filter.all
        trackUserEvent(.SELECT, valueType: searchFilter.userEvent, action: .TAP)
        updateSearchResults()
        updateIndicator()

        switch tableView {
        case self.tableView:
            if searchResults.isEmpty == false {
                tableView.scrollToTop(animated: true) }
        default:
            break
        }
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchQuery = searchText
        updateSearchResults()
        updateIndicator()
        if searchText.isEmpty == true {
            segmentedControl.selectedSegmentIndex = 0
            searchBar.perform(#selector(self.resignFirstResponder), with: nil, afterDelay: 0)
            updateViewsState(false)
        } else {
            updateViewsState(true)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if let previousVC = navigationController?.viewControllers.dropLast().last {
            if previousVC is CoachViewController {
                navigationController?.popToViewController(previousVC, animated: true)
            }
        } else {
            deactivate()
            delegate?.didTapCancel()
            if searchResults.isEmpty == true {
                segmentedControl.selectedSegmentIndex = 0
                updateViewsState(false)
            }
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
                                     contentType: result.displayType,
                                     duration: result.duration)            }
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
            searchCell.selectedBackgroundView = backgroundView
            return searchCell
        case self.suggestionsTableView:
            let suggestionCell: SuggestionSearchTableViewCell = tableView.dequeueCell(for: indexPath)
            suggestionCell.configrue(suggestion: searchSuggestions?.suggestions[indexPath.row] ?? "")
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
            suggestionCell.selectedBackgroundView = backgroundView
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
            let key = searchResults[indexPath.row].contentID
            trackUserEvent(.SELECT, value: key, valueType: .CONTENT, action: .TAP)
            handleSelection(for: indexPath)
        case self.suggestionsTableView:
            let suggestion = searchSuggestions?.suggestions[indexPath.row] ?? ""
            sendSearchResult(for: suggestion)
            mySearchBar.text = suggestion
            searchQuery = suggestion
            mySearchBar.becomeFirstResponder()
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

    func handleMediaSelection(mediaURL: URL, contentItem: QDMContentItem?) {
        let playerViewController = stream(videoURL: mediaURL, contentItem: contentItem, pageName)
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
        let location = segmentedControl.underline()
        indicatorViewLeadingConstraint.constant = location.xCentre - location.width / 2
        indicatorWidthConstraint.constant = location.width
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    func updateViewsState(_ suggestionShouldHide: Bool) {
        let alpha: CGFloat = suggestionShouldHide ? 0.0 : 1.0

        suggestionsTableView.alpha = 1 - alpha
        tableView.alpha = alpha
        indicatorView.alpha = alpha
        segmentedControl.alpha = alpha
        suggestionsTableView.isHidden = false
        tableView.isHidden = false
        indicatorView.isHidden = false
        segmentedControl.isHidden = false

        UIView.animate(withDuration: 0.25, animations: {
            self.suggestionsTableView.alpha = alpha
            self.tableView.alpha = 1 - alpha
            self.indicatorView.alpha = 1 - alpha
            self.segmentedControl.alpha = 1 - alpha
        }, completion: { (_) in
            self.suggestionsTableView.isHidden = suggestionShouldHide
            self.tableView.isHidden = !suggestionShouldHide
            self.indicatorView.isHidden = !suggestionShouldHide
            self.segmentedControl.isHidden = !suggestionShouldHide
        })
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
                interactor?.contentItem(for: selectedSearchResult) { item in
                    self.handleMediaSelection(mediaURL: url, contentItem: item)
                }
            }
        }
    }
}
