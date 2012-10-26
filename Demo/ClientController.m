//
//  ClientController.m
//  Demo
//
//  Created by Tzu-Yang Ni on 9/30/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import "ClientController.h"
#import "NetworkUtility.h"

#define kErrorUploadResponseIsNotJson @"We cannot process your request due to internal server error."
#define kErrorUploadResponseWrongFormat @"We cannot process your request due to the fact that the returned data format are wrong."
#define kErrorUploadTimeout @"The uploading request is timed out. Please try again later."
#define kErrorDetectionResponseIsNotJson @"We cannot process your request due to internal server error."
#define kErrorDetectionIsDown @"Our recognition module is down.:("
#define kErrorDetectionWrongFormat @"Server internal error."
#define kErrorDetectionTimeout @"The recognition request is timed out. Please try again later."
#define kErrorRecognitionResponseIsNotJson @"We cannot process your request due to internal server error."
#define kErrorRecognitionResponseWrongFormat @"Server internal error."
#define kErrorRecognitionTimeout @"The recognition request is timed out. Please try again later."

@interface ClientController ()

- (void)_httpConnect:(UIImage *)img;
- (NSInteger)_checkReturnedError:(id)error_label withMessage:(NSString *)error_msg;
- (void) detectionFinished;

@end

@implementation ClientController
@synthesize delegate, userInfo, client, request, client_id;

- (id)init{
    self = [super init];
    return self;
}

- (void)requestDetectionResult:(NSString *)client_id_string{
    if (!self.client)
        self.client = [RKClient clientWithBaseURL:[NSURL URLWithString:ServerURL]];

    NSString *resourceURL = [NSString stringWithFormat: ServerDetectionURI, client_id_string];
    NSLog(@"requesting: %@", resourceURL);
    self.userInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:client_id_string, RecognitionClientIdKey, nil];
    self.request = [self.client get:resourceURL delegate:self];
    self.request? NSLog(@"WORKS"):NSLog(@"NOT WORKS");
    self.request.backgroundPolicy = RKRequestBackgroundPolicyRequeue;
}
- (void)requestRecognitionResult:(NSString *)client_id_string{
    if (!self.client)
        self.client = [RKClient clientWithBaseURL:[NSURL URLWithString:ServerURL]];

    NSString *resourceURL = [NSString stringWithFormat: ServerRecognitionResultURI, client_id_string];
    NSLog(@"requesting: %@", resourceURL);
    self.request = [self.client get:resourceURL delegate: self];
    self.request.backgroundPolicy = RKRequestBackgroundPolicyRequeue;

}

#pragma mark error messages handling

- (NSInteger)_checkReturnedError:(id)error_label withMessage:(NSString *)error_msg {
    if (!error_msg ||
        !error_label)
        return 0;
    
    NSString *error_label_string = [NSString stringWithFormat:@"%@", error_label];
    NSInteger err_type = [error_label_string integerValue];
    
    NSLog(@"error type: %d, error_msg: %@", err_type, error_msg);
    
    if ([error_msg length] > 0){
        
        if (err_type > 0){
            [self.delegate notifyWarning:@"Huh?" message:error_msg];
        } else if (err_type < 0) {
            
            [self.delegate notifyError:@"Oops! Sorry!" message:error_msg];
            [self.delegate requestFailed:self];
            return err_type;
        }
    }

    return 0;
}

#pragma mark LOGIN
- (void)logingWithUser: (NSString *)username andPassword: (NSString *)password{
    RKParams *params = [RKParams params];
    [params setValue:username forParam:@"user_name"];
    [params setValue:password forParam:@"pass_word"];
    
    self.request = [self.client post:ServerLogin params:params delegate:self];
    self.request.backgroundPolicy = RKRequestBackgroundPolicyRequeue;    
}

- (void)loginfinished:(BOOL)success{
    [self.delegate loginfinished: success];
}

#pragma make CREATEACCOUNT
- (void)createAccount:(NSString *)username andPassword: (NSString *)password{
    RKParams *params = [RKParams params];
    [params setValue:username forParam:@"user_name"];
    [params setValue:password forParam:@"pass_word"];
    
    self.request = [self.client post:ServerCreateAccount params:params delegate:self];
    self.request.backgroundPolicy = RKRequestBackgroundPolicyRequeue;

}
- (void)createAccountfinished:(BOOL)success{
    [self.delegate createAccountfinished: success];
}


