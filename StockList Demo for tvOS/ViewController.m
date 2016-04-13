//
//  ViewController.m
//  StockList Demo for tvOS
//
//  Copyright © 2016 Lightstreamer. All rights reserved.
//

#import "ViewController.h"
#import "StockListCell.h"
#import "SpecialEffects.h"
#import "Constants.h"


#pragma mark -
#pragma mark ViewController extension

@interface ViewController () {
    dispatch_queue_t _backgroundQueue;

    LSLightstreamerClient *_client;
    LSSubscription *_subscription;
    
    NSMutableDictionary *_itemUpdated;
    NSMutableDictionary *_itemData;
    
    NSMutableSet *_rowsToBeReloaded;
}


#pragma mark -
#pragma mark Properties

@property (weak, nonatomic) IBOutlet UITableView *table;


#pragma mark -
#pragma mark Lightstreamer life cycle

- (void) connectToPushServer;
- (void) subscribeToTable;


@end


#pragma mark -
#pragma mark ViewController implementation

@implementation ViewController


#pragma mark -
#pragma mark Initialization

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        
        // Data structure
        _itemUpdated= [NSMutableDictionary dictionary];
        _itemData= [NSMutableDictionary dictionary];
        
        // List of rows marked to be reloaded by the table
        _rowsToBeReloaded= [[NSMutableSet alloc] initWithCapacity:NUMBER_OF_ITEMS];
        
        // Queue for background execution
        _backgroundQueue= dispatch_queue_create("backgroundQueue", 0);
        
        // Create the Lightstreamer client
        _client= [[LSLightstreamerClient alloc] initWithServerAddress:PUSH_SERVER_URL adapterSet:ADAPTER_SET];
    }
    
    return self;
}


#pragma mark -
#pragma mark View life cycle

- (void) viewDidLoad {
    [super viewDidLoad];
    
    // Start connecting in background
    dispatch_async(_backgroundQueue, ^{
        [self connectToPushServer];
    });
}


#pragma mark -
#pragma mark Lightstreamer life cycle

- (void) connectToPushServer {
    NSLog(@"Connecting to push server %@...", PUSH_SERVER_URL);
    
    [_client addDelegate:self];
    [_client connect];
}

- (void) subscribeToTable {
    NSLog(@"Subscribing to table...");
    
    _subscription= [[LSSubscription alloc] initWithSubscriptionMode:@"MERGE" items:TABLE_ITEMS fields:LIST_FIELDS];
    _subscription.dataAdapter= DATA_ADAPTER;
    _subscription.requestedSnapshot= @"yes";
    _subscription.requestedMaxFrequency= @"1.0";
    
    [_subscription addDelegate:self];
    [_client subscribe:_subscription];
    
    NSLog(@"Subscribed to table");
}


#pragma mark -
#pragma mark Methods of LSClientDelegate

- (void) client:(nonnull LSLightstreamerClient *)client didChangeProperty:(nonnull NSString *)property {
    NSLog(@"Client property changed: %@", property);
}

- (void) client:(nonnull LSLightstreamerClient *)client didChangeStatus:(nonnull NSString *)status {
    NSLog(@"Client status changed: %@", status);
    
    if ([status hasPrefix:@"CONNECTED:"]) {
        
        // We subscribe, if not already subscribed. The LSClient will reconnect automatically
        // in most of the cases, so we don't need to resubscribe each time.
        if (!_subscription) {
            dispatch_async(_backgroundQueue, ^{
                [self subscribeToTable];
            });
        }
        
    } else if ([status hasPrefix:@"DISCONNECTED:"]) {
        
        // The client will reconnect automatically in this case.
        
    } else if ([status isEqualToString:@"DISCONNECTED"]) {
        
        // In this case the session has been closed by the server, the client
        // will not automatically reconnect. Let's prepare for a new connection.
        _subscription= nil;
        
        dispatch_async(_backgroundQueue, ^{
            [self connectToPushServer];
        });
    }
}


#pragma mark -
#pragma mark Methods of LSSubscriptionDelegate

