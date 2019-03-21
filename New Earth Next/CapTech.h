//
//  CapTech.h
//  New Earth Next
//
//  Created by Scott on 6/20/18.
//  Copyright © 2018 Big Dog Tools. All rights reserved.
//
//  This is a subclass of NewTech ... contains methods for units that are tied to a supply (like a power plant)
//

#import "NewTech.h"

@interface CapTech : NewTech
- (instancetype) initWithSaveString: (NSString*) stringWithData;
- (id) initWithUnit:(CapTech*) origUnit;
+ (instancetype) unitLikeUnit:(CapTech*) copyUnit;
- (id) initWithType:(itemType) aType
           withLoc:(CGPoint) aLoc
            withID:(id) aID
          withSize:(CGSize) aSize
        withHealth:(float) aHealth
            onDate:(NSDate*) aCreateDate
          withCost:(float) aCost
         withColor:(UIColor*) aColorIs
        withStatus:(itemStatus) aStatus
          withName:(NSString*) aName
         wasPlaced:(BOOL) aPlaced
         withClean:(NSInteger) aClean
         withClear:(NSInteger) aClear
        withSmooth:(NSInteger) aSmooth
     withConnected:(NSInteger) aConnected
     withBuildRate:(NSInteger) aBuildRate
    withRepairRate:(NSInteger) aRepairRate
   withProduceRate:(NSInteger) aProduceRate
   withWearoutRate:(NSInteger) aWearoutRate
     withCleanRate:(NSInteger) aCleanRate
     withClearRate:(NSInteger) aClearRate
    withSmoothRate:(NSInteger) aSmoothRate
   withConnectRate:(NSInteger) aConnectRate
      withEnvelope:(float) aEnvelope
;
- (void) saveTechDataToFile: (NSString*) FileNameAndPath;
- (void) drawPathsAtContext: (CGContextRef) context;

@property (strong, nonatomic) NSMutableArray* pathsToUnits;
@property (strong, nonatomic) NSMutableArray* connectedUnits;

@end
