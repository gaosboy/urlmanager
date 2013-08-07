//
//  UMToolsTestCase.m
//  Demo
//
//  Created by jiajun on 7/1/13.
//  Copyright (c) 2013 SegmentFault.com. All rights reserved.
//

#import "HCIsEqualToPoint.h"
#import "HCIsEqualToSize.h"
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import "UMToolsTestCase.h"
#import "UMTools.h"

@interface UMToolsTestCase ()

// 普通字符串，带有字母和数字
@property   (strong, nonatomic)     NSString    *string;
// 普通字符串，仅带有字母
@property   (strong, nonatomic)     NSString    *stringWithoutNumber;
// 将被做URLEncode的字符串，含有特殊字符和汉字
@property   (strong, nonatomic)     NSString    *toBeEncode;
// 把 toBeEncode 编码后的串
@property   (strong, nonatomic)     NSString    *encoded;
// 普通的URL，带有QueryString
@property   (strong, nonatomic)     NSURL       *url;
// 去掉上边一个URL的QueryString
@property   (strong, nonatomic)     NSURL       *noQueryUrl;
// 一个普通的UIView
@property   (strong, nonatomic)     UIView      *view;

@end

@implementation UMToolsTestCase

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setUpClass
{
    self.string                 = @"NSString For Test with a number 8848.";
    self.stringWithoutNumber    = @"NSString For Test.";
    self.toBeEncode             = @"~!@#$%^&*()_+=-[]{}:;\"'<>.,/?123qwe汉字";
    self.encoded                = @"%7E%21%40%23%24%25%5E%26%2A%28%29_%2B%3D-%5B%5D%7B%7D%3A%3B%22%\
27%3C%3E.%2C%2F%3F123qwe%E6%B1%89%E5%AD%97";
    self.url                    = [NSURL URLWithString:
                                   @"http://example.com/patha/pathb/?p2=v2&p1=v1"];
    self.noQueryUrl             = [NSURL URLWithString:@"http://example.com/patha/pathb/"];
    self.view                   = [[UIView alloc] initWithFrame:
                                   CGRectMake(10.0f, 10.0f, 100.0f, 100.f)];
}

#pragma mark - UMString

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

////////////////////////////////////////////////////////////////////////////////////////////////////
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
    GHAssertFalse([self.stringWithoutNumber containsString:rp options:NSRegularExpressionSearch],
                 @"\"%@\" should contains \"%@\".",
                 self.string, rp);
}

- (void)testUrlencode
{
    GHAssertEqualStrings([self.toBeEncode urlencode], self.encoded,
                         @"URLEncode Error.",
                         self.toBeEncode, self.encoded);
    GHAssertEqualStrings([self.encoded urldecode], self.toBeEncode,
                         @"URLDecode Error.",
                         self.encoded, self.toBeEncode);
}

#pragma mark - UMURL

- (void)testAddParams
{
    NSURL *queryUrl = [self.noQueryUrl addParams:@{@"p1":@"v1",@"p2":@"v2"}];
    HC_assertThat(queryUrl.absoluteString, HC_containsString(@"p1=v1"));
    HC_assertThat(queryUrl.absoluteString, HC_containsString(@"p2=v2"));
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)testParams
{
    NSDictionary    *params = self.url.params;
    HC_assertThat([self.url.params allKeys], HC_containsInAnyOrder(@"p1", @"p2", nil));
    GHAssertEqualStrings(@"v1", params[@"p1"], @"Wrong value.");
    GHAssertEqualStrings(@"v2", params[@"p2"], @"Wrong value.");
}

#pragma mark - UMView

