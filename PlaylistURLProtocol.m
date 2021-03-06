//
//  PlaylistURLProtocol.m
//  PandoraBoy
//
//  Created by Rob Napier on 11/24/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "PlaylistURLProtocol.h"
#import "Playlist.h"
#import "StationList.h"

@implementation PlaylistURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    NSString *urlString = [[request URL] absoluteString];
    return ( [super canInitWithRequest:request] &&
             [urlString rangeOfString:@"getFragment"].location != NSNotFound );
}

// Init/Dealloc

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    Playlist *sharedPlaylist = [Playlist sharedPlaylist];
    [sharedPlaylist addInfoFromData:[self data]];
    
    NSString *stationId = [self valueForParameter:@"arg1"];
    [[StationList sharedStationList] setCurrentStationFromIdentifier:stationId];
	//[super connectionDidFinishLoading:connection];
}

@end
