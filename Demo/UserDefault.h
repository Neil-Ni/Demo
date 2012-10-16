//
//  UserDefault.h
//  Demo
//
//  Created by Tzu-Yang Ni on 10/12/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDefault : NSObject
+ (NSString *)userDefaultPrivateID;
+ (void)savePrivateId:(NSString *)privateId;

+ (int)userType;
+ (void)saveUserType:(int)userType;

+ (NSString *)userInvitationCode;
+ (void)saveInvitationCode:(NSString *)InvitationCode;

+ (int)userFirstTime;
+ (void)saveFirstTime:(int)FirstTime;

@end
