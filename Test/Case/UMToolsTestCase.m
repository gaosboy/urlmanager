//
//  UMToolsTestCase.m
//  Demo
//
//  Created by jiajun on 7/1/13.
//  Copyright (c) 2013 SegmentFault.com. All rights reserved.
//

#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import "UMToolsTestCase.h"
#import "UMTools.h"

@interface UMToolsTestCase ()

@property   (strong, nonatomic)     NSString    *string;
@property   (strong, nonatomic)     NSString    *toBeEncode;
@property   (strong, nonatomic)     NSString    *encoded;
@property   (strong, nonatomic)     NSURL       *url;
@property   (strong, nonatomic)     NSURL       *noQueryUrl;
@property   (strong, nonatomic)     UIView      *view;

@end

@implementation UMToolsTestCase

#pragma mark - UMString

- (void)setUpClass
{
    self.string     = @"NSString For Test. And hers a number 8848.";
    self.toBeEncode = @"~!@#$%^&*()_+=-[]{}:;\"'<>.,/?1234567890qwertyui";
    self.encoded    = @"%7E%21%40%23%24%25%5E%26%2A%28%29_%2B%3D-%5B%5D%7B%7D%3A%3B%22%27%3C%3E.%2C%2F%3F1234567890qwertyui";
    self.url        = [NSURL URLWithString:@"http://example.com/patha/pathb/?p2=v2&p1=v1"];
    self.noQueryUrl = [NSURL URLWithString:@"http://example.com/patha/pathb/"];
    self.view       = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 300.0f, 200.f)];
}

- (void)testUMStringContainsString
{
    NSString *p = @"For";
    NSString *np = @"BAD";
    GHAssertTrue([self.string containsString:p],
                 @"\"%@\" should contains \"%@\".",
                 self.string, p);
    GHAssertFalse([self.string containsString:np],
                  @"\"%@\" should not contain \"%@\".",
                  self.string, p);
}

- (void)testUMStringContainsStringWithOptions
{
    NSString *p = @"for";
    GHAssertTrue([self.string containsString:p options:NSCaseInsensitiveSearch],
                 @"\"%@\" should contains \"%@\".",
                 self.string, p);
    GHAssertFalse([self.string containsString:p options:NSLiteralSearch],
                 @"\"%@\" should contains \"%@\".",
                 self.string, p);
    NSString *rp = @"\\d+";
    GHAssertTrue([self.string containsString:rp options:NSRegularExpressionSearch],
                 @"\"%@\" should contains \"%@\".",
                 self.string, rp);
}

- (void)testUrlencode
{
    GHAssertEqualStrings([self.toBeEncode urlencode], self.encoded,
                         @"URLEncode Error.",
                         self.toBeEncode, self.encoded);
    GHAssertEqualStrings(self.encoded, [self.toBeEncode urlencode],
                         @"URLDecode Error.",
                         self.encoded, self.toBeEncode);
}

#pragma mark - UMURL

- (void)testAddParams
{
    NSURL *queryUrl = [self.noQueryUrl addParams:@{@"p1":@"v1",@"p2":@"v2"}];
    GHAssertEqualStrings(self.url.absoluteString, queryUrl.absoluteString,
                         @"addParam Error.");
}

- (void)testParams
{
    NSDictionary    *params = self.url.params;
    HC_assertThat([self.url.params allKeys], HC_containsInAnyOrder(@"p1", @"p2", nil));
    GHAssertEqualStrings(@"v1", params[@"p1"], @"Wrong value.");
    GHAssertEqualStrings(@"v2", params[@"p2"], @"Wrong value.");
}

@end