#pragma mark CHECKUIQUEACCOUNT
- (void)checkAccountUniqueness: (NSString *)username{
    RKParams *params = [RKParams params];
    [params setValue:username forParam:@"user_name"];
    self.request = [self.client post:ServerCheckUserUniqueness params:params delegate:self];
    self.request.backgroundPolicy = RKRequestBackgroundPolicyRequeue;
}
- (void)checkAccountUniquenessfinished:(BOOL)success{
    [self.delegate checkAccountUniquenessfinished: success];
}

#pragma mark INVITE

- (void)inviteWithCode: (NSString *)code{
    if (!self.client)
        self.client = [RKClient clientWithBaseURL:[NSURL URLWithString:ServerURL]];
    RKParams *params = [RKParams params];
    self.userInfo = [[NSMutableDictionary alloc] init];
    [params setValue:code forParam:@"invitation_code"];
    self.request = [self.client post: ServerGrandsonURI params:params delegate:self];
    NSLog(@"requested: %@, nil? %d", ServerGrandsonURI, self.request == nil);
    self.request.backgroundPolicy = RKRequestBackgroundPolicyRequeue;
    
}

- (void)invitefinished{
    [self.delegate inviteFinished:self];
}

#pragma mark REGISTER

- (void)reqisterNewUser:(NSString *)private_id{
    if (!self.client)
        self.client = [RKClient clientWithBaseURL:[NSURL URLWithString:ServerURL]];
    
    self.userInfo = [[NSMutableDictionary alloc] init];
    RKParams *params = [RKParams params];
    if(private_id){
        [params setValue:private_id forParam:@"private_id"];
    }else{
            [params setValue:@"-1" forParam:@"private_id"];
    }
    self.request = [self.client post: ServerGrandma params:params delegate:self];
    NSLog(@"requested: %@, nil? %d", ServerGrandma, self.request == nil);

//    self.request = [self.client post: ServerUploadURI params:params delegate:self];
//    NSLog(@"requested: %@, nil? %d", ServerUploadURI, self.request == nil);
    self.request.backgroundPolicy = RKRequestBackgroundPolicyRequeue;

}

- (void)registerfinished{
    [self.delegate registerFinished:self];
}


#pragma mark CHECKUPDATE

- (void)checkUpdateOfUser: (NSString *)privateId{
    if (!self.client)
        self.client = [RKClient clientWithBaseURL:[NSURL URLWithString:ServerURL]];
    self.userInfo = [[NSMutableDictionary alloc] init];
    RKParams *params = [RKParams params];
    [params setValue:privateId forParam:@"private_id"];
    self.request = [self.client post: ServerUploadURI params:params delegate:self];
    NSLog(@"requested: %@, nil? %d", ServerUploadURI, self.request == nil);
    self.request.backgroundPolicy = RKRequestBackgroundPolicyRequeue;

}
- (void)checkUpdateFinished{
    [self.delegate checkUpdateFinished:self];    
}

#pragma mark UPLOAD


- (void) upload:(UIImage *)img {
    NSLog(@"Upload");
    
    if (!img) {
        [self.delegate notifyError: @"Invalid image"
                           message: @"We have some problems in uploading your images."];
        [self.delegate requestFailed:self];
        return;
    }
    if ([NetworkUtility connectedToNetwork] == NO) {
        [self.delegate notifyError: @"No internet connection"
                           message: @"Please check your network status and try again."];
        [self.delegate requestFailed:self];
        return;
    }
    [self performSelector:@selector(_httpConnect:) withObject:img afterDelay:0.1f];
}


- (void)_httpConnect:(UIImage *)img
{
    //
    // lazily create the client.
    //
    
    if (!self.client)
        self.client = [RKClient clientWithBaseURL:[NSURL URLWithString:ServerURL]];
    
    RKParams *params = [RKParams params];
//    NSString *noseStr = [NSString stringWithFormat: @"%.0f,%.0f", 0.0, 0.0];
    //Comment this method because the version right now is just for testing, no need for the point of nose.
//    NSString *noseStr = [NSString stringWithFormat: @"%.0f,%.0f", nosePoint.x, nosePoint.y];
    
//    [params setValue: noseStr forParam: DetectionNoseKey];
    

    RKParamsAttachment *attachment = [params setData:UIImageJPEGRepresentation(img, 75) MIMEType:@"image/jpeg" forParam:@"uploadFile"];
    attachment.fileName = @"image.jpg";
    [params setValue:@"0" forParam:@"page"];
    [params setValue:@"0" forParam:@"photoid"];
    [params setValue:@"0" forParam:@"albumid"];

    self.request = [self.client post: ServerUploadURI params:params delegate:self];
    
    NSLog(@"requested: %@, nil? %d", ServerUploadURI, self.request == nil);
    
    self.request.backgroundPolicy = RKRequestBackgroundPolicyRequeue;
    return;
}


