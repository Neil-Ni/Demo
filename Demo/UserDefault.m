//
//  UserDefault.m
//  Demo
//
//  Created by Tzu-Yang Ni on 10/12/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import "UserDefault.h"

@implementation UserDefault

+ (NSString *)userDefaultPrivateID{
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    return [standardUserDefaults objectForKey:PRIVATEID];
}
+ (void)savePrivateId:(NSString *)privateId{
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setObject:privateId forKey:PRIVATEID];
    [standardUserDefaults synchronize];
}
+ (int)userType{
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    return [[standardUserDefaults objectForKey:USERTYPE] integerValue];
    
}
+ (void)saveUserType:(int)userType{
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setObject: [NSNumber numberWithInt:userType] forKey:USERTYPE];
    [standardUserDefaults synchronize];
}
    
+ (NSString *)userInvitationCode{
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    return [standardUserDefaults objectForKey:INVITATIONCODE];

}
+ (void)saveInvitationCode:(NSString *)InvitationCode{
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setObject:InvitationCode forKey:INVITATIONCODE];
    [standardUserDefaults synchronize];

}
+ (int)userFirstTime{
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    return [[standardUserDefaults objectForKey:FRISTTIME] integerValue];
    
}
+ (void)saveFirstTime:(int)FirstTime{
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setObject: [NSNumber numberWithInt:FirstTime] forKey:FRISTTIME];
    [standardUserDefaults synchronize];
}

@end
