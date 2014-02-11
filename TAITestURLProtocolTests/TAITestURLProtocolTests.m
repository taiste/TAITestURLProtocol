//
//  TAITestURLProtocolTests.m
//  TAITestURLProtocolTests
//
//  Created by Arnaud Coomans, modified by Jarkko Laiho
//

#import <XCTest/XCTest.h>
#import "TAITestURLProtocol.h"

@interface TAITestURLProtocolTests : XCTestCase <TAITestURLProtocolDelegate>

@end

@implementation TAITestURLProtocolTests

- (void)setUp {
	[super setUp];
	
	[NSURLProtocol registerClass:[TAITestURLProtocol class]];
    
	[TAITestURLProtocol setDelegate:nil];
	
	[TAITestURLProtocol setCannedStatusCode:200];
	[TAITestURLProtocol setCannedHeaders:nil];
	[TAITestURLProtocol setCannedResponseData:nil];
	[TAITestURLProtocol setCannedError:nil];
	
	[TAITestURLProtocol setSupportedMethods:nil];
	[TAITestURLProtocol setSupportedSchemes:nil];
	[TAITestURLProtocol setSupportedBaseURL:nil];
	
	[TAITestURLProtocol setResponseDelay:0];
}

- (void)testCanInitWithGETHTTPRequestWithSupportedSchemesAndMethodsNotSet
{
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com"]];
	request.HTTPMethod = @"GET";
	
	[TAITestURLProtocol setSupportedMethods:nil];
	[TAITestURLProtocol setSupportedSchemes:nil];
	
	XCTAssertTrue([TAITestURLProtocol canInitWithRequest:request], @"TAITestURLProtocol does not support a GET HTTP request");
}

- (void)testCanInitWithGETHTTPRequestWithSupportedSchemesAndMethodsEmpty
{
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com"]];
	request.HTTPMethod = @"GET";
	
	[TAITestURLProtocol setSupportedMethods:[NSArray array]];
	[TAITestURLProtocol setSupportedSchemes:[NSArray array]];
	
	XCTAssertFalse([TAITestURLProtocol canInitWithRequest:request], @"TAITestURLProtocol does not support a GET HTTP request");
}

- (void)testCanInitWithGETHTTPRequestWithSupportedHTTPSchemesAndGETMethods
{
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com"]];
	request.HTTPMethod = @"GET";
	
	[TAITestURLProtocol setSupportedMethods:[NSArray arrayWithObject:@"GET"]];
	[TAITestURLProtocol setSupportedSchemes:[NSArray arrayWithObject:@"http"]];
	
	XCTAssertTrue([TAITestURLProtocol canInitWithRequest:request], @"TAITestURLProtocol does not support a GET HTTP request");
}

- (void)testCanInitWithPOSTHTTPSRequestWithSupportedHTTPSSchemesAndPOSTMethods
{
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://example.com"]];
	request.HTTPMethod = @"POST";
	
	[TAITestURLProtocol setSupportedMethods:[NSArray arrayWithObject:@"POST"]];
	[TAITestURLProtocol setSupportedSchemes:[NSArray arrayWithObject:@"https"]];
	
	XCTAssertTrue([TAITestURLProtocol canInitWithRequest:request], @"TAITestURLProtocol does not support a GET HTTP request");
}

- (void)testCanInitWithPOSTHTTPRequestWithSupportedHTTPSchemesAndGETMethods
{
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com"]];
	request.HTTPMethod = @"POST";
	
	[TAITestURLProtocol setSupportedMethods:[NSArray arrayWithObject:@"GET"]];
	[TAITestURLProtocol setSupportedSchemes:[NSArray arrayWithObject:@"http"]];
	
	XCTAssertFalse([TAITestURLProtocol canInitWithRequest:request], @"TAITestURLProtocol does not support a GET HTTP request");
}

- (void)testCanInitWithGETHTTPRequestWithSupportedHTTPSSchemesAndGETMethods
{
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com"]];
	request.HTTPMethod = @"GET";
	
	[TAITestURLProtocol setSupportedMethods:[NSArray arrayWithObject:@"GET"]];
	[TAITestURLProtocol setSupportedSchemes:[NSArray arrayWithObject:@"https"]];
	
	XCTAssertFalse([TAITestURLProtocol canInitWithRequest:request], @"TAITestURLProtocol does not support a GET HTTP request");
}

- (void)testCanInitWithRequestWithSupportedBaseURL
{
	
	NSMutableURLRequest *goodRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com/testCanInitWithRequestWithSupportedBaseURL"]];
	NSMutableURLRequest *badRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://example.org"]];
	
	[TAITestURLProtocol setSupportedBaseURL:[NSURL URLWithString:@"http://example.com"]];
	
	XCTAssertTrue([TAITestURLProtocol canInitWithRequest:goodRequest], @"TAITestURLProtocol does not support a request with base url");
	XCTAssertFalse([TAITestURLProtocol canInitWithRequest:badRequest], @"TAITestURLProtocol does not support a request with base url");
}


- (void)testStartLoadingWithoutDelegate
{
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com"]];
	
	id requestObject = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:1], [NSNumber numberWithInt:2], nil], @"array",
                        @"hello", @"string",
                        nil];
    
	NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestObject options:0 error:nil];
	[TAITestURLProtocol setCannedResponseData:requestData];
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	
	id responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
	
	XCTAssertNotNil(responseObject, @"no canned response from http request");
	XCTAssertTrue([responseObject isKindOfClass:[NSDictionary class]], @"canned response has wrong format (not dictionary)");
}