#pragma mark DETECT

- (void)detectionFinished{
    if (self.userInfo) {
        id error_label = [self.userInfo objectForKey: JsonErrorLabelKey];
        NSString *error_msg = [self.userInfo objectForKey: JsonErrorMessageKey];
        NSLog(@"[detection finished] error: %@, error_msg: %@", error_label, error_msg);
        // error occurred, then do not continued;
        if ([self _checkReturnedError: error_label withMessage: error_msg] < 0)
            return;
    }
    NSLog(@"[detection finished] note's userInfo: %@", self.userInfo);
    [self.delegate detectionFinished:self];
}


#pragma mark RECOG
- (void)recognitionFinished{
    if(self.userInfo){
        id error_label = [self.userInfo objectForKey: JsonErrorLabelKey];
        NSString *error_msg = [self.userInfo objectForKey: JsonErrorMessageKey];
        
        // error occurred, then do not continued;
        if ([self _checkReturnedError: error_label withMessage: error_msg] < 0)
            return;
        [self.delegate recognitionFinished:self];
        
//        
//        DetectionResult *detectResult = [self _parseDetectionResult:userInfo];
//        
//        NSError *error=nil;
//        [self _saveSnapItResultsWithClientId:client_id
//                                      breeds:breeds
//                                   sampleIds:sample_ids
//                             detectionResult:detectResult
//                                       image:self.pickedImg
//                                       error:&error];
//        if (error) {
//            
//            NSLog(@"Save the snap results failed!");
//        }
//
//        RecognitionRankingViewController_iPhone *rankingView = [[RecognitionRankingViewController_iPhone alloc] initWithNibName:@"RecognitionRankingViewController_iPhone" bundle:nil];
//        
//        [rankingView setBreedNames:breeds AndSampleIDs:sample_ids];
//        rankingView.detectResult = detectResult;
//        rankingView.pickedImg = self.pickedImg;
//        rankingView.client_id = client_id;
//        rankingView.windowMessageQueue = self.windowMessageQueue;
//        //
//        // release the picked image because it eats memory.
//        //
//        self.pickedImg = nil;
//        [self.navigationController pushViewController:rankingView animated:YES];
    }
}









#pragma mark OVERLAPPING Methods

