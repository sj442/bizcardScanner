//
//  NSString+PList.m
//  Conquer
//
//  Created by Leo Reubelt on 3/31/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.
//

#import "NSString+PList.h"

@implementation NSString (PList)

#pragma mark - Public - Class


//+ (NSString *)plistWouldYouLikeToAddA:(PListKey *)keyOne aboutYour:(PListKey *)keyTwo
//{
 // NSString *string1 = [[CONStringManager sharedManager] stringForKey:keyOne];
 // NSString *string2 = [[CONStringManager sharedManager] stringForKey:keyTwo];
  
//  NSString *sentance;
//  
//  if ([[NSCharacterSet characterSetWithCharactersInString:@"aeiouAEIOU"] characterIsMember:[string1 characterAtIndex:0]]) {
//    
//    sentance = [NSString stringWithFormat:@"Would you like to add an %@ about your %@?",string1,string2];
//    
//  } else {
//    
//    sentance = [NSString stringWithFormat:@"Would you like to add a %@ about your %@?",string1,string2];
//  }
//  
//  return sentance;
//}

//+ (NSString *)firsName
//{
//  return [[CONStringManager sharedManager] stringForKeys:@[PLfirst, PLname]];
//}
//
//+ (NSString *)lastName
//{
//  return [[CONStringManager sharedManager] stringForKeys: @[PLlast, PLname]];
//}
//
//+ (NSString *)webLink
//{
//  return [[CONStringManager sharedManager] stringForKeys: @[PLweb, PLlink]];
//}

//+ (NSString *)webLinks
//{
//  return [NSString stringWithFormat:@"%@s",[NSString webLink]];
//}

#pragma mark - Public - Instance

//- (NSString *)pluralWord
//{
//  if (!self || [self isEqualToString:@""]) {
//    
//    NSLog(@"No Word");
//    
//    return self;
//  }
//  
//  NSRange lastCharacterRange = NSMakeRange(self.length-1, 1);
//  
//  NSString *lastCharacter = [self substringWithRange:lastCharacterRange];
//  
//  if ([lastCharacter isEqualToString:@"y"]) {
//    
//    NSRange toLastLetter = NSMakeRange(0, self.length - 1);
//    
//    NSString *subString = [self substringWithRange:toLastLetter];
//    
//    NSString *pluralWord = [NSString stringWithFormat:@"%@ies",subString];
//    
//    return pluralWord;
//  }
//  
//  if ([lastCharacter isEqualToString:@"Y"]) {
//    
//    NSRange toLastLetter = NSMakeRange(0, self.length - 1);
//    
//    NSString *subString = [self substringWithRange:toLastLetter];
//    
//    NSString *pluralWord = [NSString stringWithFormat:@"%@IES",subString];
//    
//    return pluralWord;
//  }
//  
//  if ([lastCharacter isEqualToString:@"s"]) {
//    return [NSString stringWithFormat:@"%@es",self];
//  }
//  
//  if ([lastCharacter isEqualToString:@"S"]) {
//    return [NSString stringWithFormat:@"%@ES",self];
//  }
//  
//  if ([[lastCharacter uppercaseString] isEqualToString:lastCharacter]) {
//    return [NSString stringWithFormat:@"%@S",self];
//  }
//  
//  return [NSString stringWithFormat:@"%@s",self];
//}
//
//- (NSString *)pleaseChooseAStringWithPlural:(BOOL)plural
//{
//  if (plural) {
//    return [NSString stringWithFormat:@"Please Choose %@",[self pluralWord]];
//  }
//  
//  BOOL beginsWithVowel = [[NSCharacterSet characterSetWithCharactersInString:@"aeiouAEIOU"] characterIsMember:[self characterAtIndex:0]];
//  
//  if (beginsWithVowel) {
//    return [NSString stringWithFormat:@"Please Choose an %@",self];
//  } else {
//    return [NSString stringWithFormat:@"Please Choose a %@",self];
//  }
//}
//
//- (NSString *)noneYetString
//{
//  return [NSString stringWithFormat:@"No %@ Yet",self];
//}
//
//- (NSString *)pleaseInputString
//{
//  return [NSString stringWithFormat:@"Please input a value for %@",self];
//}

//- (NSString *)isRequiredString
//{
//  return [NSString stringWithFormat:@"%@ is %@",self, [[CONStringManager sharedManager] stringForKey:PLRequired]];
//}

@end
