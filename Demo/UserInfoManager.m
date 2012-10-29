//
//  UserInfoManager.m
//  Demo
//
//  Created by Tzu-Yang Ni on 10/14/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//


/*
 Each user contains 
    { PRIVATEID : NSSTRING,
      USERNAME : NSSTRING,
      INVITATIONCODE : NSSTRING, -> invitation code should be temporary
      USERTYPE : int,
      FRISTTIME : int,
      INVITATIONSTATUS : Not sure yet
 */
#import "UserInfoManager.h"

@interface UserInfoManager (){
    BOOL firstTime;
    int UserType;
    BOOL invitationStatus;
    int family_id;
}

@end

@implementation UserInfoManager
@synthesize privateId, invitationCode, userName;

static UserInfoManager *sharedInstance = nil;

+ (UserInfoManager *)sharedInstance {
    if (nil != sharedInstance) {
        return sharedInstance;
    }
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[UserInfoManager alloc] init];
    });
    return sharedInstance;
}


- (void) fetchUserDefault{
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    self.privateId = [standardUserDefaults objectForKey:PRIVATEID];
    self.userName = [standardUserDefaults objectForKey:USERNAME];
    UserType = [[standardUserDefaults objectForKey:USERTYPE] integerValue];
    family_id = [[standardUserDefaults objectForKey:FAMILYID] integerValue];
    self.invitationCode = [standardUserDefaults objectForKey:INVITATIONCODE];
    firstTime = ([[standardUserDefaults objectForKey:FRISTTIME] integerValue] == 0);
    invitationStatus = ([[standardUserDefaults objectForKey:INVITATIONSTATUS] integerValue] == 1);
}

- (void)setFamilyid:(int)familyid{
    family_id = familyid;
}

- (void)setUserType:(int)userType{
    UserType = userType;
}
- (void)setInvited{
    invitationStatus = true;
}
- (void)setUnInvited{
    invitationStatus = false;
}

- (BOOL)isInvited{
    return invitationStatus;
}
- (BOOL)isFirstTime{
    return firstTime;
}
- (BOOL)isGrandMa{
    return UserType == userTypeGrandMa;
}
- (BOOL)isGrandSon{
    return UserType == userTypeGrandSon;
}
- (void)setSecondTime{
    firstTime = false;
}

- (void)saveUserDefault{
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setObject:self.privateId forKey:PRIVATEID];
    [standardUserDefaults setObject:self.userName forKey:USERNAME];
    [standardUserDefaults setObject: [NSNumber numberWithInt:UserType] forKey:USERTYPE];
    [standardUserDefaults setObject: [NSNumber numberWithInt:family_id]  forKey:FAMILYID];
    [standardUserDefaults setObject:self.invitationCode forKey:INVITATIONCODE];
    if(self.privateId) firstTime = false;
    int i = (firstTime)? 0: 1;
    [standardUserDefaults setObject: [NSNumber numberWithInt:i] forKey:FRISTTIME];
    i = (invitationStatus)? 1: 0;
    [standardUserDefaults setObject:[NSNumber numberWithInt:i] forKey:INVITATIONSTATUS];
    [standardUserDefaults synchronize];
}
- (void)saveUserDefaultWithPrivateId: (NSString *)pi InvitationCode: (NSString *)ic userType:(int)Ut firstTime: (BOOL) ft{
    
}

- (void)printUserDefault{
    NSLog(@"{ FirstTime: %@ ; invitationCode: %@ ; privateId: %@ ; userType: %@ ; username: %@; invited: %@; familyId %d }",
                    ((firstTime)? @"YES" : @"NO"),
                    self.invitationCode,
                    self.privateId,
                    (UserType==userTypeGrandMa)? @"GrandMa" : @"GrandSon",
                    self.userName,
                    ((invitationStatus)? @"YES" : @"NO"),
                    family_id
          );
}

@end
