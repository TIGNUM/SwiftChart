//
//  CustomizedShareViewControllerViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 19.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import MobileCoreServices
import Social

protocol CustomizedShareViewControllerDelegate: class {
    func didSelectTeam(_ tag: Int)
}

final class CustomizedShareViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties
    
    private var shareExtensionData = ShareExtentionData()
    @IBOutlet private weak var tableView: UITableView!
    private var rightBarButtonItems = [UIBarButtonItem]()
    private var teamCollection = [ExtensionModel.TeamLibrary]()
    private var shareExtensionStrings : ExtensionModel.ShareExtensionStrings?
    private var rowsForSelected: [Int]? = []
    @IBOutlet private weak var addButton: UIButton!
    private var addPressed = false

    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        fetchData()
        setupTableview()
        setupView()
    }

     // MARK: - Action

    @IBAction func addTapped(_ sender: Any) {
        addPressed.toggle()
        var selectedTeamIds: [String?] = []
        if let selected_rows = rowsForSelected {
            for row in selected_rows {
                selectedTeamIds.append(teamCollection[row].teamQotId ?? nil)
            }
        }
        updateTableView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.hideExtensionWithCompletionHandler(completion: { (Bool) -> Void in
                self.handleSharedFile(teamQotIds: selectedTeamIds)
                self.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
            })
        }
    }

    func addSelectedRows(row: Int) {
        if rowsForSelected?.contains(row) == true {
            if let index = rowsForSelected?.firstIndex(where: { $0 == row }) {
                rowsForSelected?.remove(at: index)
            }
        } else {
            rowsForSelected?.append(row)
        }
    }

    func goBack(){
        dismiss(animated: true, completion: nil)
    }

    // MARK: - TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addPressed ? 1 : teamCollection.count 
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if addPressed {
            let cell: ConfirmationViewCell = tableView.dequeueReusableCell(withIdentifier: "ConfirmationViewCell", for: indexPath) as! ConfirmationViewCell
            cell.configure(message: shareExtensionStrings?.addedTo)
            return cell
        } else {
            let cell: TeamTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath) as! TeamTableViewCell
            cell.configure(teamName: teamCollection[indexPath.row].teamName ?? "",
                           participants: teamCollection[indexPath.row].numberOfMembers ?? 0,
                           shareExtensionStrings: shareExtensionStrings)
            cell.isUserInteractionEnabled = true
            cell.isSelected ? tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none) : nil
            cell.selectionStyle = .none
            cell.delegate = self
            cell.checkButton.tag = indexPath.row
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if !addPressed {
            if let cell = tableView.cellForRow(at: indexPath) as? TeamTableViewCell {
                cell.checkButton.isSelected.toggle()
                cell.checkButton.isSelected ? didSelectTeam(indexPath.row) : nil
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}

// MARK: - Private
private extension CustomizedShareViewController{

    func updateTableView() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.view.backgroundColor = .clear
        }, completion: nil)
        let navBar = navigationController?.navigationBar
        navBar?.isHidden = true
        addButton.isHidden = true
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.separatorStyle = .none
        tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }

    func setupTableview() {
        tableView.tableFooterView = UIView()
        tableView.register(TeamTableViewCell.self, forCellReuseIdentifier: "teamCell")
        tableView.register(ConfirmationViewCell.self, forCellReuseIdentifier: "confirmationViewCell")
    }

    func setupView() {
        setupNavBar()
        setupBackButton()
    }

    func hideExtensionWithCompletionHandler(completion:@escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: {
            self.tableView.alpha = 0.0
        }, completion: completion)
    }

    func setupBackButton() {
        let bundle = Bundle(for: CustomizedShareViewController.self)
        guard let closeIcon = UIImage(named: "ic_close", in: bundle, compatibleWith: nil) else {
            fatalError("Missing MyImage...")
        }
        let backButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 15, height: 15)))
        backButton.setImage(closeIcon, for: .normal)
        backButton.imageView?.tintColor = .white
        backButton.addTarget(self, action: #selector(UIWebView.goBack), for: .touchUpInside)
        backButton.tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        addButton.layer.borderColor = UIColor.white.withAlphaComponent(0.6).cgColor
        addButton.backgroundColor = .black
        addButton.layer.cornerRadius = addButton.frame.size.height/2
        addButton.layer.borderWidth = 1
    }

    func setupNavBar() {
        let navBar = navigationController?.navigationBar
        navBar?.barTintColor = .black
        navBar?.isTranslucent = false
        navBar?.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBar?.topItem?.title = shareExtensionStrings?.addTo
    }

