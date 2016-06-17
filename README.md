# ravelin-ios

Client-side Obj-C library for the [Ravelin API](https://developer.ravelin.com).
Ravelin is a fraud detection tool.

At present, Ravelin's only support for client-side functionality is card
tokenization. If more functionality is added, this library will be updated to
match.

```ruby
pod 'Ravelin', '~> 0.1.0'
```

```objc
#import <Ravelin/Ravelin.h>

[Ravelin setDefaultPublishableKey:@"pk_live_XXXXXXXX"];

RVLCardParams *cardParams = [RVLCardParams new];
cardParams.number = @"4242424242424242";
cardParams.expiryMonth = 12;
cardParams.expiryYear = 2020;

[[RVLAPIClient sharedClient] createTokenForCard:cardParams completion:^(RVLCardToken *cardToken, NSError *error) {
	if (error) {
		[self handleError:error];
	} else {
		NSLog(@"%@", cardToken.token); // => tk-8c46447a-fdce-4e48-88aa-234a3c014330
	}
}];
```

## Notes

- the key you provide should start with "pk_"; **do not** use the "sk_" key

## Support

Please open an issue on this repository.

## Authors

- James Billingham <james@jamesbillingham.com>

## License

MIT licensed - see [LICENSE](LICENSE) file
