//
//  RVLCardToken.m
//  Ravelin
//
//  Created by James Billingham on 17/06/2016.
//  Copyright © 2016 Cuvva. All rights reserved.
//

#import "RVLCardToken.h"
#import "RVLError.h"

NS_ASSUME_NONNULL_BEGIN

@implementation RVLCardToken

- (instancetype)initWithJSONObject:(id)object error:(NSError **)error
{
	if (![object isKindOfClass:[NSDictionary class]])
	{
		*error = [NSError errorWithDomain:RVLErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey:@"Invalid object type"}];
		return nil;
	}

	NSString *cardToken = object[@"cardToken"];
	if (![cardToken isKindOfClass:[NSString class]])
	{
		*error = [NSError errorWithDomain:RVLErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey:@"Invalid cardToken field"}];
		return nil;
	}

	NSString *cardBin = object[@"cardBin"];
	if (![cardBin isKindOfClass:[NSString class]])
	{
		*error = [NSError errorWithDomain:RVLErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey:@"Invalid cardBin field"}];
		return nil;
	}

	NSString *cardLastFour = object[@"cardLastFour"];
	if (![cardLastFour isKindOfClass:[NSString class]])
	{
		*error = [NSError errorWithDomain:RVLErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey:@"Invalid cardLastFour field"}];
		return nil;
	}

	NSNumber *expiryMonth = object[@"expiryMonth"];
	if (![expiryMonth isKindOfClass:[NSNumber class]])
	{
		*error = [NSError errorWithDomain:RVLErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey:@"Invalid expiryMonth field"}];
		return nil;
	}

	NSNumber *expiryYear = object[@"expiryYear"];
	if (![expiryYear isKindOfClass:[NSNumber class]])
	{
		*error = [NSError errorWithDomain:RVLErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey:@"Invalid expiryYear field"}];
		return nil;
	}

	if (!(self = [super init]))
		return nil;

	_token = cardToken;
	_bin = cardBin;
	_lastFour = cardLastFour;
	_expiryMonth = expiryMonth.unsignedIntegerValue;
	_expiryYear = expiryYear.unsignedIntegerValue;

	return self;
}

@end

NS_ASSUME_NONNULL_END