// MARK: - Fetch Data

    func fetchData() {
        let shareExtensionStrings: ExtensionModel.ShareExtensionStrings? = ExtensionUserDefaults.object(for: .share, key: .shareExtensionStrings)
        self.shareExtensionStrings = shareExtensionStrings
        var teamCollection: [ExtensionModel.TeamLibrary] = [ExtensionModel.TeamLibrary(teamName: shareExtensionStrings?.myLibrary, teamQotId: nil, numberOfMembers: nil)]
        let data: [ExtensionModel.TeamLibrary]? = ExtensionUserDefaults.object(for: .share, key: .teams)
        data?.forEach {(team) in
            teamCollection.append(ExtensionModel.TeamLibrary(teamName: team.teamName, teamQotId: team.teamQotId, numberOfMembers: team.numberOfMembers))
        }
        self.teamCollection = teamCollection
    }


// MARK: - Handling Links

    private func handleSharedFile(teamQotIds: [String?]) {
        let typeURL = String(kUTTypeURL)
        let textTypes = [String(kUTTypeText),
                         String(kUTTypePlainText),
                         String(kUTTypeUTF8PlainText),
                         String(kUTTypeUTF16PlainText)]
        let extensionItem = extensionContext?.inputItems.first as! NSExtensionItem
        let urlItemProvider = extensionItem.attachments?.filter { $0.hasItemConformingToTypeIdentifier(typeURL) }.first
        guard let itemProvider = urlItemProvider ?? extensionItem.attachments?.first else {
            return
        }
        if itemProvider.hasItemConformingToTypeIdentifier(typeURL) {
            itemProvider.loadItem(forTypeIdentifier: typeURL, options: nil) { [weak self] (item, error) -> Void in
                guard let strongSelf = self, let url = item as? URL else {
                    self?.handleFailure()
                    return
                }
                strongSelf.handleURL(teamQotIds, url)
            }
            return
        }

        var handled = false
        for type in textTypes where itemProvider.hasItemConformingToTypeIdentifier(type) {
            itemProvider.loadItem(forTypeIdentifier: type, options: nil) { [weak self] (item, error) -> Void in
                guard let strongSelf = self, let string = item as? String else {
                    self?.handleFailure()
                    return
                }
                strongSelf.handleString(teamQotIds, string)
            }
            handled = true
            break
        }
        if !handled {
            handleFailure()
        }
    }

    func urls(from string: String) -> [URL]? {
        do {
            let pattern = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?(\\\\?)?([=a-z0-9!#$\\%^&*-_]+)?"
            let regex = try NSRegularExpression(pattern: pattern)
            let results = regex.matches(in: string, range: NSRange(string.startIndex..., in: string))
                .compactMap {
                    return URL(string: String(string[Range($0.range, in: string)!]))
            }
            return results
        } catch {
            return nil
        }
    }

    func handleString(_ teamQotIds: [String?], _ string: String) {
        if let url = URL(string: string) {
            handleURL(teamQotIds, url)
        } else if let urls = urls(from: string), urls.count > 0 {
            let sorted = urls.filter { $0.absoluteString.contains("@") == false }
                .sorted { $0.absoluteString.count >  $1.absoluteString.count }
            if let url = sorted.first {
                handleURL(teamQotIds, url)
            }
        } else {
            addNote(teamQotIds, string)
        }
    }

    func handleURL(_ teamQotIds: [String?],_ url: URL) {
        guard url.isFileURL == false else {
            handleFailure()
            return
        }
        shareExtensionData.type = "EXTERNAL_LINK"
        shareExtensionData.url = url.absoluteString
        saveLink(teamQotIds)
    }

    func addNote(_ teamQotIds: [String?], _ string: String) {
        shareExtensionData.type = "NOTE"
        shareExtensionData.description = string
        saveLink(teamQotIds)
    }

    func saveLink(_ teamQotIds: [String?] ) {
        self.shareExtensionData.date = Date()
        var dataArray = ExtensionUserDefaults.object(for: .share, key: .saveLink) ?? [ShareExtentionData]()
        teamQotIds.forEach { (teamQotId) in
            shareExtensionData.teamQotId = teamQotId
            dataArray.append(self.shareExtensionData)
        }
        ExtensionUserDefaults.set(dataArray, for: .saveLink, in: .share)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            let context = self.extensionContext
            context?.completeRequest(returningItems: [], completionHandler: nil)
        }
    }

    func handleFailure() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.extensionContext?.cancelRequest(withError: NSError())
        }
    }
}

extension CustomizedShareViewController: CustomizedShareViewControllerDelegate {

    func didSelectTeam(_ tag: Int) {
        addSelectedRows(row: tag)
    }
}

