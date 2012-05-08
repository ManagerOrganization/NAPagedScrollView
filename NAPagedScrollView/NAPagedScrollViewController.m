//
//  NAPagedScrollViewController.m
//  NAPagedScrollView
//
//  Created by Audun Kjelstrup on 5/8/12.
//  Copyright (c) 2012 Nordaaker Ltd. All rights reserved.
//

#import <NAPagedScrollView/NAPagedScrollViewController.h>

@interface NAPagedScrollViewController ()

@end

@implementation NAPagedScrollViewController

@synthesize scrollView =_scrollView;

-(void)loadView
{
  [super loadView];
  
  _scrollView = [[NAPagedScrollView alloc] initWithFrame:self.view.bounds];
  _scrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
  _scrollView.dataSource = self;
  _scrollView.pagedViewDelegate = self;
  self.view = _scrollView;
  
}

-(NSUInteger)numberOfItemsInScrollView:(NAPagedScrollView *)scrollView
{
  return 0;
}

-(NAPagedView *)scrollView:(NAPagedScrollView *)scrollView pageForItemAtIndex:(NSUInteger)index
{

return [NAPagedView viewForPagedScrollView:scrollView];
}

@end
