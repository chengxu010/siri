//
//  IntentHandler.m
//  TestSiriIntents
//
//  Created by dongzhiqiang on 2018/12/13.
//  Copyright © 2018 dongzhiqiang. All rights reserved.
//

#import "IntentHandler.h"

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

@interface IntentHandler () <INSendMessageIntentHandling, INSearchForMessagesIntentHandling, INSetMessageAttributeIntentHandling,INStartWorkoutIntentHandling,INPauseWorkoutIntentHandling,INEndWorkoutIntentHandling,INCancelWorkoutIntentHandling>

@end

@implementation IntentHandler

- (id)handlerForIntent:(INIntent *)intent {
    // This is the default implementation.  If you want different objects to handle different intents,
    // you can override this and return the handler you want for that particular intent.
    
    return self;
}

#pragma mark - INSendMessageIntentHandling

// Implement resolution methods to provide additional information about your intent (optional).
- (void)resolveRecipientsForSendMessage:(INSendMessageIntent *)intent with:(void (^)(NSArray<INSendMessageRecipientResolutionResult *> *resolutionResults))completion {
    NSArray<INPerson *> *recipients = intent.recipients;
    // If no recipients were provided we'll need to prompt for a value.
    if (recipients.count == 0) {
        completion(@[[INSendMessageRecipientResolutionResult needsValue]]);
        return;
    }
    NSMutableArray<INSendMessageRecipientResolutionResult *> *resolutionResults = [NSMutableArray array];
    
    for (INPerson *recipient in recipients) {
        NSArray<INPerson *> *matchingContacts = @[recipient]; // Implement your contact matching logic here to create an array of matching contacts
        if (matchingContacts.count > 1) {
            // We need Siri's help to ask user to pick one from the matches.
            [resolutionResults addObject:[INSendMessageRecipientResolutionResult disambiguationWithPeopleToDisambiguate:matchingContacts]];

        } else if (matchingContacts.count == 1) {
            // We have exactly one matching contact
            [resolutionResults addObject:[INSendMessageRecipientResolutionResult successWithResolvedPerson:recipient]];
        } else {
            // We have no contacts matching the description provided
            [resolutionResults addObject:[INSendMessageRecipientResolutionResult unsupported]];
        }
    }
    completion(resolutionResults);
}

- (void)resolveContentForSendMessage:(INSendMessageIntent *)intent withCompletion:(void (^)(INStringResolutionResult *resolutionResult))completion {
    NSString *text = intent.content;
    NSLog(@"[siri text] %@",text);
    if (text && ![text isEqualToString:@""]) {
        completion([INStringResolutionResult successWithResolvedString:text]);
    } else {
        completion([INStringResolutionResult needsValue]);
    }
}

// Once resolution is completed, perform validation on the intent and provide confirmation (optional).

- (void)confirmSendMessage:(INSendMessageIntent *)intent completion:(void (^)(INSendMessageIntentResponse *response))completion {
    // Verify user is authenticated and your app is ready to send a message.
    
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:NSStringFromClass([INSendMessageIntent class])];
    INSendMessageIntentResponse *response = [[INSendMessageIntentResponse alloc] initWithCode:INSendMessageIntentResponseCodeReady userActivity:userActivity];
    completion(response);
}

// Handle the completed intent (required).

- (void)handleSendMessage:(INSendMessageIntent *)intent completion:(void (^)(INSendMessageIntentResponse *response))completion {
    // Implement your application logic to send a message here.
    
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:NSStringFromClass([INSendMessageIntent class])];
    INSendMessageIntentResponse *response = [[INSendMessageIntentResponse alloc] initWithCode:INSendMessageIntentResponseCodeSuccess userActivity:userActivity];
    completion(response);
}

// Implement handlers for each intent you wish to handle.  As an example for messages, you may wish to also handle searchForMessages and setMessageAttributes.

#pragma mark - INSearchForMessagesIntentHandling

