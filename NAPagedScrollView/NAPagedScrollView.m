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
- (CGRect)_frameForPageAtIndex:(NSUInteger)index; 

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
  
  [self setCanCancelContentTouches:NO];
  self.indicatorStyle = UIScrollViewIndicatorStyleBlack;
  self.clipsToBounds = YES;        // default is NO, we want to restrict drawing within our scrollview
  self.scrollEnabled = YES;
  self.pagingEnabled = YES;
  self.showsVerticalScrollIndicator = NO;
  self.showsHorizontalScrollIndicator = NO;
  self.contentSize = [self _contentSizeForPagingScrollView];
  self.delegate = self;
  
}


-(void)layoutSubviews
{
  [super layoutSubviews];
  [self _tilePages];
}


- (void)_tilePages
{
  CGRect visibleBounds = self.bounds;
  int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
  int lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
  firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
  lastNeededPageIndex  = MIN(lastNeededPageIndex, [self pageCount] - 1);
  
  NSMutableArray *pagesToRemove = [NSMutableArray array];
  
  for (NAPagedView *page in _visiblePages) {
    if (page.tag < firstNeededPageIndex || page.tag > lastNeededPageIndex) {
      [pagesToRemove addObject:page];
      [self _enquePage:page withIdentifier:page.reuseIdentifier];
    }
  }
  
  for (NAPagedView *page in pagesToRemove) {
    [_visiblePages removeObject:page];
    [page removeFromSuperview];
  }
  
  for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
    if (![self isDisplayingPageForIndex:index]) {
      NAPagedView *page = [_dataSource scrollView:self pageForItemAtIndex:index]; 
      page.frame = [self _frameForPageAtIndex:index];
      [self addSubview:page];
      [_visiblePages addObject:page];
    }
  }
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

- (CGRect)_frameForPageAtIndex:(NSUInteger)index 
{
  CGRect bounds = self.bounds;
  CGRect pageFrame = bounds;
  pageFrame.origin.x = (bounds.size.width * index);
  return pageFrame;
}

- (NSUInteger)pageCount {
//  static NSUInteger __count = NSNotFound;  // only count the images once
//  if (__count == NSNotFound) {
//    __count = [_dataSource numberOfItemsInScrollView:self];
//  }
  return [_dataSource numberOfItemsInScrollView:self];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  if ([_pagedViewDelegate respondsToSelector:@selector(viewDidScroll:)]) {
    [_pagedViewDelegate viewDidScroll:self];
  }
  [self _tilePages];
}

@end
