//
//  RVLCardParams.m
//  Ravelin
//
//  Created by James Billingham on 17/06/2016.
//  Copyright © 2016 Cuvva. All rights reserved.
//

#import "RVLCardParams.h"
#import "RVLError.h"

NS_ASSUME_NONNULL_BEGIN

@implementation RVLCardParams

- (BOOL)setExpiryYearCoerced:(NSUInteger)expiryYear
{
	if (expiryYear < 100)
		expiryYear += 2000;

	if (expiryYear < 2016 || expiryYear > 2100)
		return NO;

	_expiryYear = expiryYear;

	return YES;
}

- (id)toJSONObjectWithError:(NSError **)error
{
	if (!_number || ![self stringIsValidLuhn:_number])
	{
		*error = [NSError errorWithDomain:RVLErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey:@"Invalid number value"}];
		return nil;
	}

	if (_expiryMonth < 1 || _expiryMonth > 12)
	{
		*error = [NSError errorWithDomain:RVLErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey:@"Invalid expiryMonth value"}];
		return nil;
	}

	// probably sane defaults...
	if (_expiryYear < 2016 || _expiryYear > 2100)
	{
		*error = [NSError errorWithDomain:RVLErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey:@"Invalid expiryYear value"}];
		return nil;
	}

	return @
	{
		@"pan":_number,
		@"expiryMonth":@(_expiryMonth),
		@"expiryYear":@(_expiryYear),
	};
}

- (BOOL)stringIsValidLuhn:(NSString *)number
{
	BOOL odd = true;
	int sum = 0;
	NSMutableArray *digits = [NSMutableArray arrayWithCapacity:number.length];

	for (int i = 0; i < (NSInteger)number.length; i++)
		[digits addObject:[number substringWithRange:NSMakeRange(i, 1)]];

	for (NSString *digitStr in [digits reverseObjectEnumerator])
	{
		int digit = digitStr.intValue;
		if ((odd = !odd))
			digit *= 2;
		if (digit > 9)
			digit -= 9;
		sum += digit;
	}

	return sum % 10 == 0;
}

@end

NS_ASSUME_NONNULL_END
