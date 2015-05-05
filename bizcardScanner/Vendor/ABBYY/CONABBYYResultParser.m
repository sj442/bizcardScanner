//
//  EPABBYYResultParser.m
//  EPBusinessCardReader
//
//  Created by Leo Reubelt on 2/16/15.
//  Copyright (c) 2015 EnHatch. All rights reserved.
//

#import "CONABBYYResultParser.h"

@interface CONABBYYResultParser ()

@property (strong, nonatomic) NSMutableString *foundValue;

@property (strong, nonatomic) NSMutableDictionary *cardData;

@property (copy, nonatomic) NSString *tempKeyString;

@property (nonatomic, copy) void (^completion)(NSDictionary *cardData);

@end

@implementation CONABBYYResultParser

- (instancetype)initWithData:(NSData *)data completion:(void (^)(NSDictionary *cardData))completion;
{
  self = [super initWithData:data];
  if (self) {
    self.delegate = self;
    self.shouldProcessNamespaces = NO;
    self.completion = completion;
        
    [self parse];
  }
  return self;
}

- (NSMutableString *)foundValue
{
  if (!_foundValue) {
    _foundValue = [NSMutableString new];
  }
  
  return _foundValue;
}

#pragma mark - NSXMLParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
  self.cardData = [NSMutableDictionary new];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
  if ([[attributeDict allKeys] containsObject:@"type"]) {
    
    self.tempKeyString = [attributeDict valueForKey:@"type"];
  }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
  if (self.tempKeyString && [[self.cardData allKeys] containsObject:self.tempKeyString]) {
    
    NSMutableArray *keyValueArray = [self.cardData valueForKey:self.tempKeyString];
    
    [keyValueArray addObject:[self.foundValue copy]];

  } else if (self.tempKeyString) {
    
    NSMutableArray *keyValueArray = [NSMutableArray new];
    
    [keyValueArray addObject:[self.foundValue copy]];
    
    [self.cardData setValue:keyValueArray forKey:[self.tempKeyString copy]];
  }
  
  [self.foundValue setString:@""];
  
  self.tempKeyString = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
  
  NSString *trimmedString = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
  NSCharacterSet *whiteSpaceSet = [NSCharacterSet whitespaceCharacterSet];
  
  if ([[trimmedString stringByTrimmingCharactersInSet: whiteSpaceSet] length] > 0)
  {
    [self.foundValue appendString:string];
  }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
  if (self.completion) {
    
    self.completion(self.cardData);
  }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
  NSLog(@"%@", [parseError localizedDescription]);
}

@end
