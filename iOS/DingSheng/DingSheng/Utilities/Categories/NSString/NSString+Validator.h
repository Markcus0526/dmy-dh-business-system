//
//  NSString+Validator.h
//  EverAfter
//
//  Created by Jianying Shi on 6/20/14.
//
//

#import <Foundation/Foundation.h>

@interface NSString(Validator)

- (BOOL)validateEmail;
+ (BOOL)isNullOrEmpty : (NSString *)string;

@end
