//
//  PlacementEnvelope.m
//  New Earth Next
//
//  Created by Scott on 6/9/18.
//  Copyright © 2018 Big Dog Tools. All rights reserved.
//

#import "PlacementEnvelope.h"

@implementation PlacementEnvelope

-(id) init
{
    self = [super init];
    if (self) {
        // run a test
        NewTech* unit1 = [[NewTech alloc] initWithType:(itemType) power withLoc:CGPointMake(-40, 0) withID:0 withSize:CGSizeMake(48, 60) withHealth:100 onDate:[NSDate date] withCost:100000.00 withColor:[UIColor greenColor] withStatus:isnew withName:@"POWER0A" wasPlaced:NO withClean:0 withClear:0 withSmooth:0 withConnected:100 withBuildRate:1 withRepairRate:5 withProduceRate:1 withWearoutRate:0.00025 withCleanRate:5000 withClearRate:100 withSmoothRate:100 withConnectRate:100 withEnvelope:1000.0];
        
        NewTech* unit2 = [[NewTech alloc] initWithType:(itemType) power withLoc:CGPointMake(-40, 0) withID:0 withSize:CGSizeMake(48, 60) withHealth:100 onDate:[NSDate date] withCost:100000.00 withColor:[UIColor greenColor] withStatus:isnew withName:@"POWER0B" wasPlaced:NO withClean:0 withClear:0 withSmooth:0 withConnected:100 withBuildRate:1 withRepairRate:5 withProduceRate:1 withWearoutRate:0.00025 withCleanRate:5000 withClearRate:100 withSmoothRate:100 withConnectRate:100 withEnvelope:1000.0];
        
        unit1.myLoc = CGPointMake(500, 500);
        unit2.myLoc = CGPointMake(2000, 2000);
        
        [self aFunctionFirst:unit1 Second:unit2];
        
        unit1.myLoc = CGPointMake(500, 500);
        unit2.myLoc = CGPointMake(1000, 1200);
        
        [self aFunctionFirst:unit1 Second:unit2];
        
    }
    return self;
}
-(double) quadraticFormulaA:(double) a B:(double) b C:(double) c Add:(BOOL) add
{
    double X = 0;
    
    if (add)    X = (-b + sqrt(b*b - 4*a*c)) / (2*a);
    else {      X = (-b - sqrt(b*b - 4*a*c)) / (2*a);}
    return X;
}

-(double) distanceFrom:(CGPoint) f to:(CGPoint) s
{
    double theDist = sqrt(pow(f.x - s.x, 2) + pow(f.y - s.y, 2));
    return theDist;
}

-(void) aFunctionFirst:(NewTech*) f Second:(NewTech*) s
{
    if ([self distanceFrom:f.myLoc to:s.myLoc] > (f.myEnvelope + s.myEnvelope) / 2) {
        NSLog(@"\nNo Intersection between %@ and %@",f.myName, s.myName);
        return;
    }
    
    double a;
    double b;
    double c;
    
    a = 2 * (s.myLoc.x - f.myLoc.x);
    b = 2 * (s.myLoc.y - f.myLoc.y);
    c = pow(f.myLoc.x, 2) - pow(s.myLoc.x, 2) + pow(f.myLoc.y, 2) - pow(s.myLoc.y, 2) + pow(s.myEnvelope / 2.0, 2) - pow(f.myEnvelope / 2.0, 2);
    
    double x;
    double y;
    double z;
    
    x = 1 +  + pow(a, 2) /  + pow(b, 2);
    y = 2 * (-f.myLoc.x + a * c / pow(b, 2) + f.myLoc.y * a / b);
    z =  pow((double)f.myLoc.x, 2)
    + pow((double)f.myLoc.y, 2)
    + 2 * (double)f.myLoc.y * c / b
    + pow(c, 2) / pow(b, 2)
    - pow((double)f.myEnvelope / 2.0, 2);
    
    double X1, X2;
    
    X1 = [self quadraticFormulaA:x B:y C:z Add:YES];
    X2 = [self quadraticFormulaA:x B:y C:z Add:NO];
    
    double Y1, Y2;
    __unused double Y1b, Y2b;
    Y1 = (-a * X1 - c) / b;
    Y2 = (-a * X2 - c) / b;

    NSLog(@"x1=%0.2f y1=%0.2f",X1, Y1);
    NSLog(@"x2=%0.2f y2=%0.2f",X2, Y2);
}

@end
