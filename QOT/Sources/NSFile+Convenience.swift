//
//  File.swift
//  QOT
//
//  Created by tignum on 4/11/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

extension String {
    
    func makingTwoLines() -> String {
        guard rangeOfCharacter(from: .newlines) == nil else {
            return self
        }
        
        guard let regex = try? NSRegularExpression(pattern: " ", options: .caseInsensitive) else {
            fatalError("invalid regex")
        }
        
        let results = regex.matches(in: self, options: [], range: NSRange(location: 0, length: utf16.count))
        
        if results.count <= 1 {
            return self
        }
        
        let minIndex = utf16.count / 2
        var candidate = results[0]
        for result in results.dropFirst() {
            if abs(minIndex - result.range.location) < abs(minIndex - candidate.range.location) {
                candidate = result
            }
        }
        
        return (self as NSString).replacingCharacters(in: candidate.range, with: "\n") as String
    }
}