// This method
- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error{
    switch (self.ListenterType) {
        case REGISTER:{
            [self.delegate notifyError:@"registeration failed"
                               message:error.localizedDescription];
            [self.delegate requestFailed:self];
        }
            break;
        case INVITE:{
            [self.delegate notifyError:@"invate failed"
                               message:error.localizedDescription];
            [self.delegate requestFailed:self];
        }
            break;
        case CHECKUPDATE:{
            [self.delegate notifyError:@"updatecheck failed"
                               message:error.localizedDescription];
            [self.delegate requestFailed:self];
        }
        case UPLOAD:{
            [self.delegate notifyError:@"Could not upload your image"
                               message:error.localizedDescription];
            [self.delegate requestFailed:self];
        }
            break;
        case DETECT:{
            [self.delegate notifyError: @"Sorry! :("
                               message: error.localizedDescription];
            [self.delegate requestFailed:self];
        }
            break;
        case RECOG:{
            [self.delegate notifyError: @"Sorry! :-("
                               message: error.localizedDescription];
            [self.delegate requestFailed:self];
        }
            break;
        default:
            break;
    }
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
    
    NSLog(@"%@", response.bodyAsString);
    
    if (![response isJSON]) {
        [self.delegate notifyError:@"Sorry!"
                           message:kErrorUploadResponseIsNotJson];
        [self.delegate requestFailed:self];
        return;
    }
    NSDictionary *d = [response parsedBody:nil];
    if (!d) {
        [self.delegate notifyError:@"Sorry!"
                           message:kErrorUploadResponseWrongFormat];
        [self.delegate requestFailed:self];
        return;
    }
    /*1012 assuming different kind of error messages*/
    id error_label = [d objectForKey: JsonErrorLabelKey];
    NSString *error_msg = [d objectForKey: JsonErrorMessageKey];
    NSLog(@"[Listener finished] error: %@, error_msg: %@", error_label, error_msg);
    
    // error occurred, then do not continued;
    if ([self _checkReturnedError: error_label withMessage: error_msg] < 0)
        return;

    switch (self.ListenterType) {
        case LOGIN:{
            BOOL success = FALSE;
            if([d objectForKey:@"successful_message"]){
                success = TRUE;
            }
            [self loginfinished: success];

        }
            break;
        case CHECKUIQUEACCOUNT:{
            BOOL success = FALSE;
            if([d objectForKey:@"successful_message"]){
                success = TRUE;
            }
            [self checkAccountUniquenessfinished: success];
        }
            break;
        case CREATEACCOUNT:{
            BOOL success = FALSE;
            if([d objectForKey:@"successful_message"]){
                success = TRUE;
            }
            [self createAccountfinished: success];
        }
            break;
        case REGISTER:{
            [self.userInfo addEntriesFromDictionary:d];
            [self registerfinished];
        }
            break;
        case CHECKUPDATE:{
            [self.userInfo addEntriesFromDictionary:d];
            [self checkUpdateFinished];
        }
            break;
        case INVITE:{
            [self.userInfo addEntriesFromDictionary:d];
            [self invitefinished];
        }
            break; 
        case UPLOAD:{
            if (![response isJSON]) {
                [self.delegate notifyError:@"Sorry!"
                                   message:kErrorUploadResponseIsNotJson];
                [self.delegate requestFailed:self];
                return;
            }
            NSDictionary *d = [response parsedBody:nil];
            if (!d) {
                [self.delegate notifyError:@"Sorry!"
                                   message:kErrorUploadResponseWrongFormat];
                [self.delegate requestFailed:self];
                return;
            }
            
            id error_label = [d objectForKey: JsonErrorLabelKey];
            NSString *error_msg = [d objectForKey: JsonErrorMessageKey];
            NSLog(@"[upload finished] error: %@, error_msg: %@", error_label, error_msg);
            
            // error occurred, then do not continued;
            if ([self _checkReturnedError: error_label withMessage: error_msg] < 0)
                return;
            
            NSString *client_id_string = [NSString stringWithFormat:@"%@", [d objectForKey:RecognitionClientIdKey]];
            
            NSLog(@"client_id: %@", client_id_string);
            [self.delegate updateProgressBarWith:1.0f];
            [self.delegate updateProgressBar];
//            [self.delegate setMaxProgressValue: DetectFinishProgress];
//            [self.delegate updateProgressBar];
//            [self.delegate requestDetectionResult: client_id_string];
        }
            break;
        case DETECT:{
            NSLog(@"[detection] finished, OK? %d", [response isOK]);
            NSLog(@"[detection] isJson? %d", [response isJSON]);
            NSLog(@"[detection] what is it? %@", [response MIMEType]);
            if (![response isJSON]){
                [self.delegate notifyError:@"Sorry!"
                                   message:kErrorDetectionResponseIsNotJson];
                [self.delegate requestFailed:self];
                return;
            }
            
            NSString *responseString = [response bodyAsString];
            NSLog(@"response string: %@", responseString);
            
            if ([responseString hasPrefix:@"null"]){
                [self.delegate notifyError:@"Sorry!"
                                   message:kErrorDetectionIsDown];
                [self.delegate requestFailed:self];
                return;
            }
            NSDictionary *d = [response parsedBody:nil];
            if (!d) {
                [self.delegate notifyError:@"Sorry!" message:kErrorDetectionWrongFormat];
                [self.delegate requestFailed:self];
                return;
            }
            
            [self.delegate setMaxProgressValue: RecognFinishProgress];
            [self detectionFinished];
        }
            break;
        case RECOG:{
            NSLog(@"finished, OK? %d", [response isOK]);
            NSLog(@"isJson? %d", [response isJSON]);
            NSLog(@"what is it? %@", [response MIMEType]);
            if (![response isJSON]) {
                [self.delegate notifyError:@"Sorry!" message:kErrorRecognitionResponseIsNotJson];
                [self.delegate requestFailed:self];
                return;
            }
            
            NSDictionary *d = [response parsedBody:nil];
            if (!d) {
                [self.delegate notifyError:@"Sorry!" message:kErrorRecognitionResponseWrongFormat];
                [self.delegate requestFailed:self];
                return;
            }
            
            //
            // merge the previous results (saved in self.userInfo) with the new recognition resutls
            //
//            NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithDictionary: self.userInfo
//                                                                                copyItems: YES];
//            [result addEntriesFromDictionary: d];
            [self.userInfo addEntriesFromDictionary:d];
            [self recognitionFinished];
        }
            break;
        default:
            break;
    }
    
}

