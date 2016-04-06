//
//  PlaceHodlerTextView.h
//  Framework
//
//  Created by gejiangs on 15/8/26.
//  Copyright (c) 2015年 guojiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceholderTextView : UITextView

@property (nonatomic, copy)     NSString *placeholder;
@property (nonatomic, strong)   UIColor *placeholderColor;

-(void)textViewDidChange;

@end
