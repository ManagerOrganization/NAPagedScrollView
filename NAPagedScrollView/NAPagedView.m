//
//  NAPagedView.m
//  NAPagedScrollView
//
//  Created by Audun Kjelstrup on 5/8/12.
//  Copyright (c) 2012 Nordaaker Ltd. All rights reserved.
//

#import <NAPagedScrollView/NAPagedView.h>
#import <NAPagedScrollView/NAPagedScrollView.h>

@interface NAPagedView() {
  UIColor *_userContentViewBackgroundColor;
}

@end

@implementation NAPagedView

@synthesize backgroundView = _backgroundView;
@synthesize contentView = _contentView;
@synthesize index = _index;
@synthesize reuseIdentifier = _reuseIdentifier;

+ (NSString *)pageIdentifier
{
  return NSStringFromClass(self);
}

+ (id)cellForPagedScrollView:(NAPagedScrollView *)scrollView
{
  NSString *pageIdentifier = [self pageIdentifier];
  NAPagedView *page = (NAPagedView *)[scrollView dequeueReuseablePageWithIdentifier:pageIdentifier];
  if (page == nil) {
    page = [[self alloc] initWithFrame:scrollView.frame reuseIdentifier:pageIdentifier];
  }
  
  return page;
}

#pragma mark - Designated Initializer

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
  if ((self = [super initWithFrame:frame])) {
    _reuseIdentifier = reuseIdentifier;
    
    _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    _backgroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_backgroundView];
    
    
    _contentView = [[UIView alloc] initWithFrame:self.bounds];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];
    
    [_contentView addObserver:self forKeyPath:@"backgroundColor" options:NSKeyValueObservingOptionNew context:NULL];
  }
  
  return self;
}

- (void)awakeFromNib {
  if (!_contentView) {
    _contentView = [[UIView alloc] initWithFrame:self.bounds];
    _contentView.backgroundColor = [UIColor whiteColor];
  }
  
  if (!_backgroundView) {
    _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    _backgroundView.backgroundColor = [UIColor whiteColor];
  }
  
  [self addSubview:_backgroundView];
  [self addSubview:_contentView];
  
  [self bringSubviewToFront:_contentView];
  
  [_contentView addObserver:self 
                 forKeyPath:@"backgroundColor" 
                    options:NSKeyValueObservingOptionNew
                    context:NULL];
}

- (void)dealloc
{
  [_contentView removeObserver:self forKeyPath:@"backgroundColor"];
}

#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if (object == _contentView) {
    _userContentViewBackgroundColor = [change objectForKey:@"new"];
  }
}

#pragma mark - Layout

- (void)layoutSubviews
{
  
	CGRect bounds = self.bounds;
  _contentView.frame = bounds;
  
	if (!_backgroundView.hidden)
		_backgroundView.frame = bounds;
  
  [self sendSubviewToBack:_backgroundView];
  [self bringSubviewToFront:_contentView];

  
  _contentView.backgroundColor = _userContentViewBackgroundColor ? _userContentViewBackgroundColor : [UIColor whiteColor];
    
    _backgroundView.hidden = NO;
}

-(void)prepareForReuse
{
  
}

@end