- (void)handleSearchForMessages:(INSearchForMessagesIntent *)intent completion:(void (^)(INSearchForMessagesIntentResponse *response))completion {
    // Implement your application logic to find a message that matches the information in the intent.
    
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:NSStringFromClass([INSearchForMessagesIntent class])];
    INSearchForMessagesIntentResponse *response = [[INSearchForMessagesIntentResponse alloc] initWithCode:INSearchForMessagesIntentResponseCodeSuccess userActivity:userActivity];
    // Initialize with found message's attributes
    response.messages = @[[[INMessage alloc]
        initWithIdentifier:@"identifier"
        content:@"I am so excited about SiriKit!"
        dateSent:[NSDate date]
        sender:[[INPerson alloc] initWithPersonHandle:[[INPersonHandle alloc] initWithValue:@"sarah@example.com" type:INPersonHandleTypeEmailAddress] nameComponents:nil displayName:@"Sarah" image:nil contactIdentifier:nil customIdentifier:nil]
        recipients:@[[[INPerson alloc] initWithPersonHandle:[[INPersonHandle alloc] initWithValue:@"+1-415-555-5555" type:INPersonHandleTypePhoneNumber] nameComponents:nil displayName:@"John" image:nil contactIdentifier:nil customIdentifier:nil]]
    ]];
    completion(response);
}

#pragma mark - INSetMessageAttributeIntentHandling

- (void)handleSetMessageAttribute:(INSetMessageAttributeIntent *)intent completion:(void (^)(INSetMessageAttributeIntentResponse *response))completion {
    // Implement your application logic to set the message attribute here.
    
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:NSStringFromClass([INSetMessageAttributeIntent class])];
    INSetMessageAttributeIntentResponse *response = [[INSetMessageAttributeIntentResponse alloc] initWithCode:INSetMessageAttributeIntentResponseCodeSuccess userActivity:userActivity];
    completion(response);
}

- (void)handlePauseWorkout:(nonnull INPauseWorkoutIntent *)intent completion:(nonnull void (^)(INPauseWorkoutIntentResponse * _Nonnull))completion {
    
}

- (void)handleEndWorkout:(nonnull INEndWorkoutIntent *)intent completion:(nonnull void (^)(INEndWorkoutIntentResponse * _Nonnull))completion {
    
}

- (void)handleCancelWorkout:(nonnull INCancelWorkoutIntent *)intent completion:(nonnull void (^)(INCancelWorkoutIntentResponse * _Nonnull))completion {
    
}

- (void)handleStartWorkout:(nonnull INStartWorkoutIntent *)intent completion:(nonnull void (^)(INStartWorkoutIntentResponse * _Nonnull))completion {
    NSLog(@"start workoutName = %@",intent.workoutName);
    
    INSpeakableString *text = intent.workoutName;
    
    NSString *workoutName = [NSString stringWithFormat:@"%@",text];
    
    if (text && ![workoutName isEqualToString:@""])
    {
        completion([INSpeakableStringResolutionResult successWithResolvedString:text]);
        
    } else {
        completion([INSpeakableStringResolutionResult needsValue]);
    }
}

#pragma mark - 解析阶段
//resolve 解析 Intent 参数
//锻炼类型
- (void)resolveWorkoutNameForStartWorkout:(INStartWorkoutIntent *)intent withCompletion:(void (^)(INSpeakableStringResolutionResult * _Nonnull))completion{
    
    NSLog(@"start workoutName = %@",intent.workoutName);
    
    INSpeakableString *text = intent.workoutName;
    
    NSString *workoutName = [NSString stringWithFormat:@"%@",text];
    
    if (text && ![workoutName isEqualToString:@""])
    {
        completion([INSpeakableStringResolutionResult successWithResolvedString:text]);
        
    } else {
        completion([INSpeakableStringResolutionResult needsValue]);
    }
    
}

//锻炼 是否 受限制
- (void)resolveIsOpenEndedForStartWorkout:(INStartWorkoutIntent *)intent withCompletion:(void (^)(INBooleanResolutionResult * _Nonnull))completion{
    
    NSLog(@"isOpenEnded = %@",intent.isOpenEnded);
    
    NSString *workoutName = [NSString stringWithFormat:@"%@",intent.workoutName];
    
    NSNumber *text = intent.isOpenEnded;
    if (text && ![workoutName isEqualToString:@""]) {
        
        //        completion([INBooleanResolutionResult confirmationRequiredWithValueToConfirm:text]);
        completion([INBooleanResolutionResult successWithResolvedValue:text]);
        
    } else {
        completion([INBooleanResolutionResult needsValue]);
    }
}

