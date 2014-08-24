//
//  UIImageView+FastLoad.m
//  TripJournal
//
//  Created by Shailesh Panwar on 6/10/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "UIImageView+FastLoad.h"

@implementation UIImageView (FastLoad)

- (void)setLayerImage:(UIImage *)image
{
    self.layer.contents = (id)image.CGImage;
}

@end
