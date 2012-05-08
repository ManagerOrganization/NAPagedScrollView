//
//  NAPagedView.h
//  NAPagedScrollView
//
//  Created by Audun Kjelstrup on 5/8/12.
//  Copyright (c) 2012 Nordaaker Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class NAPagedScrollView;

@interface NAPagedView : UIView

+ (NSString *)pageIdentifier;

+ (id)viewForPagedScrollView:(NAPagedScrollView *)scrollView;
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, strong) IBOutlet UIView *backgroundView; 
@property (nonatomic, strong) IBOutlet UIView *contentView; 
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, copy) NSString *reuseIdentifier;

- (void)prepareForReuse;

@end
