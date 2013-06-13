//
//  DHCCounter.h
//  DHCCounter
//
//  Created by Daniel Haight on 05/06/2013.
//  Copyright (c) 2013 confidence. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DHCEvent(s) [NSString stringWithFormat:@"DHCEventCountChangeForEventName%@",(s)]

@interface DHCCounter : NSObject
+(void)bumpCountForEventName:(NSString *)eventName;
+(void)increaseCountForEventName:(NSString *)eventName byInteger:(NSInteger)integer;
+(NSInteger)countForEventName:(NSString *)eventName;
+(void)setCount:(NSInteger)count ForEventName:(NSString *)eventName;
@end