- (void)testGetPropertiesOfView
{
    HC_assertThat([NSNumber numberWithFloat:self.view.left],
                  HC_equalToFloat(self.view.frame.origin.x));
    HC_assertThat([NSNumber numberWithFloat:self.view.right],
                  HC_equalToFloat(self.view.frame.origin.x + self.view.frame.size.width));
    HC_assertThat([NSNumber numberWithFloat:self.view.top],
                  HC_equalToFloat(self.view.frame.origin.y));
    HC_assertThat([NSNumber numberWithFloat:self.view.bottom],
                  HC_equalToFloat(self.view.frame.origin.y + self.view.frame.size.height));
    
    HC_assertThat([NSNumber numberWithFloat:self.view.centerX],
                  HC_equalToFloat(self.view.frame.origin.x + self.view.frame.size.width / 2));
    HC_assertThat([NSNumber numberWithFloat:self.view.centerY],
                  HC_equalToFloat(self.view.frame.origin.y + self.view.frame.size.height / 2));
    
    HC_assertThat([NSNumber numberWithFloat:self.view.width],
                  HC_equalToFloat(self.view.frame.size.width));
    HC_assertThat([NSNumber numberWithFloat:self.view.height],
                  HC_equalToFloat(self.view.frame.size.height));
    
    HC_assertThat(NSStringFromCGSize(self.view.size),
                  HC_equalToSize(self.view.frame.size));
    HC_assertThat(NSStringFromCGPoint(self.view.origin),
                  HC_equalToPoint(CGPointMake(self.view.frame.origin.x, self.view.frame.origin.y)));
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)testSetPropertiesOfView
{
    CGFloat oLeft  = self.view.frame.origin.x;
    self.view.left += 10.0f;
    HC_assertThat([NSNumber numberWithFloat:self.view.left], HC_equalToFloat(oLeft + 10.0f));
    CGFloat oRight = self.view.frame.origin.x + self.view.size.width;
    self.view.right += 10.0f;
    HC_assertThat([NSNumber numberWithFloat:self.view.right], HC_equalToFloat(oRight + 10.0f));
    CGFloat oTop = self.view.frame.origin.y;
    self.view.top += 10.0f;
    HC_assertThat([NSNumber numberWithFloat:self.view.top], HC_equalToFloat(oTop + 10.0f));
    CGFloat oBottom = self.view.frame.origin.y + self.view.frame.size.height;
    self.view.bottom += 10.0f;
    HC_assertThat([NSNumber numberWithFloat:self.view.bottom], HC_equalToFloat(oBottom + 10.0f));
    
    CGFloat oCenterX = self.view.frame.origin.x + self.view.frame.size.width / 2;
    self.view.centerX += 10.0f;
    HC_assertThat([NSNumber numberWithFloat:self.view.centerX], HC_equalToFloat(oCenterX + 10.0f));
    CGFloat oCenterY = self.view.frame.origin.y + self.view.frame.size.height / 2;
    self.view.centerY += 10.0f;
    HC_assertThat([NSNumber numberWithFloat:self.view.centerY], HC_equalToFloat(oCenterY + 10.0f));
    
    CGFloat oWidth = self.view.frame.size.width;
    self.view.width += 10.0f;
    HC_assertThat([NSNumber numberWithFloat:self.view.width], HC_equalToFloat(oWidth + 10.0f));
    CGFloat oHeight = self.view.frame.size.height;
    self.view.height += 10.0f;
    HC_assertThat([NSNumber numberWithFloat:self.view.height], HC_equalToFloat(oHeight + 10.0f));
    
    CGSize nSize = CGSizeMake(self.view.frame.size.width + 10.0f,
                              self.view.frame.size.height + 10.0f);
    self.view.size = nSize;
    HC_assertThat(NSStringFromCGSize(self.view.size), HC_equalToSize(nSize));
    CGPoint nOrigin = CGPointMake(self.view.frame.origin.x, self.view.frame.origin.y);
    self.view.origin = nOrigin;
    HC_assertThat(NSStringFromCGPoint(self.view.origin), HC_equalToPoint(nOrigin));
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)testRemoveAllSubviews
{
    UIView *subViewA = [[UIView alloc] init];
    UIView *subViewB = [[UIView alloc] init];
    
    [self.view addSubview:subViewA];
    [self.view addSubview:subViewB];
    HC_assertThat(self.view.subviews, HC_containsInAnyOrder(subViewA, subViewB, nil));

    [self.view removeAllSubviews];
    if (nil != self.view.subviews) {
        HC_assertThat(self.view.subviews, HC_empty());
    }
}

@end
