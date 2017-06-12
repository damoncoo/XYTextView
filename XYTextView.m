//
//  XYTextView.m
//  UITextView
//
//  Created by BeiliaoIOSDev on 14/12/4.
//  Copyright (c) 2014年 Cheng. All rights reserved.
//

#import "XYTextView.h"
#import <objc/runtime.h>

@implementation XYTextView

//static char lableChar;
//
static char maxHeightChar;
static char minHeightChar;
static char charBlock;

-(id)init {

    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textChange:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.maxLength = 0;
//        [self addObserver:self forKeyPath:NSStringFromSelector(@selector(contentSize))
//                  options:NSKeyValueObservingOptionNew
//                  context:NULL];
    }
    return self;
}
/**
 *
 */
-(void)awakeFromNib {
    [super awakeFromNib];
    self.maxLength = 0;
//    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(contentSize))
//              options:NSKeyValueObservingOptionNew
//              context:NULL];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textChange:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
}

-(void)setMaxLength:(NSInteger)maxLength
{
    _maxLength = maxLength;
}

-(void)setTextViewHeight:(NSInteger)max  minus:(NSInteger)minus  frameChange:(FrameChangeBlock)block
{
    objc_setAssociatedObject(self, &charBlock, block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &maxHeightChar, [NSNumber numberWithInteger:max], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &minHeightChar, [NSNumber numberWithInteger:minus], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
-(void)setPlaceHolderString:(NSString *)placeHolder {
    
    self.placeholder = placeHolder;
}


-(void)textChange:(NSNotification *)notification {
    
    NSString *string = self.text;
    if(string.length > self.maxLength && self.maxLength >0 ) {
        self.text = [string substringToIndex:self.maxLength];
//        NSString *hint = [NSString stringWithFormat:@"内容过长，已截取前%ld字",(long)self.maxLength];
    }
    
    UILabel *placeLabel = self.placeholderLabel;
    NSObject * obj = notification.object;
    if (obj == self)
    {
        if ([self.text isEqualToString:@""] ||
            self.text == nil)
        {
            placeLabel.hidden = NO;
        }
        else
        {
            placeLabel.hidden = YES;
        }
    }
}

-(CGSize)sizeThatFits:(CGSize)size {
    return size;
}

-(void)setText:(NSString *)text
{
    [super setText:text];
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification
                                                        object:self];
    [self scrollToVisibleArea];
    
}

-(void)scrollToVisibleArea
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.0];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    [self scrollRangeToVisible:self.selectedRange];
    [UIView commitAnimations];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                       change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(contentSize))]) {
        
        NSNumber *max = objc_getAssociatedObject(self, &maxHeightChar);
        NSNumber *min = objc_getAssociatedObject(self, &minHeightChar);
        
        CGRect rect = self.frame;
        CGFloat h = self.contentSize.height;
        
        if (h > [max intValue]) {
            rect.size.height = [max intValue];
        }
        else if (h < [min intValue]) {
            rect.size.height = [min intValue];
        }
        else {
            rect.size.height =  h;
        }
        
        FrameChangeBlock block = objc_getAssociatedObject(self, &charBlock);
        if (block) {
            block(rect);
        }
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.placeholderLabel.frame = CGRectMake(6, 8, self.frame.size.width - 6 * 2, 20);
}

#pragma mark - getters

- (UILabel *)placeholderLabel
{
    if (!_placeholderLabel)
    {
        _placeholderLabel = [UILabel new];
        _placeholderLabel.clipsToBounds = NO;
        _placeholderLabel.autoresizesSubviews = NO;
        _placeholderLabel.numberOfLines = 1;
        _placeholderLabel.font = self.font;
        _placeholderLabel.alpha = 0.4;
        _placeholderLabel.backgroundColor = [UIColor clearColor];
        _placeholderLabel.textColor = [UIColor grayColor];
        _placeholderLabel.hidden = YES;
        
        [self addSubview:_placeholderLabel];
    }
    return _placeholderLabel;
}
- (NSString *)placeholder
{
    return self.placeholderLabel.text;
}

#pragma mark - setter

- (void)setPlaceholder:(NSString *)placeholder
{
    self.placeholderLabel.text = placeholder;
}


#pragma mark - override

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.text.length == 0 && self.placeholder.length > 0) {
        self.placeholderLabel.frame = CGRectInset(rect, 0, 5.0);
        self.placeholderLabel.hidden = NO;
        [self sendSubviewToBack:self.placeholderLabel];
    }
}

#pragma mark - paste

- (id)pasteboardItem
{
    UIImage *image = [[UIPasteboard generalPasteboard] image];
    NSString *text = [[UIPasteboard generalPasteboard] string];
    
    if (image) {
        return image;
    }
    else if (text.length > 0) {
        return text;
    }
    else {
        return nil;
    }
}
- (void)paste:(id)sender
{
    id item = [self pasteboardItem];
    
    if ([item isKindOfClass:[UIImage class]]) {
        //TODO:粘贴的是图片
    }
    else if ([item isKindOfClass:[NSString class]]){
        
        [self insertTextAtCaretRange:item];
    }
}

#pragma mark - textView delegate

- (void)insertTextAtCaretRange:(NSString *)text
{
    NSRange range = [self insertText:text inRange:self.selectedRange];//计算粘贴之后的selectRange
    self.selectedRange = NSMakeRange(range.location, 0);
}
- (NSRange)insertText:(NSString *)text inRange:(NSRange)range
{
    if (text.length == 0) {
        return NSMakeRange(0, 0);
    }
    
    if (range.length == 0)
    {
        NSString *leftString = [self.text substringToIndex:range.location];
        NSString *rightString = [self.text substringFromIndex: range.location];
        
        self.text = [NSString stringWithFormat:@"%@%@%@", leftString, text, rightString];
        
        range.location += [text length];
        return range;
    }
    else if (range.length > 0)
    {
        self.text = [self.text stringByReplacingCharactersInRange:range withString:text];
        
        return NSMakeRange(range.location+[self.text rangeOfString:text].length, text.length);
    }
    return self.selectedRange;
}


-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
//    [self removeObserver:self forKeyPath:@"contentSize"];
    
    UILabel *placeLabel = self.placeholderLabel;
    [placeLabel removeFromSuperview];
    placeLabel = nil ;
    
    objc_setAssociatedObject(self, &maxHeightChar, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &maxHeightChar, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &charBlock, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

-(void)removeFromSuperview
{
    [super removeFromSuperview];
}

@end