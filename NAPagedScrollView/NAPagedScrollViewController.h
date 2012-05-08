//
//  NAPagedScrollViewController.h
//  NAPagedScrollView
//
//  Created by Audun Kjelstrup on 5/8/12.
//  Copyright (c) 2012 Nordaaker Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NAPagedScrollView/NAPagedScrollView.h>

@interface NAPagedScrollViewController : UIViewController <NAPagedScrollViewDelegate, NAPagedScrollViewDataSource>

@property (nonatomic, strong) NAPagedScrollView *scrollView;

@end
