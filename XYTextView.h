//
//  XYTextView.h
//  UITextView
//
//  Created by BeiliaoIOSDev on 14/12/4.
//  Copyright (c) 2014年 Cheng. All rights reserved.
//这是版本0.0.2的注释

#import <UIKit/UIKit.h>

typedef void (^FrameChangeBlock)(CGRect rect);

@interface XYTextView : UITextView //<UITextViewDelegate>

-(void)setPlaceHolderString:(NSString *)placeHolder;

-(void)setTextViewHeight:(NSInteger)max  minus:(NSInteger)minus  frameChange:(FrameChangeBlock)block;

@property (nonatomic, strong)   UILabel *placeholderLabel;
@property (nonatomic, readwrite,strong) UIColor *placeholderColor;
@property (nonatomic, readwrite,strong) NSString *placeholder;
@property(nonatomic,assign)NSInteger maxLength;

@end
