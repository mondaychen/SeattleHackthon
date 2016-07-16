//
//  LISNRSmartListeningManager.h
//  LISNR-SDK-iOS 5.0.0.1 
//
//  Copyright (c) 2015 LISNR. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LISNRService.h"

typedef NS_ENUM(NSInteger, SmartListeningServerStatus) {
    SmartListeningServerStatusUnavailable,
    SmartListeningServerStatusEnabled,
    SmartListeningServerStatusDisabled
};

@protocol LISNRSmartListeningDelegate <NSObject>

/**
 *  Called when LISNRSmartListeningManger is unable to initially make contact with the server to get the smart listening server status and rules ("Configuration"). If unable to reach the server, the SDK will default to not listening and attempt to update it's configuration every 30 minutes. The SDK will not start listening until it successfully updates the smart listening configuration and is within a listening rule.
 *
 *  If LISNRSmartListeningManager has already successfully reached the Portal to configure itself but later becomes unable to reach the Portal while refreshing the configuration, it will continue to follow the initial configuration until it can update via the Portal.
 *
 *  This method is offered so that in the event of a user not having network connectivity you can opt for a default behavior e.g. to end Smart Listening and just start listening on LISNRService.
 */
- (void) unableToUpdateSmartListeningConfiguration;

@end

@interface LISNRSmartListeningManager : NSObject

/**
 *  Returns the LISNRSmartListeningManager singleton object.
 *
 *  @return The LISNRSmartListeningManager singleton.
 */
+ (nonnull instancetype) sharedSmartListeningManager;

/**
 *  Configures LISNRSmartListeningManager. You must call this method on the LISNRSmartListeningManager singleton to use LISNRSmartListeningManager.
 *
 *  @param lisnrService This is always going to be '[LISNRService sharedService]'
 *
 *  @warning You must use this method to initialize an instance of LISNRSmartListeningManager.
 *  @warning You must call this method with the LISNRService sharedService object.
 *  @warning You must call this method on the LISNRSmartListeningManager singleton to use LISNRSmartListeningManager.
 */
- (void) configureWithLISNRService:(nonnull LISNRService *)lisnrService;

/**
 *  When called LISNRSmartListeningManager will check for listening rules and then call 'startListening' on LISNRService if smart listening is enabled and the user is currently within a smart listening period or if smart listening is currently disabled. 'didFailToStartListeningWithError:' will be called on the delegate if unable to start listening. 
 *
 *   Smart Listening Rules are currently updated from the portal every 60 minutes or when the next currently known smart listening rule starts or ends, whichever is shorter.
 *
 *  @warning You should only call beginSmartListening on SmartListeningManager in the block passed as a paramter in the LISNRService instance method configureWithApiKey:completion or after it has been called. Calling beginSmartListening before configureWithApiKey:completion: completes results in undefined behavior.
 *  @warning While smart listening is active do not directly call startListening or stopListening on LISNRService
 *  @warning You must set the LISNRSmartListeningManager delegate before calling this method if you want to receive the didStartListening and didFailToStartListeningWithError: delegate callbacks
 */
- (void) beginSmartListening;

/**
 *  Ends LISNRSmartListeningManager smart listening. If LISNRService is currently listening stopListening will not be called on LISNRService.
 *
 *  @warning You must set the LISNRSmartListeningManager delegate before calling this method if you want to receive the didStopListening callback
 */
- (void) endSmartListening;

/**
 *  Returns whether Smart Listening is currently active on the client. This will be true if you have called 'beginSmartListening' and have not yet ended smart listening.
 */
@property (readonly) BOOL smartListeningActive;

/**
 *  Returns whether smart listening is enabled on the portal. If the portal cannot be reached, returns the status 'SmartListeningServerStatusUnavailable'.
 */
@property (readonly) SmartListeningServerStatus smartListeningServerStatus;

/**
 *  The LISNRSmartListeningDelegate that will be called when listening starts, fails to start, or stops
 */
@property (weak, nonatomic, nullable) id<LISNRSmartListeningDelegate> delegate;

/**
 *  Returns the time period before the chronologically next smart listening rule will be in effect. Returns -1.0 if smart listening is disabled or smart listening is enabled but no current or future smart listening rules are available. Returns 0.0 if you are currently within a Smart Listening rule's time range.
 *
 *  @return An NSTimeInterval that gives the time until the next smart listening rule will be in effect
 */
- (NSTimeInterval) timeIntervalUntilNextSmartListeningSession;

/**
 *  Set timeout time for smart listening in seconds. If a tone is not heard for the length of the timeout period LISNRSmartListeningManager will stop listening and call endSmartListening on itself. Set to 0 or a negative value to disable timeout. Initialized with a value of -1 by initWithLISNRService:. If you update this value the current reset time count is reset to 0.
 */
@property (nonatomic) NSTimeInterval listeningTimeoutTime;

@end