- (void)request:(RKRequest *)request didReceivedData:(NSInteger)bytesReceived totalBytesReceived:(NSInteger)totalBytesReceived totalBytesExectedToReceive:(NSInteger)totalBytesExpectedToReceive
{
    switch (self.ListenterType) {
        case REGISTER:{
            NSLog(@"Registered");
        }
            break;
        case CHECKUPDATE:{
            NSLog(@"updatechecked");
        }
            break;
        case INVITE:{
            NSLog(@"invited");
        }
            break;

        case UPLOAD:{
            NSLog(@"received: %d, %d", totalBytesReceived, totalBytesExpectedToReceive);
        }
            break;
        case DETECT:{
            NSLog(@"detect received");
        }
            break;
        case RECOG:{
            NSLog(@"recog receoved");
        }
            break;
        default:
            break;
    }
}

- (void)request:(RKRequest *)request didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    switch (self.ListenterType) {
        case REGISTER:{
            NSLog(@"register sent");
        }
            break;
        case CHECKUPDATE:{
            NSLog(@"updatecheck sent");
        }
            break;
        case INVITE:{
            NSLog(@"invite sent");
        }
            break;
        case UPLOAD:{
            float p = (float)totalBytesWritten/(float)totalBytesExpectedToWrite;
            [self.delegate updateProgressBarWith: p];
        }
            break;
        case DETECT:{
            NSLog(@"detect sent");
        }
            break;
        case RECOG:{
            NSLog(@"recog sent");
        }
            break;
        default:
            break;
    }
}

- (void)requestDidCancelLoad:(RKRequest *)request
{
    [self.delegate requestCancelled:self];
}

- (void)requestDidStartLoad:(RKRequest *)request
{
    switch (self.ListenterType) {
        case REGISTER:{
            NSLog(@"register started");
        }
            break;
        case CHECKUPDATE:{
            NSLog(@"updatecheck started");
        }
            break;
        case INVITE:{
            NSLog(@"invite started");
        }
            break;

        case UPLOAD:{
            [self.delegate requestStarted:self];
        }
            break;
        case DETECT:{
            NSLog(@"detect started");
        }
            break;
        case RECOG:{
            NSLog(@"recog started");
        }
            break;
        case CHECKUIQUEACCOUNT:{
            NSLog(@"checkuniqueaccount started");
        }
            break;
        default:
            break;
    }
}

- (void)requestDidTimeout:(RKRequest *)request
{
    [self.delegate requestTimeouted:self];
    switch (self.ListenterType) {
        case REGISTER:{
            [self.delegate notifyError:@"Register Timeout" message:kErrorUploadTimeout];
        }
            break;
        case CHECKUPDATE:{
            [self.delegate notifyError:@"updatecheck Timeout" message:kErrorUploadTimeout];
        }
            break;
        case INVITE:{
            [self.delegate notifyError:@"invite Timeout" message:kErrorUploadTimeout];
        }
            break;

        case UPLOAD:{
            [self.delegate notifyError:@"Upload Request Timeout" message:kErrorUploadTimeout];
        }
            break;
        case DETECT:{
            [self.delegate notifyError:@"Request Timeout!" message:kErrorDetectionTimeout];
        }
            break;
        case RECOG:{
            [self.delegate notifyError: @"Request Timeout." message: kErrorRecognitionTimeout];
        }
            break;
        case CHECKUIQUEACCOUNT:{
            [self.delegate notifyError: @"checkuniqueaccount Timeout." message: kErrorRecognitionTimeout];
        }
            break;

        default:
            break;
    }
    [self.delegate requestFailed:self];
}
@end