- (void) subscription:(nonnull LSSubscription *)subscription didUpdateItem:(nonnull LSItemUpdate *)itemUpdate {
    NSUInteger itemPosition= itemUpdate.itemPos;
    NSMutableDictionary *item= nil;
    NSMutableDictionary *itemUpdated= nil;
    
    @synchronized (_itemData) {
        item= [_itemData objectForKey:[NSNumber numberWithUnsignedInteger:(itemPosition -1)]];
        if (!item) {
            item= [[NSMutableDictionary alloc] init];
            [_itemData setObject:item forKey:[NSNumber numberWithUnsignedInteger:(itemPosition -1)]];
        }
        
        itemUpdated= [_itemUpdated objectForKey:[NSNumber numberWithUnsignedInteger:(itemPosition -1)]];
        if (!itemUpdated) {
            itemUpdated= [[NSMutableDictionary alloc] init];
            [_itemUpdated setObject:itemUpdated forKey:[NSNumber numberWithUnsignedInteger:(itemPosition -1)]];
        }
    }
    
    double previousLastPrice= 0.0;
    for (NSString *fieldName in LIST_FIELDS) {
        NSString *value= [itemUpdate valueWithFieldName:fieldName];
        
        // Save previous last price to choose blink color later
        if ([fieldName isEqualToString:@"last_price"])
            previousLastPrice= [[item objectForKey:fieldName] doubleValue];
        
        if (value)
            [item setObject:value forKey:fieldName];
        else
            [item setObject:[NSNull null] forKey:fieldName];
        
        if ([itemUpdate isValueChangedWithFieldName:fieldName])
            [itemUpdated setObject:[NSNumber numberWithBool:YES] forKey:fieldName];
    }
    
    // Check variation and store appropriate color
    double currentLastPrice= [[itemUpdate valueWithFieldName:@"last_price"] doubleValue];
    if (currentLastPrice >= previousLastPrice)
        [item setObject:@"green" forKey:@"color"];
    else
        [item setObject:@"orange" forKey:@"color"];
    
    @synchronized (_rowsToBeReloaded) {
        [_rowsToBeReloaded addObject:[NSIndexPath indexPathForRow:(itemPosition -1) inSection:0]];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // Update the table view
        NSMutableArray *rowsToBeReloaded= nil;
        @synchronized (_rowsToBeReloaded) {
            rowsToBeReloaded= [[NSMutableArray alloc] initWithCapacity:[_rowsToBeReloaded count]];
            
            for (NSIndexPath *indexPath in _rowsToBeReloaded)
                [rowsToBeReloaded addObject:indexPath];
            
            [_rowsToBeReloaded removeAllObjects];
        }
        
        // Ask the table to reload the marked rows
        [self.table reloadRowsAtIndexPaths:rowsToBeReloaded withRowAnimation:UITableViewRowAnimationNone];
    });
}


