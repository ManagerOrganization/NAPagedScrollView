//
//  NAPagedViewController.m
//  NAPagedScrollView
//
//  Created by Audun Kjelstrup on 5/8/12.
//  Copyright (c) 2012 Nordaaker Ltd. All rights reserved.
//

#import <NAPagedScrollView/NAPagedViewController.h>

@interface NAPagedViewController ()

@end

@implementation NAPagedViewController

@synthesize reuseIdentifier = _reuseIdentifier, index = _index;

- (id)initWithNibName:(NSString *)nibNameOrNil andReuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
      _reuseIdentifier = reuseIdentifier;
    }
    return self;
}

- (void)prepareForReuse
{
  
}

@end
