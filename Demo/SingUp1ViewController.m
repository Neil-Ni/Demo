//
//  SingUp1ViewController.m
//  Demo
//
//  Created by Tzu-Yang Ni on 10/29/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import "SingUp1ViewController.h"

@implementation SingUp1ViewController
@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Back:(id)sender {
    [self.delegate LeaveSingUp1View:self];
}

- (IBAction)WaitForInvitation:(id)sender {
    [self.delegate WaitForInvitation:self];
}

- (IBAction)StartAChannel:(id)sender {
    [self.delegate StartAChannel:self];
}

- (IBAction)ShowInfo:(id)sender {
    [self.delegate ShowInfo:self];
}
@end