- (void)testStartLoadingWithDelegate
{
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com/testStartLoadingWithDelegate"]];
	
	[TAITestURLProtocol setDelegate:self];
	
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	id responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
	
	XCTAssertNotNil(responseObject, @"no canned response from http request");
	XCTAssertTrue([responseObject isKindOfClass:[NSDictionary class]], @"canned response has wrong format (not dictionary)");
	XCTAssertTrue([[responseObject objectForKey:@"testName"] isEqual:@"testStartLoadingWithDelegate"], @"wrong canned response");
}

- (void)testAgainStartLoadingWithDelegate
{
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com/testAgainStartLoadingWithDelegate"]];
	
	[TAITestURLProtocol setDelegate:self];
	
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	id responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
	
	XCTAssertNotNil(responseObject, @"no canned response from http request");
	XCTAssertTrue([responseObject isKindOfClass:[NSDictionary class]], @"canned response has wrong format (not dictionary)");
	XCTAssertTrue([[responseObject objectForKey:@"testName"] isEqual:@"testAgainStartLoadingWithDelegate"], @"wrong canned response");
}

- (void)testStartLoadingWithDelegatePlainJSONResponse
{
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com/testStartLoadingWithDelegatePlainJSONResponse"]];
	
	[TAITestURLProtocol setDelegate:self];
	
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	id responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
	
	XCTAssertNotNil(responseObject, @"no canned response from http request");
	XCTAssertTrue([responseObject isKindOfClass:[NSDictionary class]], @"canned response has wrong format (not dictionary)");
	XCTAssertTrue([[responseObject objectForKey:@"testName"] isEqual:@"testStartLoadingWithDelegatePlainJSONResponse"], @"wrong canned response");
}

- (void)testCanInitWithRequestWithDelegateShouldInitWithRequest
{
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com/testCanInitWithRequestWithDelegateShouldInitWithRequest"]];
	
	[TAITestURLProtocol setDelegate:self];
	
	XCTAssertTrue([TAITestURLProtocol canInitWithRequest:request], @"TAITestURLProtocol delegate returned shouldInitWithRequest NO");
}

- (void)testCanInitWithRequestWithDelegateShouldInitWithRequestNO
{
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com/testCanInitWithRequestWithDelegateShouldInitWithRequestNO"]];
	
	[TAITestURLProtocol setDelegate:self];
	
	XCTAssertFalse([TAITestURLProtocol canInitWithRequest:request], @"TAITestURLProtocol delegate returned shouldInitWithRequest YES");
}


- (void)testRedirectForClient
{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://redirect-test.com"]];
    
    [TAITestURLProtocol setDelegate:self];
    
    NSURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
	id responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
	
    XCTAssertNotNil(response, @"no canned response from http request");
	XCTAssertNotNil(responseObject, @"no canned response object from http request");
    XCTAssertEqualObjects(response.URL.absoluteString, @"http://redirected-response.com", @"response should have been redirected");
    XCTAssertTrue([[responseObject objectForKey:@"REDIRECTED"] isEqual:@"YES"], @"wrong canned response");
}



#pragma mark - TAITestURLProtocolDelegate

- (NSURL *)redirectForClient:(id<NSURLProtocolClient>)client request:(NSURLRequest *)request
{
    if ([request.HTTPMethod isEqualToString:@"GET"] && [request.URL.absoluteString isEqualToString:@"http://redirect-test.com"]) {
        return [NSURL URLWithString:@"http://redirected-response.com"];
    }
    
    return nil;
}

- (NSData*)responseDataForClient:(id<NSURLProtocolClient>)client request:(NSURLRequest*)request
{
	
	NSData *requestData = nil;
	
	if ([request.URL.absoluteString isEqual:@"http://example.com/testStartLoadingWithDelegate"]) {
		id requestObject = [NSDictionary dictionaryWithObjectsAndKeys:@"testStartLoadingWithDelegate", @"testName", nil];
		requestData = [NSJSONSerialization dataWithJSONObject:requestObject options:0 error:nil];
	}
	
	if ([request.URL.absoluteString isEqual:@"http://example.com/testAgainStartLoadingWithDelegate"]) {
		id requestObject = [NSDictionary dictionaryWithObjectsAndKeys:@"testAgainStartLoadingWithDelegate", @"testName", nil];
		requestData = [NSJSONSerialization dataWithJSONObject:requestObject options:0 error:nil];
	}
	
	if ([request.URL.absoluteString isEqual:@"http://example.com/testStartLoadingWithDelegatePlainJSONResponse"]) {
		requestData = [@"{\"testName\":\"testStartLoadingWithDelegatePlainJSONResponse\"}" dataUsingEncoding:NSUnicodeStringEncoding];
	}
    
    if ([request.URL.absoluteString isEqual:@"http://redirected-response.com"]) {
        id requestObject = [NSDictionary dictionaryWithObject:@"YES" forKey:@"REDIRECTED"];
		requestData = [NSJSONSerialization dataWithJSONObject:requestObject options:0 error:nil];
    }
	
	
	return requestData;
}

- (BOOL)shouldInitWithRequest:(NSURLRequest*)request
{
	if ([request.URL.absoluteString isEqual:@"http://example.com/testCanInitWithRequestWithDelegateShouldInitWithRequest"]) {
		return YES;
	}
	
	if ([request.URL.absoluteString isEqual:@"http://example.com/testCanInitWithRequestWithDelegateShouldInitWithRequestNO"]) {
		return NO;
	}
	
	return YES;
}

@end