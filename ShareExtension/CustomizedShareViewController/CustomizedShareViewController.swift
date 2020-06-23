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

final class CustomizedShareViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties
    
    private var shareExtensionData = ShareExtentionData()
    @IBOutlet private weak var tableView: UITableView!
    private var rightBarButtonItems = [UIBarButtonItem]()
    let teamCollection: [TeamLibrary] = [TeamLibrary(teamName: "My Library", numberOfParticipants: nil),
                                         TeamLibrary(teamName: "Web Team Library", numberOfParticipants: 13),
                                         TeamLibrary(teamName: "Tignum Team Library", numberOfParticipants: 40)]
    @IBOutlet private weak var addButton: UIButton!
    let accent = UIColor(red: 182/255, green: 155/255, blue: 134/255, alpha: 1)

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
        setupTableview()
        setupView()
    }

     // MARK: - Action

    @IBAction func addTapped(_ sender: Any) {
        self.handleSharedFile()
    }

    func goBack(){
        dismiss(animated: true, completion: nil)
    }

    // MARK: - TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamCollection.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TeamTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath) as! TeamTableViewCell
        cell.configure(teamName: teamCollection[indexPath.row].teamName,
                       participants: teamCollection[indexPath.row].numberOfParticipants ?? 2)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - Private
private extension CustomizedShareViewController{

    func setupTableview() {
        tableView.tableFooterView = UIView()
        tableView.register(TeamTableViewCell.self, forCellReuseIdentifier: "teamCell")
    }

    func setupView() {
        setupNavBar()
        setupBackButton()
    }

    func setupBackButton() {
        let bundle = Bundle(for: CustomizedShareViewController.self)
        guard let closeIcon = UIImage(named: "ic_close", in: bundle, compatibleWith: nil) else {
            fatalError("Missing MyImage...")
        }
        let backButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 15, height: 15)))
        backButton.setImage(closeIcon, for: .normal)
        backButton.addTarget(self, action: #selector(UIWebView.goBack), for: .touchUpInside)
        backButton.tintColor = accent
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        addButton.layer.borderColor = accent.withAlphaComponent(0.6).cgColor
        addButton.layer.cornerRadius = addButton.frame.size.height/2
        addButton.layer.borderWidth = 1
    }

//    fonts to do + apptext
    func setupNavBar() {
        let navBar = navigationController?.navigationBar
        navBar?.barTintColor = .black
        navBar?.isTranslucent = false
        navBar?.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBar?.topItem?.title = "ADD TO..."
    }

    private func handleSharedFile() {
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
                strongSelf.handleURL(url)
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
                strongSelf.handleString(string)
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

    func handleString(_ string: String) {
        if let url = URL(string: string) {
            handleURL(url)
        } else if let urls = urls(from: string), urls.count > 0 {
            let sorted = urls.filter { $0.absoluteString.contains("@") == false }
                .sorted { $0.absoluteString.count >  $1.absoluteString.count }
            if let url = sorted.first {
                handleURL(url)
            }
        } else {
            addNote(string)
        }
    }

    func handleURL(_ url: URL) {
        guard url.isFileURL == false else {
            handleFailure()
            return
        }
        shareExtensionData.type = "EXTERNAL_LINK"
        shareExtensionData.url = url.absoluteString
        saveLink()
    }

    func addNote(_ string: String) {
        shareExtensionData.type = "NOTE"
        shareExtensionData.description = string
        saveLink()
    }

    func saveLink() {
        self.shareExtensionData.date = Date()
        var dataArray = ExtensionUserDefaults.object(for: .share, key: .saveLink) ?? [ShareExtentionData]()
        dataArray.append(self.shareExtensionData)
        ExtensionUserDefaults.set(dataArray, for: .saveLink, in: .share)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            if let context = self.extensionContext {
                context.completeRequest(returningItems: [], completionHandler: nil)
            } else {
                //  replacement of super.didSelectPost() ??
            }
        }
    }

    func handleFailure() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.extensionContext?.cancelRequest(withError: NSError())
        }
    }
}

