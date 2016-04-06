//
//  PlaceHodlerTextView.m
//  Framework
//
//  Created by gejiangs on 15/8/26.
//  Copyright (c) 2015年 guojiang. All rights reserved.
//

#import "PlaceholderTextView.h"

@interface PlaceholderTextView ()<UITextViewDelegate>

@property (nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation PlaceholderTextView

-(void)awakeFromNib
{
    [self initUI];
}

-(id)init
{
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    self.placeholderLabel = [[UILabel alloc] init];
    _placeholderLabel.userInteractionEnabled = NO;
    _placeholderLabel.font = self.font;
    _placeholderLabel.textColor = RGB(200, 199, 204);
    _placeholderLabel.numberOfLines = 0;
    
    self.delegate = self;
    
    [self addSubview:_placeholderLabel];
}


-(void)setPlaceholder:(NSString *)placeholder
{
    self.placeholderLabel.text = placeholder;
}

-(void)setPlaceholderColor:(UIColor *)placeholderColor
{
    self.placeholderLabel.textColor = placeholderColor;
}

-(void)textViewDidChange:(UITextView *)textView
{
    [self textViewDidChange];
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

-(void)textViewDidChange
{
    self.placeholderLabel.hidden = [self.text length] > 0;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = CGRectMake(5, 7, self.frame.size.width-10, 0);
    
    self.placeholderLabel.frame = rect;
    
    [self.placeholderLabel sizeToFit];//这一步很重要，不能遗忘
}


@end
