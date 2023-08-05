//
//  NSString+Validator.m
//  EverAfter
//
//  Created by Jianying Shi on 6/20/14.
//
//

#import "NSString+Validator.h"

@implementation NSString(Validator)

- (BOOL)validateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

+ (BOOL)isNullOrEmpty : (NSString *)string
{
    if (string == nil) {
        return YES;
    }
    
    if ([string length] == 0) {
        return YES;
    }
    
    return NO;
}

@end
