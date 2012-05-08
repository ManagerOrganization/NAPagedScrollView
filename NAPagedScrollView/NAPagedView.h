//
//  NAPagedView.h
//  NAPagedScrollView
//
//  Created by Audun Kjelstrup on 5/8/12.
//  Copyright (c) 2012 Nordaaker Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NAPagedView : UIView

+ (NSString *)pageIdentifier;

+ (id)cellForPagedScrollView:(NAPagedScrollView *)scrollView;
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, strong) IBOutlet UIView *backgroundView; 
@property (nonatomic, strong) IBOutlet UIView *contentView; 
@property (nonatomic, weak) NSUInteger index;
@property (nonatomic, copy) NSString *reuseIdentifier;

- (void)prepareForReuse;

@end
