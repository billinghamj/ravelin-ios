//
//  RVLAPIClient.m
//  Ravelin
//
//  Created by James Billingham on 17/06/2016.
//  Copyright © 2016 Cuvva. All rights reserved.
//

#import "RVLAPIClient.h"
#import "RVLCardParams.h"
#import "RVLCardToken.h"
#import "RVLError.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^RVLAPIResponseBlock)(id _Nullable output, NSError * _Nullable error);

static NSString * _Nullable RVLDefaultPublishableKey;

@implementation Ravelin

+ (nullable NSString *)defaultPublishableKey
{
	return RVLDefaultPublishableKey;
}

+ (void)setDefaultPublishableKey:(NSString *)publishableKey
{
	RVLDefaultPublishableKey = publishableKey;
}

@end

@interface RVLAPIClient () <NSURLSessionDelegate>

@property (nonatomic) NSURL *apiUrl;
@property (nonatomic) NSURLSession *urlSession;

@end

@implementation RVLAPIClient

+ (instancetype)sharedClient
{
	static RVLAPIClient *instance;
	static dispatch_once_t once;
	dispatch_once(&once, ^{ instance = [self new]; });
	return instance;
}

- (instancetype)init
{
	return [self initWithPublishableKey:[Ravelin defaultPublishableKey]];
}

- (instancetype)initWithPublishableKey:(NSString *)publishableKey
{
	if (!(self = [super init]))
		return nil;

	NSString *key = [publishableKey copy];
	NSOperationQueue *queue = [NSOperationQueue mainQueue];

	[self validateKey:key];

	_apiUrl = [NSURL URLWithString:@"https://vault.ravelin.com"];

	NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
	config.HTTPAdditionalHeaders = @{@"authorization":[@"token " stringByAppendingString:key]};
	_urlSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:queue];

	return self;
}

#pragma mark - Internal Helpers

- (void)validateKey:(NSString *)publishableKey
{
	NSCAssert(publishableKey != nil && ![publishableKey isEqualToString:@""], @"You must use a valid publishable Ravelin key");
	NSCAssert(![publishableKey.lowercaseString hasPrefix:@"sk_"], @"You are using a secret Ravelin key, but you should use a publishable one");
#ifndef DEBUG
	if ([publishableKey.lowercaseString hasPrefix:@"pk_test"])
		NSLog(@"ℹ️ You're using a test Ravelin key. Make sure to use a live key when submitting to the App Store!");
#endif
}

- (void)postRequestWithPath:(NSString *)path data:(id)data completion:(RVLAPIResponseBlock)completion
{
	NSURL *url = [self.apiUrl URLByAppendingPathComponent:path];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	request.HTTPMethod = @"POST";
	request.HTTPBody = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
	[request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"content-type"];

	[[self.urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable body, NSURLResponse * _Nullable response, NSError * _Nullable error)
	{
		NSDictionary *json = body ? [NSJSONSerialization JSONObjectWithData:body options:0 error:nil] : nil;
		NSError *returnedError = error;
		NSHTTPURLResponse *httpResponse = nil;

		if ([response isKindOfClass:[NSHTTPURLResponse class]])
			httpResponse = (NSHTTPURLResponse *)response;
		else if (!returnedError)
			returnedError = [NSError errorWithDomain:RVLErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey:@"Invalid response"}];

		if (httpResponse && httpResponse.statusCode >= 400)
		{
			NSString *message = @"Unknown Ravelin API failure";
			if (json && [json isKindOfClass:[NSDictionary class]] && json[@"message"])
				message = json[@"message"];
			NSMutableDictionary *info = json.mutableCopy ?: [NSMutableDictionary new];
			info[NSLocalizedDescriptionKey] = message;
			returnedError = [NSError errorWithDomain:RVLErrorDomain code:httpResponse.statusCode userInfo:info];
		}

		[[NSOperationQueue mainQueue] addOperationWithBlock:^
		{
			if (returnedError)
				completion(nil, returnedError);
			else
				completion(json, nil);
		}];
	}] resume];
}

#pragma mark - Public Methods

- (void)createTokenForCard:(RVLCardParams *)cardParams completion:(RVLCardTokenCompletionBlock)completion
{
	NSError *error;
	id input = [cardParams toJSONObjectWithError:&error];

	if (!input)
	{
		completion(nil, error);
		return;
	}

	[self postRequestWithPath:@"v2/card" data:input completion:^(id _Nullable output, NSError * _Nullable error)
	{
		RVLCardToken *instance = nil;
		if (!error)
			instance = [[RVLCardToken alloc] initWithJSONObject:output error:&error];

		if (!instance)
		{
			completion(nil, error);
			return;
		}

		completion(instance, error);
	}];
}

@end

NS_ASSUME_NONNULL_END
