//
//  SpecialEffects.m
//  StockList Demo for tvOS
//
//  Copyright © 2016 Lightstreamer. All rights reserved.
//

#import "SpecialEffects.h"
#import "Constants.h"


@implementation SpecialEffects


#pragma mark -
#pragma mark UI element flashing

+ (void) flashLabel:(UILabel *)label withColor:(UIColor *)color {
    label.layer.backgroundColor= color.CGColor;
    if (label.tag == COLORED_LABEL_TAG)
        label.textColor= [UIColor blackColor];
    
    [[SpecialEffects class] performSelector:@selector(unflashLabel:) withObject:label afterDelay:FLASH_DURATION];
}

+ (void) flashImage:(UIImageView *)imageView withColor:(UIColor *)color {
    imageView.backgroundColor= color;
    
    [[SpecialEffects class] performSelector:@selector(unflashImage:) withObject:imageView afterDelay:FLASH_DURATION];
}


#pragma mark -
#pragma mark Internals

+ (void) unflashLabel:(UILabel *)label {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:FLASH_DURATION];
    
    label.layer.backgroundColor= [UIColor clearColor].CGColor;
    if (label.tag == COLORED_LABEL_TAG)
        label.textColor= (([label.text doubleValue] >= 0.0) ? DARK_GREEN_COLOR : RED_COLOR);
    
    [UIView commitAnimations];
}

+ (void) unflashImage:(UIImageView *)imageView {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:FLASH_DURATION];
    
    imageView.backgroundColor= [UIColor clearColor];
    
    [UIView commitAnimations];
}


@end
