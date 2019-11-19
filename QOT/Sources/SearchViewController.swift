//
//  SearchFieldViewController.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 5/24/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class SearchViewController: BaseViewController, ScreenZLevelOverlay, SearchViewControllerInterface {

    var interactor: SearchInteractorInterface!
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
    @IBOutlet private weak var masterView: UIView!
    @IBOutlet private weak var bottomView: UIView!

    private let suggestionsHeader = SuggestionsHeaderView.instantiateFromNib()
    private var avPlayerObserver: AVPlayerObserver?
    private var searchResults = [Search.Result]()
    private var searchSuggestions: SearchSuggestions?
    private var searchFilter = Search.Filter.all
    private var searchQuery = ""
    private var activateAnimateDuration: Double = 0.0
    public var showing = false

    init(configure: Configurator<SearchViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ThemeView.level1.apply(view)
        ThemeView.level1.apply(tableView)
        ThemeView.level1.apply(suggestionsTableView)
        ThemeView.level1.apply(activeView)
        ThemeView.level1.apply(mySearchBar)
        ThemeView.level1.apply(segmentedControl)
        ThemeView.level1.apply(masterView)
        ThemeView.level1.apply(bottomView)
        self.navigationItem.hidesBackButton = true
        setupSegementedControl()
        interactor.showSuggestions()
        suggestionsHeader.autoresizingMask = []
        suggestionsTableView.tableHeaderView = suggestionsHeader
        tableView.registerDequeueable(SearchTableViewCell.self)
        suggestionsTableView.registerDequeueable(SuggestionSearchTableViewCell.self)
        setAllControl(newAlpha: 1.0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        if interactor.shouldStartDeactivated() {
            if !showing {
                deactivate(animated: false)
            }
        } else {
            doActivate()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
        let hasUserInput = mySearchBar.text?.isEmpty == false
        updateViewsState(hasUserInput)
        updateIndicator()
        enableCancelButton()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !interactor.shouldStartDeactivated() {
            deactivate()
        }
        if let cancelButton = mySearchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.removeObserver(self, forKeyPath: "enabled")
        }
    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if let cancelButton = object as? UIButton, !cancelButton.isEnabled {
            cancelButton.isEnabled = true
        }
    }

    func reload(_ searchResults: [Search.Result]) {
        self.searchResults = searchResults
        tableView.isUserInteractionEnabled = searchResults.isEmpty == false
        tableView.reloadData()
    }

    func load(_ searchSuggestions: SearchSuggestions) {
        self.searchSuggestions = searchSuggestions
        suggestionsHeader.configure(title: searchSuggestions.header)
        suggestionsTableView.reloadData()
    }
}

// MARK: - animation from parent
extension SearchViewController {
    func activate(_ duration: Double) {
        activateAnimateDuration = duration
        if constraintSearch != nil {
            doActivate()
        }
    }

    private func doActivate() {
        var constantNew: CGFloat = activeView.frame.size.height - mySearchBar.frame.size.height
        if let parentView = parent?.view {
            if #available(iOS 11.0, *) {
                let guide = parentView.safeAreaLayoutGuide
                let height = guide.layoutFrame.size.height
                let insetsHeight = parentView.bounds.height - height
                constantNew = parentView.bounds.height - mySearchBar.bounds.height - insetsHeight
            } else {
                constantNew = parentView.bounds.height - mySearchBar.bounds.height
            }
        }
        if constantNew == constraintSearch.constant { return }
        constraintSearch.constant = constantNew
        UIView.animate(withDuration: activateAnimateDuration) {
            self.view.layoutIfNeeded()
        }
        mySearchBar.isUserInteractionEnabled = true
    }

    private func deactivate(animated: Bool = true) {
        mySearchBar.resignFirstResponder()
        updateViewsState(false)
        mySearchBar.text = ""
        constraintSearch.constant = 0
        if animated {
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.01) {
                self.view.layoutIfNeeded()
            }
        }
        mySearchBar.isUserInteractionEnabled = false
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
        mySearchBar.backgroundImage = UIImage()
        mySearchBar.placeholder = R.string.localized.searchPlaceholder()
        mySearchBar.delegate = self
    }

    func sendSearchResult(for query: String) {
        let filter = Search.Filter(rawValue: segmentedControl.selectedSegmentIndex) ?? Search.Filter.all
        interactor.sendUserSearchResult(contentId: nil, contentItemId: nil, filter: filter, query: query)
    }

    func enableCancelButton() {
        if let cancelButton = mySearchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.isEnabled = true
            cancelButton.addObserver(self, forKeyPath: "enabled", options: .new, context: nil)
        }
    }
}

