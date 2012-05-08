//
//  NAPagedScrollView.m
//  NAPagedScrollView
//
//  Created by Audun Kjelstrup on 5/8/12.
//  Copyright (c) 2012 Nordaaker Ltd. All rights reserved.
//

#import <NAPagedScrollView/NAPagedScrollView.h>
#import <NAPagedScrollView/NAPagedView.h>

@interface NAPagedScrollView() <UIScrollViewDelegate>
{
  NSMutableDictionary *_reuseablePages;
  NSMutableSet *_visiblePages;
}


- (void)_sharedInitialization;
- (void)_tilePages;
- (void)_cleanupPages;
- (void)_enquePage:(NAPagedView*)page withIdentifier:(NSString*)reuseIdentifier;
- (NSMutableSet*)_reuseablePageSetForIdentifier:(NSString*)reuseIdentifier;

@end

@implementation NAPagedScrollView

@synthesize dataSource = _dataSource, pagedViewDelegate = _pagedViewDelegate, backgroundView = _backgroundView;

@dynamic numberOfPages;

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
  _reuseablePages = [[NSMutableDictionary alloc] init];
  _visiblePages = [[NSMutableSet alloc] init];
  self.backgroundColor = [UIColor whiteColor];
  
}

- (void)_tilePages
{

}

-(void)_cleanupPages{
  
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


- (void)_enquePage:(NAPagedView*)page withIdentifier:(NSString*)reuseIdentifier
{
  NSMutableSet *set = [self _reuseablePageSetForIdentifier:reuseIdentifier];
  [set addObject:page];
  
}

- (NSMutableSet*)_reuseablePageSetForIdentifier:(NSString*)reuseIdentifier
{
  NSMutableSet *set = [_reuseablePages objectForKey:reuseIdentifier];
  
  if (!set) {
    [_reuseablePages setObject:[NSMutableSet set] forKey:reuseIdentifier];
    set = [_reuseablePages objectForKey:reuseIdentifier];
  }
  
  return set;
}

- (NAPagedView *)dequeueReuseablePageWithIdentifier: (NSString *)identifier;
{
  if (!identifier) return nil;
  
  NSMutableSet *set = [_reuseablePages objectForKey:identifier];
  
  if ([set count] == 0)
    return nil;
  
  NAPagedView *page = [set anyObject];
  [set removeObject:page];
  [page prepareForReuse];
  
  return page;
}



- (CGSize)_contentSizeForPagingScrollView 
{

  return CGSizeMake(self.bounds.size.width * [self pageCount], self.bounds.size.height);
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index 
{
  CGRect bounds = self.bounds;
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