//锻炼目标
- (void)resolveGoalValueForStartWorkout:(INStartWorkoutIntent *)intent withCompletion:(void (^)(INDoubleResolutionResult * _Nonnull))completion{
    
    NSLog(@"goalValue = %@",intent.goalValue);
    
    NSNumber *text = intent.goalValue;
    if (text && ![text isKindOfClass:[NSNull class]]) {
        //confirmation方法会对用户进行确认询问 是否根据此目标进行锻炼
        //        completion([INDoubleResolutionResult confirmationRequiredWithValueToConfirm:text]);
        completion([INDoubleResolutionResult successWithResolvedValue:[text doubleValue]]);
        
    } else {
        completion([INDoubleResolutionResult needsValue]);
    }
}

//锻炼时间
- (void)resolveWorkoutGoalUnitTypeForStartWorkout:(INStartWorkoutIntent *)intent withCompletion:(void (^)(INWorkoutGoalUnitTypeResolutionResult * _Nonnull))completion{
    
    NSLog(@"workoutGoalUnitType = %ld",(long)intent.workoutGoalUnitType);
    
    INWorkoutGoalUnitType text = intent.workoutGoalUnitType;
    if (text) {
        
        //        completion([INWorkoutGoalUnitTypeResolutionResult confirmationRequiredWithValueToConfirm:INWorkoutGoalUnitTypeMinute]);
        completion([INWorkoutGoalUnitTypeResolutionResult successWithResolvedValue:INWorkoutGoalUnitTypeMinute]);
        
    } else {
        completion([INWorkoutGoalUnitTypeResolutionResult needsValue]);
    }
}

//室内或室外
- (void)resolveWorkoutLocationTypeForStartWorkout:(INStartWorkoutIntent *)intent withCompletion:(void (^)(INWorkoutLocationTypeResolutionResult * _Nonnull))completion{
    
    NSLog(@"workoutLocationType = %ld",(long)intent.workoutLocationType);
    
    INWorkoutLocationType text = intent.workoutLocationType;
    if (text) {
        //        completion([INWorkoutLocationTypeResolutionResult confirmationRequiredWithValueToConfirm:INWorkoutLocationTypeOutdoor]);
        completion([INWorkoutLocationTypeResolutionResult successWithResolvedValue:INWorkoutLocationTypeOutdoor]);
    } else {
        completion([INWorkoutLocationTypeResolutionResult needsValue]);
    }
}

#pragma mark - 确认阶段
//confirm 确认请求 并将 UI展示
- (void)confirmStartWorkout:(INStartWorkoutIntent *)intent completion:(void (^)(INStartWorkoutIntentResponse * _Nonnull))completion{
    
    NSLog(@"start confirm");
    
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:NSStringFromClass([INStartWorkoutIntent class])];
    INStartWorkoutIntentResponse *response = [[INStartWorkoutIntentResponse alloc] initWithCode:INStartWorkoutIntentResponseCodeReady userActivity:userActivity];
    
    completion(response);
}

//#pragma mark - 处理阶段
////handle 处理请求
//- (void)handleStartWorkout:(INStartWorkoutIntent *)intent completion:(void (^)(INStartWorkoutIntentResponse * _Nonnull))completion{
//
//    NSLog(@"start handle");
//
//    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:NSStringFromClass([INStartWorkoutIntent class])];
//
//    NSString *workoutName = [NSString stringWithFormat:@"%@",intent.workoutName];
//
//    NSLog(@"start workoutName = %@",workoutName);
//    //存储相应的字段给NSUserActivity 为后续与主程序通信做准备
//    if ([workoutName isEqualToString:@"跑步"] || [workoutName isEqualToString:@"run"])
//    {
//        userActivity.title = @"start_Running";
//    } else if ([workoutName isEqualToString:@"cycle"])
//    {
//        userActivity.title = @"start_Cycling";
//    } else if ([workoutName isEqualToString:@"walk"])
//    {
//        userActivity.title = @"start_Walking";
//    }
//
//    //code 参数 选择跳到 APP 中 或者其他
//    INStartWorkoutIntentResponse *response = [[INStartWorkoutIntentResponse alloc] initWithCode:INStartWorkoutIntentResponseCodeContinueInApp userActivity:userActivity];
//
//    completion(response);
//}

@end
