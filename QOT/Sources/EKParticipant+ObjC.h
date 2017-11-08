//
//  EKParticipant+ObjC.h
//  QOT
//
//  Created by Sam Wyndham on 08/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface EKParticipant (ObjC)

- (nullable NSURL *)safeURL;

@end
