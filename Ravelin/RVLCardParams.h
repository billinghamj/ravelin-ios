//
//  RVLCardParams.h
//  Ravelin
//
//  Created by James Billingham on 17/06/2016.
//  Copyright © 2016 Cuvva. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RVLCardParams : NSObject

@property (nonatomic) NSString *number;
@property (nonatomic) NSUInteger expiryMonth;
@property (nonatomic) NSUInteger expiryYear;

- (BOOL)setExpiryYearCoerced:(NSUInteger)expiryYear;
- (id)toJSONObjectWithError:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
