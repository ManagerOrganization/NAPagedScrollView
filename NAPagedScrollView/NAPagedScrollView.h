//
//  NAPagedScrollView.h
//  NAPagedScrollView
//
//  Created by Audun Kjelstrup on 5/8/12.
//  Copyright (c) 2012 Nordaaker Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <NAPagedScrollView/NAPagedView.h>

@protocol NAPagedScrollViewDataSource;
@protocol NAPagedScrollViewDelegate;

@interface NAPagedScrollView : UIScrollView


@property (nonatomic, readonly) NSUInteger numberOfPages;
@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, unsafe_unretained) IBOutlet id <NAPagedScrollViewDataSource> dataSource;
@property (nonatomic, unsafe_unretained) IBOutlet id <NAPagedScrollViewDelegate> pagedViewDelegate;

- (NAPagedView *)dequeueReuseablePageWithIdentifier: (NSString *)identifier;
- (CGRect) frameForPageAtIndex:(NSUInteger)index;
- (BOOL) isDisplayingPageForIndex:(NSUInteger)index;


@end

@protocol NAPagedScrollViewDataSource <NSObject>
@required
- (NSUInteger)numberOfItemsInScrollView:(NAPagedScrollView*)scrollView;
- (NAPagedView*)scrollView:(NAPagedScrollView*)scrollView pageForItemAtIndex:(NSUInteger)index;
@optional

@end


@protocol NAPagedScrollViewDelegate <NSObject>
@optional

@end


