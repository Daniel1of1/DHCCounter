#DHCCounter
It counts events, then sends notifications to tell you how many times they happened. Incase you want to do both of those. please note the 0.0.X release at the moment, changes will be breaking… (But likely easy to deal with)

##Installation

###cocoapods

add to your podfile:

```
Pod 'DHCCounter' '~>0.0.1'
```
###manual

>pro-tip use cocoapods

Drag DHCCounter.{m,h} to ~~Xcode~~ your favourite IDE.

##Usage
###Quick Example

```
//subscribe to the notification with the name "DHCEventCountChangeForEventName"+ your event name… this Example uses "MyEvent"
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotMyEventNotification:) name:@"DHCEventCountChangeForEventNameMyEvent" object:nil];
////

//Bump the count
[DHCCounter bumpCountForEventName:@"MyEvent"];

//somewhere else //and we assume the count was previously 0
-(void)gotMyEventNotification:(NSNotification *)notification{
	NSLog(@"count for MyEvent: %i",[notification.userInfo objectForKey:@"count"]); // logs 'count for MyEvent: 1'
}

```

###(un)subscribing to an event
when a count changes it is broadcast over NSNotificationCenter. So just follow the process of subscribing to an NSNotification. 

You choose your event names and the name of the notification changes accordingly. 

If you name your event `CheckBalance` then the notification posted to notification center will be called `DHCEventCountChangeForEventNameCheckBalance` or in code you might do something like this

```
NSString *const eventName = @"CheckBalance";

//subscribe
- (void)viewDidAppear:(BOOL)animated{
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotNotification:) name:[NSString stringWithFormat:@"DHCEventCountChangeForEventName%@",eventName] object:nil];
}

//unsubscribe!!
- (void)viewDidDisappear:(BOOL)animated{
 	[[NSNotificationCenter defaultCenter] removeObserver:notificationCatcher name:[NSString stringWithFormat:@"DHCEventCountChangeForEventName%@",eventName] object:nil];
}
	
```

##getting/ setting count

###get count for eventName

```
NSInteger countForEvent=[DHCCounter countForEventName:@"someEventName"];

```
###set count for eventName
there are a few ways to set count for convenience

```
NSString *eventName=@"someEventName"

[DHCCounter bumpCountForEventName:eventName]; //increases count by one

[DHCCounter increaseCountForEventName:eventName byInteger:6]; //increase by a given NSInteger eg. 6

[DHCCounter setCount:22 ForEventName:eventName] // set count to a given NSInteger eg. 22
```
###Acting on a change

after subsctribing to a notification for a specific event notification and defining a seector (in our example: `gotNotification:`) , you receive an NSNotification as the input parameter… this seems like a sensible place to tell you the count of the event once it has been changed… so we do.

```
-(void)gotNotification:(NSNotification *)notification{
	NSInteger count=notification.userInfo objectForKey:@"count";
	
	if (count > 9000) {	
		//do your stuff once user has done a thing 9000 times
	}

}

```

Takeaway point: the count of the event is contained in the `userInfo` dictionary of the NSNotification with the key `@"count"`


