//
//  UserInfoManager.h
//  Demo
//
//  Created by Tzu-Yang Ni on 10/14/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoManager : NSObject

@property (strong, nonatomic) NSString *invitationCode;
@property (strong, nonatomic) NSString *privateId;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *displayName;


+ (UserInfoManager *)sharedInstance;

- (void)fetchUserDefault;
- (void)setUserType:(int)userType;
- (BOOL)isFirstTime;
- (BOOL)isGrandMa;
- (BOOL)isGrandSon;
- (void)setSecondTime;
- (void)saveUserDefault;
- (void)saveUserDefaultWithPrivateId: (NSString *)pi InvitationCode: (NSString *)ic userType:(int)Ut firstTime: (BOOL) ft;
- (void)printUserDefault;
- (void)setInvited;
- (void)setUnInvited; 
- (BOOL)isInvited;
- (void)setFamilyid:(int)familyid;
- (NSString *)getFamilyid;
- (void)logout;
- (int)getLastImageIndex;
- (void)setlastImageIndex:(int)index;

@end
