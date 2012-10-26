//
//  ClientController.h
//  Demo
//
//  Created by Tzu-Yang Ni on 9/30/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

#define UploadFinishProgress 0.6f
#define DetectFinishProgress 0.8f
#define RecognFinishProgress 0.97f
#define InitialProgress 0.01f

#define RecognitionClientIdKey @"client_id"
#define RecognitionResultBreedNameKey @"breed_names"
#define RecognitionResultSampleIdKey @"sample_ids"
#define DetectionNoseKey @"nose"
#define JsonErrorLabelKey @"error_label"  // -1, error; 0 no error; 1 not an error
#define JsonErrorMessageKey @"error_message"


#define UPLOAD 0
#define DETECT 1
#define RECOG 2
#define REGISTER 3
#define INVITE 4
#define CHECKUPDATE 5
#define CHECKUIQUEACCOUNT 6
#define CREATEACCOUNT 7
#define LOGIN 8

@class ClientController;

@protocol ClientControllerDelegate <NSObject>

- (void)notifyError:(NSString *)title message:(NSString *)message;
- (void)notifyWarning:(NSString *)title message:(NSString *)message;
- (void)setMaxProgressValue:(float)value;
- (void)updateProgressBar;
- (void)requestDetectionResult:(NSString *)client_id_string;
- (void)updateProgressBarWith:(float)value;


- (void)requestCancelled:(ClientController *)controller;
- (void)requestStarted:(ClientController *)controller;
- (void)requestFailed:(ClientController *)controller;
- (void)requestTimeouted:(ClientController *)controller;

- (void)detectionFinished:(ClientController *)controller;
- (void)recognitionFinished:(ClientController *)controller;
- (void)registerFinished:(ClientController *)controller;
- (void)checkUpdateFinished:(ClientController *)controller;
- (void)inviteFinished:(ClientController *)controller;

- (void)checkAccountUniquenessfinished:(BOOL)success;
- (void)createAccountfinished:(BOOL)success;
- (void)loginfinished:(BOOL)success;




@end

@interface ClientController : NSObject <RKRequestDelegate> 

@property (nonatomic, weak) id <ClientControllerDelegate> delegate;
@property (nonatomic, strong) RKClient *client;
@property (nonatomic, strong) RKRequest *request;
@property (nonatomic, strong) NSMutableDictionary *userInfo;
@property (nonatomic, strong) NSString *client_id;
@property int ListenterType;

- (void)requestDetectionResult:(NSString *)client_id_string;
- (void)requestRecognitionResult:(NSString *)client_id_string;
- (void)upload:(UIImage *)img;
- (void)reqisterNewUser:(NSString *)private_id;
- (void)inviteWithCode: (NSString *)code;
- (void)checkUpdateOfUser: (NSString *)privateId;

- (void)checkAccountUniqueness: (NSString *)username;
- (void)createAccount:(NSString *)username andPassword: (NSString *)password;
- (void)logingWithUser:(NSString *)username andPassword: (NSString *)password;


@end
