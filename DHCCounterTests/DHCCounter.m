//
//  DHCCounter.m
//  DHCCounter
//
//  Created by Daniel Haight on 05/06/2013.
//  Copyright (c) 2013 confidence. All rights reserved.
//

#import "DHCCounter.h"

@implementation DHCCounter

+(void)bumpCountForEventName:(NSString *)eventName{
    [self increaseCountForEventName:eventName byInteger:1];
}
+(void)increaseCountForEventName:(NSString *)eventName byInteger:(NSInteger)integer{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *eventKey=[NSString stringWithFormat:@"DHCEvents-%@",eventName];
    NSInteger prevCount=[defaults integerForKey:eventKey];
    [defaults setInteger:prevCount+integer forKey:eventKey];
    [defaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"DHCEventCountChangeForEventName%@",eventName] object:self userInfo:@{@"count": [NSNumber numberWithInt:prevCount+integer]}];

}

+(NSInteger)countForEventName:(NSString *)eventName{
    NSString *eventKey=[NSString stringWithFormat:@"DHCEvents-%@",eventName];
    NSInteger count=[[NSUserDefaults standardUserDefaults] integerForKey:eventKey];
    return count;
}

+(void)setCount:(NSInteger)count ForEventName:(NSString *)eventName{
    NSString *eventKey=[NSString stringWithFormat:@"DHCEvents-%@",eventName];
    [[NSUserDefaults standardUserDefaults] setInteger:count forKey:eventKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
