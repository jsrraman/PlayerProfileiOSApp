//
//  ImageUtility.h
//  PlayerProfile
//
//  Created by Rajaraman on 28/02/15.
//  Copyright (c) 2015 Rajaraman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageUtility : NSObject
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height;
@end
