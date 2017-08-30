//
//  appAPIClient.h
//  Zhong Rui
//
//  Created by Ziyao Yang on 8/5/15.
//  Copyright (c) 2015 Ziyao Yang. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface AppAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;
+ (instancetype)sharedResponseDataClient;
+ (instancetype)sharedJSONClient;

@end