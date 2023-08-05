//
//  NSData+CCCryptUtil.h
//  Goal
//
//  Created by Jianying Shi on 9/18/14.
//
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSData (CCCryptUtil)

- (NSData*)AES256EncryptWithKey:(NSString*)key;

- (NSData*)AES256DecryptWithKey:(NSString*)key;


@end

