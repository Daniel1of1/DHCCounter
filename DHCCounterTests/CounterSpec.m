//
//  CounterSpec.m
//  DHCCounter
//
//  Created by Daniel Haight on 05/06/2013.
//  Copyright 2013 confidence. All rights reserved.
//

#import "Kiwi.h"
#import "DHCCounter.h"

@interface NotificationCatcher : NSObject
-(void)gotNotification:(NSNotification *)notification;

@property (nonatomic, strong) NSDictionary *userInfo;
@end

@implementation NotificationCatcher

-(void)gotNotification:(NSNotification *)notification{
    self.userInfo=notification.userInfo;
}

@end

SPEC_BEGIN(CounterSpec)

describe(@"counter", ^{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *eventName=@"testEvent";
    NSString *eventKey=[NSString stringWithFormat:@"DHCEvents-%@",eventName];
    
    NSInteger startingInt = 5;
    
    NotificationCatcher *notificationCatcher=[[NotificationCatcher alloc] init];
    
    beforeAll(^{
        [NSUserDefaults resetStandardUserDefaults];
        [[NSNotificationCenter defaultCenter] addObserver:notificationCatcher selector:@selector(gotNotification:) name:@"DHCEventCountChangeForEventNametestEvent" object:nil];
    });
    
    beforeEach(^{
        [defaults setInteger:startingInt forKey:eventKey];
        notificationCatcher.userInfo=nil;
    });
    
    it(@"gets corect count for an event name", ^{
        NSInteger testInt = [DHCCounter countForEventName:eventName];
        [[theValue(testInt) should] equal:theValue(startingInt)];
    });
    
    it(@"sets correct count for an event name", ^{
        NSInteger correctInt = 7;
        [DHCCounter setCount:correctInt ForEventName:eventName];
        NSInteger testInt=[defaults integerForKey:eventKey];
        [[theValue(testInt) should] equal:theValue(correctInt)];
    });
    
    it(@"bumps the eventcount of a given name", ^{
        [DHCCounter bumpCountForEventName:eventName];
        NSInteger testInt=[defaults integerForKey:eventKey];
        [[theValue(testInt) should] equal:theValue(startingInt+1)];
    });
    
    
    it(@"increases an event count by a givin integer", ^{
        NSInteger increase=5;
        [DHCCounter increaseCountForEventName:eventName byInteger:increase];
        NSInteger testInt=[defaults integerForKey  :eventKey];
        [[theValue(testInt) should] equal:theValue(startingInt+increase)];
    });
    
    context(@"receiving notifications", ^{
        it(@"sends notification when count bumps", ^{
            [[notificationCatcher should] receive:@selector(gotNotification:)];
            [DHCCounter bumpCountForEventName:eventName];
        });

        it(@"sends notification when count increases", ^{
            [[notificationCatcher should] receive:@selector(gotNotification:)];
            [DHCCounter increaseCountForEventName:eventName byInteger:4];
        });

    });
    
    context(@"received notifications", ^{
        it(@"contains the correct count in userInfo", ^{
            [DHCCounter bumpCountForEventName:eventName];
            [[theValue([[notificationCatcher.userInfo objectForKey:@"count"] intValue]) should] equal:theValue(startingInt+1)];
        });
    });
    
});

SPEC_END
