//
//  RVLCardToken.h
//  Ravelin
//
//  Created by James Billingham on 17/06/2016.
//  Copyright © 2016 Cuvva. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RVLCardToken : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithJSONObject:(id)object error:(NSError **)error NS_DESIGNATED_INITIALIZER;

@property (nonatomic) NSString *token;
@property (nonatomic) NSString *bin;
@property (nonatomic) NSString *lastFour;
@property (nonatomic) NSUInteger expiryMonth;
@property (nonatomic) NSUInteger expiryYear;

@end

NS_ASSUME_NONNULL_END
