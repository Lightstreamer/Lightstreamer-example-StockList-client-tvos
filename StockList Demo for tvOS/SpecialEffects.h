//
//  SpecialEffects.h
//  StockList Demo for tvOS
//
//  Copyright © 2016 Lightstreamer. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SpecialEffects : NSObject


#pragma mark -
#pragma mark UI element flashing

+ (void) flashLabel:(UILabel *)label withColor:(UIColor *)color;
+ (void) flashImage:(UIImageView *)imageView withColor:(UIColor *)color;


@end