#pragma mark -
#pragma mark Methods of UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return NUMBER_OF_ITEMS;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Prepare the table cell
    StockListCell *cell= (StockListCell *) [tableView dequeueReusableCellWithIdentifier:@"StockListCell"];
    if (!cell) {
        NSArray *niblets= [[NSBundle mainBundle] loadNibNamed:@"StockListCell" owner:self options:NULL];
        cell= (StockListCell *) [niblets lastObject];
    }
    
    // Retrieve the item's data structures
    NSMutableDictionary *item= nil;
    NSMutableDictionary *itemUpdated= nil;
    @synchronized (_itemData) {
        item= [_itemData objectForKey:[NSNumber numberWithInteger:indexPath.row]];
        itemUpdated= [_itemUpdated objectForKey:[NSNumber numberWithInteger:indexPath.row]];
    }
    
    if (item) {
        @synchronized (item) {
            
            // Update the cell appropriately
            NSString *colorName= [item objectForKey:@"color"];
            UIColor *color= nil;
            if ([colorName isEqualToString:@"green"])
                color= GREEN_COLOR;
            else if ([colorName isEqualToString:@"orange"])
                color= ORANGE_COLOR;
            else
                color= [UIColor whiteColor];
            
            cell.nameLabel.text= [item objectForKey:@"stock_name"];
            if ([[itemUpdated objectForKey:@"stock_name"] boolValue]) {
                if (!self.table.dragging)
                    [SpecialEffects flashLabel:cell.nameLabel withColor:color];
                
                [itemUpdated setObject:[NSNumber numberWithBool:NO] forKey:@"stock_name"];
            }
            
            cell.lastLabel.text= [item objectForKey:@"last_price"];
            if ([[itemUpdated objectForKey:@"last_price"] boolValue]) {
                if (!self.table.dragging)
                    [SpecialEffects flashLabel:cell.lastLabel withColor:color];
                
                [itemUpdated setObject:[NSNumber numberWithBool:NO] forKey:@"last_price"];
            }
            
            cell.timeLabel.text= [item objectForKey:@"time"];
            if ([[itemUpdated objectForKey:@"time"] boolValue]) {
                if (!self.table.dragging)
                    [SpecialEffects flashLabel:cell.timeLabel withColor:color];
                
                [itemUpdated setObject:[NSNumber numberWithBool:NO] forKey:@"time"];
            }
            
            double pctChange= [[item objectForKey:@"pct_change"] doubleValue];
            if (pctChange > 0.0)
                cell.dirImage.image= [UIImage imageNamed:@"Arrow-up.png"];
            else if (pctChange < 0.0)
                cell.dirImage.image= [UIImage imageNamed:@"Arrow-down.png"];
            else
                cell.dirImage.image= nil;
            
            cell.changeLabel.text= [NSString stringWithFormat:@"%@%%", [item objectForKey:@"pct_change"]];
            cell.changeLabel.textColor= (([[item objectForKey:@"pct_change"] doubleValue] >= 0.0) ? DARK_GREEN_COLOR : RED_COLOR);
            
            if ([[itemUpdated objectForKey:@"pct_change"] boolValue]) {
                if (!self.table.dragging) {
                    [SpecialEffects flashImage:cell.dirImage withColor:color];
                    [SpecialEffects flashLabel:cell.changeLabel withColor:color];
                }
                
                [itemUpdated setObject:[NSNumber numberWithBool:NO] forKey:@"pct_change"];
            }
            
            cell.askLabel.text= [item objectForKey:@"ask"];
            if ([[itemUpdated objectForKey:@"ask"] boolValue]) {
                if (!self.table.dragging)
                    [SpecialEffects flashLabel:cell.askLabel withColor:color];
                
                [itemUpdated setObject:[NSNumber numberWithBool:NO] forKey:@"ask"];
            }
            
            cell.bidLabel.text= [item objectForKey:@"bid"];
            if ([[itemUpdated objectForKey:@"bid"] boolValue]) {
                if (!self.table.dragging)
                    [SpecialEffects flashLabel:cell.bidLabel withColor:color];
                
                [itemUpdated setObject:[NSNumber numberWithBool:NO] forKey:@"bid"];
            }
            
            cell.minLabel.text= [item objectForKey:@"min"];
            if ([[itemUpdated objectForKey:@"min"] boolValue]) {
                if (!self.table.dragging)
                    [SpecialEffects flashLabel:cell.minLabel withColor:color];
                
                [itemUpdated setObject:[NSNumber numberWithBool:NO] forKey:@"min"];
            }
            
            cell.maxLabel.text= [item objectForKey:@"max"];
            if ([[itemUpdated objectForKey:@"max"] boolValue]) {
                if (!self.table.dragging)
                    [SpecialEffects flashLabel:cell.maxLabel withColor:color];
                
                [itemUpdated setObject:[NSNumber numberWithBool:NO] forKey:@"max"];
            }
            
            cell.refLabel.text= [item objectForKey:@"ref_price"];
            if ([[itemUpdated objectForKey:@"ref_price"] boolValue]) {
                if (!self.table.dragging)
                    [SpecialEffects flashLabel:cell.refLabel withColor:color];
                
                [itemUpdated setObject:[NSNumber numberWithBool:NO] forKey:@"ref_price"];
            }
            
            cell.openLabel.text= [item objectForKey:@"open_price"];
            if ([[itemUpdated objectForKey:@"open_price"] boolValue]) {
                if (!self.table.dragging)
                    [SpecialEffects flashLabel:cell.openLabel withColor:color];
                
                [itemUpdated setObject:[NSNumber numberWithBool:NO] forKey:@"open_price"];
            }
        }
    }
    
    return cell;
}


#pragma mark -
#pragma mark Methods of UITableViewDelegate

- (NSIndexPath *) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HEADER_HEIGHT;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *niblets= [[NSBundle mainBundle] loadNibNamed:@"StockListSection" owner:self options:NULL];
    
    return (UIView *) [niblets lastObject];
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2 == 0)
        cell.backgroundColor= LIGHT_ROW_COLOR;
    else
        cell.backgroundColor= DARK_ROW_COLOR;
}


@end
