//
//  FileOps.h
//  New Earth Next
//
//  Created by Scott Alexander on 3/30/18.
//  Copyright © 2018 Big Dog Tools. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileOps : NSObject
- (NSString *) getUnitsDir;
- (NSString *) getMapTilesDir;
- (NSArray *) getContentsOfDirAt:(NSString*) thePath;

@end
