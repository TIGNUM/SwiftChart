//
//  MyToBeVisionViewModel.swift
//  QOT
//
//  Created by karmic on 18.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class MyToBeVisionViewModel {

    // MARK: - Properties

    private(set) var item: MyToBeVisionIntermediary
    var headline: String? {
        return item.headline
    }
    var subHeadline: String? {
        return item.subHeadline
    }
    var text: String? {
        return item.text
    }
    var profileImage: UIImage? {
        return item.profileImage
    }
    var dateText: String? {
        guard let date = item.date else {
            return nil
        }
        
        let now = Date()
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.year, .month, .weekOfMonth, .day, .hour, .minute, .second], from: date, to: now)
        guard let dateText = formatter.string(from: components) else {
            return nil
        }
        // TODO: lee localise
        return "Written \(dateText) ago".uppercased()
    }
    
    init(item: MyToBeVisionIntermediary?) {
        self.item = item ?? MyToBeVisionIntermediary(
            localID: UUID().uuidString,
            headline: nil,
            subHeadline: nil,
            text: nil,
            profileImageURL: nil,
            date: nil)
    }
    
    func updateHeadline(_ headline: String?) {
        item.headline = headline
    }
    
    func updateText(_ text: String?) {
        item.text = text
    }
    
    func updateDate(_ date: Date?) {
        item.date = date
    }
    
    func updateProfileImageURL(_ profileImageURL: String?) {
        item.profileImageURL = profileImageURL
    }
    
    func updateProfileImage(_ image: UIImage?) -> Error? {
        do {
            let url = try image?.save(withName: item.localID)
            updateProfileImageURL(url?.absoluteString)
            return nil
        } catch {
            return error
        }
    }
}
