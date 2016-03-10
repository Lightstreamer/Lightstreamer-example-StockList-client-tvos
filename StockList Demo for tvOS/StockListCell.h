//
//  StockListCell.h
//  StockList Demo for tvOS
//
//  Copyright © 2016 Lightstreamer. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StockListCell : UITableViewCell {
    IBOutlet __weak UILabel *_nameLabel;
    IBOutlet __weak UILabel *_lastLabel;
    IBOutlet __weak UILabel *_timeLabel;
    IBOutlet __weak UIImageView *_dirImage;
    IBOutlet __weak UILabel *_changeLabel;
    IBOutlet __weak UILabel *_bidLabel;
    IBOutlet __weak UILabel *_askLabel;
    IBOutlet __weak UILabel *_minLabel;
    IBOutlet __weak UILabel *_maxLabel;
    IBOutlet __weak UILabel *_refLabel;
    IBOutlet __weak UILabel *_openLabel;
}


#pragma mark -
#pragma mark Properties

@property (weak, nonatomic, readonly) UILabel *nameLabel;
@property (weak, nonatomic, readonly) UILabel *lastLabel;
@property (weak, nonatomic, readonly) UILabel *timeLabel;
@property (weak, nonatomic, readonly) UIImageView *dirImage;
@property (weak, nonatomic, readonly) UILabel *changeLabel;
@property (weak, nonatomic, readonly) UILabel *bidLabel;
@property (weak, nonatomic, readonly) UILabel *askLabel;
@property (weak, nonatomic, readonly) UILabel *minLabel;
@property (weak, nonatomic, readonly) UILabel *maxLabel;
@property (weak, nonatomic, readonly) UILabel *refLabel;
@property (weak, nonatomic, readonly) UILabel *openLabel;


@end
