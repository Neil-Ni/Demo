//
//  ClientListener.m
//  Dogsnap
//
//  Created by Shao-Chuan Wang on 10/28/11.
//  Copyright (c) 2011 Columbia University. All rights reserved.
//

#import "ClientListener.h"

@implementation ClientListener
@synthesize controller;
@synthesize userInfo;

- (id) initWithController: (UIViewController *) ctr
{
    ClientListener* listener = [self init];
    listener.controller = ctr;
    self.userInfo = nil;
    return listener;
}

@end
