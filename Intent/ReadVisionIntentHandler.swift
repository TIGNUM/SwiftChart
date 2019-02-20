//
//  ReadVisionIntentHandler.swift
//  Intent
//
//  Created by Javier Sanz Rozalén on 08.02.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import Intents

final class ReadVisionIntentHandler: NSObject, ReadVisionIntentHandling {

    func handle(intent: ReadVisionIntent, completion: @escaping (ReadVisionIntentResponse) -> Void) {
        guard let vision: ExtensionModel.ToBeVision = ExtensionUserDefaults.object(for: .siri, key: .toBeVision) else {
            completion(ReadVisionIntentResponse(code: .failure, userActivity: nil))
            return
        }
        guard let visionText = vision.text else {
            let response = ReadVisionIntentResponse(code: .noVision, userActivity: nil)
            response.userActivity = NSUserActivity.activity(for: .toBeVisionGenerator)
            completion(response)
            return
        }
        let response = ReadVisionIntentResponse.success(vision: visionText)
        response.userActivity = NSUserActivity.activity(for: .toBeVision)
        response.imageURL = vision.imageURL
        response.headline = vision.headline
        response.vision = visionText
        completion(response)
    }
}
