//
//  EKParticipant+ObjC.m
//  QOT
//
//  Created by Sam Wyndham on 08/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

#import "EKParticipant+ObjC.h"

@implementation EKParticipant (ObjC)

- (nullable NSURL *)safeURL {
    /*
     WARNING ☠️ - This method is a fix for a possible EventKit bug that can cause a crash when accessing a participant
     URL. It appears that the non nullable URL can infact be nil. This is the reason for if/else check below.
     See here: https://stackoverflow.com/q/40804131
     */
    if (self.URL != nil) {
        return self.URL;
    } else {
        return nil;
    }
}

@end
