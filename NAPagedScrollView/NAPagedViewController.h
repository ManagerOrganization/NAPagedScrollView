//
//  NAPagedViewController.h
//  NAPagedScrollView
//
//  Created by Audun Kjelstrup on 5/8/12.
//  Copyright (c) 2012 Nordaaker Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NAPagedViewController : UIViewController

@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, copy) NSString *reuseIdentifier;

-(void)prepareForReuse;

@end