// MARK: - Actions
extension SearchViewController {

    @IBAction func close(_ sender: UIButton) {
        trackUserEvent(.CLOSE, action: .TAP)
        interactor.didTapClose()
        mySearchBar.resignFirstResponder()
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
        trackUserEvent(.CANCEL, action: .TAP)
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
        interactor.didChangeSearchText(searchText: searchQuery, searchFilter: searchFilter)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        trackUserEvent(.SEARCH, valueType: searchBar.text, action: .TAP)
        searchBar.resignFirstResponder()
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
                                     duration: result.duration)
            }
            searchCell.setSelectedColor(.accent, alphaComponent: 0.15)
            return searchCell
        case self.suggestionsTableView:
            let suggestionCell: SuggestionSearchTableViewCell = tableView.dequeueCell(for: indexPath)
            suggestionCell.configrue(suggestion: searchSuggestions?.suggestions[indexPath.row] ?? "")
            suggestionCell.setSelectedColor(.accent, alphaComponent: 0.15)
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
            if let appLink = searchResults[indexPath.row].appLink {
                appLink.launch()
            } else {
                handleSelection(for: indexPath)
            }
        case self.suggestionsTableView:
            let suggestion = searchSuggestions?.suggestions[indexPath.row] ?? ""
            trackUserEvent(.SELECT, valueType: suggestion, action: .TAP)
            sendSearchResult(for: suggestion)
            mySearchBar.text = suggestion
            searchQuery = suggestion
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
        let playerViewController = stream(videoURL: mediaURL, contentItem: contentItem)
        if let playerViewController = playerViewController, let playerItem = playerViewController.player?.currentItem {
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
        if suggestionsTableView.isHidden == suggestionShouldHide { return }

        let alpha: CGFloat = suggestionShouldHide ? 0.0 : 1.0
        let reverseAlpha = 1 - alpha
        setAllControl(newAlpha: reverseAlpha)

        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.suggestionsTableView.alpha = alpha
            self?.tableView.alpha = reverseAlpha
            self?.indicatorView.alpha = reverseAlpha
            self?.segmentedControl.alpha = reverseAlpha
        }, completion: { [weak self] (_) in
            self?.suggestionsTableView.isHidden = suggestionShouldHide
            self?.tableView.isHidden = !suggestionShouldHide
            self?.indicatorView.isHidden = !suggestionShouldHide
            self?.segmentedControl.isHidden = !suggestionShouldHide
        })
    }

    func setAllControl(newAlpha: CGFloat) {
        suggestionsTableView.alpha = newAlpha
        let reverseAlpha = 1 - newAlpha
        tableView.alpha = reverseAlpha
        indicatorView.alpha = reverseAlpha
        segmentedControl.alpha = reverseAlpha
        suggestionsTableView.isHidden = false
        tableView.isHidden = false
        indicatorView.isHidden = false
        segmentedControl.isHidden = false
    }

    func handleSelection(for indexPath: IndexPath) {
        let selectedSearchResult = searchResults[indexPath.row]
        interactor.sendUserSearchResult(contentId: selectedSearchResult.contentID,
                                        contentItemId: selectedSearchResult.contentItemID,
                                        filter: selectedSearchResult.filter,
                                        query: searchQuery)
        switch selectedSearchResult.filter {
        case .all, .read, .tools:
            interactor.handleSelection(searchResult: selectedSearchResult)
        case .watch, .listen:
            if let url = selectedSearchResult.mediaURL {
                interactor.contentItem(for: selectedSearchResult) { item in
                    self.handleMediaSelection(mediaURL: url, contentItem: item)
                }
            }
        }
    }
}
