//
//  StockListCell.m
//  StockList Demo for tvOS
//
//  Copyright © 2016 Lightstreamer. All rights reserved.
//

#import "StockListCell.h"


@implementation StockListCell


#pragma mark -
#pragma mark Initialization

- (id) initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        
        // Nothing to do, actually
    }
    
    return self;
}


#pragma mark -
#pragma mark Properties

@synthesize nameLabel= _nameLabel;
@synthesize lastLabel= _lastLabel;
@synthesize timeLabel= _timeLabel;
@synthesize dirImage= _dirImage;
@synthesize changeLabel= _changeLabel;
@synthesize bidLabel= _bidLabel;
@synthesize askLabel= _askLabel;
@synthesize minLabel= _minLabel;
@synthesize maxLabel= _maxLabel;
@synthesize refLabel= _refLabel;
@synthesize openLabel= _openLabel;


@end
