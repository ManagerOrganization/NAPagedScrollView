//
//  NAPagedScrollView.m
//  NAPagedScrollView
//
//  Created by Audun Kjelstrup on 5/8/12.
//  Copyright (c) 2012 Nordaaker Ltd. All rights reserved.
//

#import "NAPagedScrollView.h"

@interface NAPagedScrollView() <UIScrollViewDelegate>
{
  NSMutableDictionary *_reuseablePages;
  NSMutableSet *_visiblePages;
}

@end

- (void)_sharedInitialization;
- (void)_tilePages;
- (void)_cleanupPages;
- (void)_enquePage:(NAPageView*)page withIdentifier:(NSString*)reuseIdentifier;
- (NSMutableSet*)_reuseablePageSetForIdentifier:(NSString*)reuseIdentifier;

@end

@implementation NAPagedScrollView

@synthesize dataSource = _dataSource, pagedViewDelegate = _pagedViewDelegate

#pragma mark - Initialization Methods

- (id)init
{
return [self initWithFrame:CGRectZero];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  if ((self = [super initWithCoder:aDecoder])) {
    [self _sharedInitialization];
  }
  
  return self;
}

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    [self _sharedInitialization];
  }
  
  return self;
}

- (void)_sharedInitialization
{
  _reusablePages = [[NSMutableDictionary alloc] init];
  _visiblePages = [[NSMutableSet alloc] init];
  self.backgroundColor = [UIColor whiteColor];
  
}

- (void)_tilePages
{

}


- (BOOL)isDisplayingPageForIndex:(NSUInteger)index
{
  BOOL foundPage = NO;
  for (UIViewController *page in _visiblePages) {
    if (page.view.tag == index) {
      foundPage = YES;
      break;
    }
  }
  return foundPage;
}


- (void)_enquePage:(NAPageView*)page withIdentifier:(NSString*)reuseIdentifier
{
  NSMutableSet *set = [self reuseablePageSetForIdentifier:reuseIdentifier];
  [set addObject:page];
  
}

- (NSMutableSet*)_reuseablePageSetForIdentifier:(NSString*)reuseIdentifier
{
  NSMutableSet *set = [_recycledPages objectForKey:reuseIdentifier];
  
  if (!set) {
    [_recycledPages setObject:[NSMutableSet set] forKey:reuseIdentifier];
    set = [_recycledPages objectForKey:reuseIdentifier];
  }
  
  return set;
}

- (TSPageViewController *)dequeueRecycledArticleWithIdentifier: (NSString *)identifier
{
  if (!identifier) return nil;
  
  NSMutableSet *set = [_recycledPages objectForKey:identifier];
  
  if ([set count] == 0)
    return nil;
  
  TSPageViewController *page = [set anyObject];
  [set removeObject:page];
  [page prepareForReuse];
  
  return page;
}



- (CGSize)_contentSizeForPagingScrollView 
{
  CGRect bounds = _scrollView.bounds;
  return CGSizeMake(bounds.size.width * [self pageCount], bounds.size.height);
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index 
{
  CGRect bounds = _scrollView.bounds;
  CGRect pageFrame = bounds;
  pageFrame.origin.x = (bounds.size.width * index);
  return pageFrame;
}

- (NSUInteger)pageCount {
  static NSUInteger __count = NSNotFound;  // only count the images once
  if (__count == NSNotFound) {
    __count = [_dataSource numberOfItemsInScrollView:self];
  }
  return __count;
}

@end
