//
//  ProxyURLProtocol.m
//  PandoraBoy
//
//  Created by Rob Napier on 11/30/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "ProxyURLProtocol.h"
#import <Foundation/NSURLProtocol.h>
#import "PlaylistURLProtocol.h"
#import "ArtworkURLProtocol.h"
#import "ResourceURLProtocol.h"
#import "StationsURLProtocol.h"
#import "FeedbackURLProtocol.h"

static NSString *PBProxyURLHeader = @"X-PB";

@implementation ProxyURLProtocol

// Accessors

- (NSURLConnection *)connection {
    return [[_connection retain] autorelease];
}

- (void)setConnection:(NSURLConnection *)value {
    if (_connection != value) {
        [_connection release];
        _connection = [value retain];
    }
}

- (NSURLRequest *)request {
    return [[_request retain] autorelease];
}

- (void)setRequest:(NSURLRequest *)value {
    if (_request != value) {
        [_request release];
        _request = [value retain];
    }
}

- (NSMutableData *)data {
    return [[_data retain] autorelease];
}

- (void)appendData:(NSData *)newData {
    if( _data == nil ) {
        _data = [[NSMutableData alloc] initWithData:newData];
    }
    else
    {
        [_data appendData:newData];
    }
}

// Class methods

+ (void)registerProxyProtocols {
    [NSURLProtocol registerClass:[self class]];
    
    [NSURLProtocol registerClass:[ResourceURLProtocol class]];
    [NSURLProtocol registerClass:[StationsURLProtocol class]];
    [NSURLProtocol registerClass:[FeedbackURLProtocol class]];
    [NSURLProtocol registerClass:[PlaylistURLProtocol class]];
    [NSURLProtocol registerClass:[ArtworkURLProtocol class]];
}    

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    if ( [[[request URL] scheme] isEqualToString:@"http"] &&
         [request valueForHTTPHeaderField:PBProxyURLHeader] == nil )
    {
        return YES;
    }
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

-(id)initWithRequest:(NSURLRequest *)request
      cachedResponse:(NSCachedURLResponse *)cachedResponse
              client:(id <NSURLProtocolClient>)client
{
//    NSLog(@"DEBUG:initWithRequest:%@", [request URL]);
    
    // Modify request
    NSMutableURLRequest *myRequest = [request mutableCopy];
    [myRequest setValue:@"" forHTTPHeaderField:PBProxyURLHeader];
    
    self = [super initWithRequest:myRequest
                   cachedResponse:cachedResponse
                           client:client];
    
    if ( self ) {
        [self setRequest:myRequest];
    }
    return self;
}

- (void)dealloc
{
    [_request release];
    [_connection release];
    [_data release];
    [super dealloc];
}

// Instance methods

- (void)startLoading
{
    //  use the regular URL donwload machinery to get the url contents
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:[self request]
                                                                delegate:self];
    [self setConnection:connection];
}

-(void)stopLoading {
    [[self connection] cancel];
}

// NSURLConnection delegates (generally we pass these on to our client)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [[self client] URLProtocol:self didLoadData:data];
    [self appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[self client] URLProtocol:self didFailWithError:error];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    if( [[[[self request] URL] absoluteString] rangeOfString:@"method=addFeedback"].location != NSNotFound ) {
//        NSLog(@"DEBUG:getStations:%@", [[[NSString alloc] initWithData:[self data] encoding:NSASCIIStringEncoding] autorelease]);
//    }
    [[self client] URLProtocolDidFinishLoading:self];
}

-(NSString*)valueForParameter:(NSString*)parameter {
    NSString *query = [[[self request] URL] query];

    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSEnumerator *e = [pairs objectEnumerator];
    NSString *aKeyValue;
    while( aKeyValue = [e nextObject] ) {
        NSArray *split = [aKeyValue componentsSeparatedByString:@"="];
        if( [[split objectAtIndex:0] isEqualToString:parameter] ) {
            return [split objectAtIndex:1];
        }
    }
    return nil;
}    
@end
