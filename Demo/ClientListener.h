//
//  ClientListener.h
//  Dogsnap
//
//  Created by Shao-Chuan Wang on 10/28/11.
//  Copyright (c) 2011 Columbia University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface ClientListener :  NSObject <RKRequestDelegate>  {
    NSDictionary *userInfo;
}

@property (nonatomic, assign) UIViewController *controller;
@property (nonatomic, strong) NSDictionary *userInfo;

- (id) initWithController: (UIViewController *) ctr;

@end
