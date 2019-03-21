//
//  ItemEntry.h
//  New Earth
//
//  Created by Scott Alexander on 7/5/16.
//  Copyright © 2016 Big Dog Tools. All rights reserved.
//

#import <Foundation/Foundation.h>

/* TODO list 2017-08-28
 
 Newly placed units start with health = 100 ... but should grow to 100 while being built
 Change fill color of ENVELOPE to get rid of the square
 Change table views of warehouse and store to be parent>>detail view and back
 Allow the user to place the HQ themselves
 Expand the active map from the small development screen
 Add weather and seasons
 Add internet links to units (to see technology available)
 Add internet links to tiles (to see what 'bad' looks like)
 Add animation for stages
 Add pathfinding for power and roads
 Add lines to power sources
 Add cost of distance
 
 Add good-better-best to store/detail selection (so list isn't giant)
 Add TOTAL STATUS (combine sustain scores for each resource into one value >=0 good <0 bad)
 Add CONTRACT DAY (number of days passed in contract)(maybe countdown is better) to control page
 Add ProgressToGoal (how close are we to the milestone)
 Fix UnitName - and use it in notes (who gave notice) (old format was TYPE+LOC)
 Change Detail:DONE to return to Store (and stay there)
 Save GameState on exit (write to file so can open at last state)
 Add END/QUIT to stop the game (or restart it)
 Add Open Last (to open game from exit state)
 Add TotalStatus to ???
 DONE: Add Warehouse page to show placed and unplaced units (maybe health, etc)
 DONE: Check Repair-Wearout in DoProduction (seems to stop) - number type wrong ... integer versus float
 DONE: Fix MapScaleOnReturn - after buying unit and returning to map the zoomscale = 1 and not last value
 DONE: Add BuyIt to Detail page
 DONE: Change BuyIt unit placement orientation so rotated perpendicular to slope
 DONE: Fix MapZoomScale for status bar when zooming
 DONE: Fix bug - in landscape, buyit puts unit in the wrong position (far to the right and maybe down a bit)
 DONE: Add bank account to control page

 */



typedef enum
{
    urgent,
    warning,
    statusGood,
    statusBad,
    eventGood,
    eventBad,
    info
}noteType;

typedef enum
{
    news,
    goal,
    headquarters,
    fromPlant, // plant food
    fromMeat, // animal food (fish, poultry, etc.)
    fromAir, // generates breathable air
    fromWater, // generates potable water
    fromMine, // mining, etc to get minerals
    fromPower, // converts input to useable power
    fromWaste, // waste treatment
    fromCivil, // services police, fire, admin
    fromHome, // homestead
    fromTree, // trees ... non food producing but may provide lumber or fruit
    fromFab // generates components, supplies, structure material
}noteSource;

typedef enum
{
    plant, // plant food
    meat, // animal food (fish, poultry, etc.)
    air, // generates breathable air
    water, // generates potable water
    mine, // mining, etc to get minerals
    power, // converts input to useable power
    waste, // waste treatment
    civil, // services police, fire, admin
    home, // homestead
    tree, // trees ... non food producing but may provide lumber or fruit
    fab // generates components, supplies, structure material
}itemType;

typedef enum
{
    isnew, // not placed
    preparing, // site preparation in process
    clearing, // in preparation phase ... getting rid of rocks and trees
    cleaning, // in preparation phase ... getting rid of toxins and pollution
    smoothing, // in preparation phase ... flattening surface for placement of unit
    connecting, // in preparation phase ... connecting to a power source (the nearest with capacity) (maybe to water or air also)
    operating, // doing what it is intended to do
    repairingHalf, // able to produce at half rate and being fixed
    repairingFull, // able to produce at full rate and being fixed
    building, // being built
    standby // not damaged; but not producing
}itemStatus;

typedef enum
{
    installed,
    notinstalled
} placed;

typedef enum
{
    structureStock,
    componentStock,
    supplyStock,
    materialStock,
    powerStock,
    waterStock,
    airStock,
    foodStock,
    laborStock,
    happinessStock,
    noneStock

}stockType;

//@interface ItemEntry : NSObject

//@end
