/****************************************************************************
 *  Copyright 2006 Aaron Rolett                                             *
 *  arolett@mail.rochester.edu                                              *
 *                                                                          *
 *  This file is part of PandoraBoy.                                        *
 *                                                                          *
 *  PandoraBoy is free software; you can redistribute it and/or modify      *
 *  it under the terms of the GNU General Public License as published by    * 
 *  the Free Software Foundation; either version 2 of the License, or       *
 *  (at your option) any later version.                                     *
 *                                                                          *
 *  PandoraBoy is distributed in the hope that it will be useful,           *
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of          *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           * 
 *  GNU General Public License for more details.                            *
 *                                                                          *
 *  You should have received a copy of the GNU General Public License       * 
 *  along with PandoraBoy; if not, write to the Free Software Foundation,   *
 *  Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA          *
 ***************************************************************************/

#import <Cocoa/Cocoa.h>


@interface PreferenceController : NSObject {
  IBOutlet NSWindow *prefWindow;
  IBOutlet NSTabView *prefTabs;
  
  NSMutableDictionary *items; // all items that are allowed to be in the toolbar

  //  NSString *LastFmUsername; 
  NSString *LastFmPassword; 
}

- (IBAction)setUsername:(id)sender;
- (IBAction)setPassword:(id)sender;

-(IBAction) applyPreferences; 

-(void) addItemToToolbar:(NSString*)name withImage:(NSString*)imageName; 
@end

@interface PreferenceController (NSWindowDelegate)
-(void)windowWillClose:(NSNotification *)aNotification;
@end
