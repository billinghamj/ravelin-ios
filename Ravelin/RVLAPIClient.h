//
//  RVLAPIClient.h
//  Ravelin
//
//  Created by James Billingham on 17/06/2016.
//  Copyright © 2016 Cuvva. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RVLCardParams;
@class RVLCardToken;

NS_ASSUME_NONNULL_BEGIN

typedef void (^RVLCardTokenCompletionBlock)(RVLCardToken * _Nullable cardToken, NSError * _Nullable error);

@interface Ravelin : NSObject

+ (nullable NSString *)defaultPublishableKey;
+ (void)setDefaultPublishableKey:(NSString *)publishableKey;

@end

@interface RVLAPIClient : NSObject

+ (instancetype)sharedClient;
- (instancetype)initWithPublishableKey:(NSString *)publishableKey NS_DESIGNATED_INITIALIZER;

- (void)createTokenForCard:(RVLCardParams *)cardParams completion:(RVLCardTokenCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
