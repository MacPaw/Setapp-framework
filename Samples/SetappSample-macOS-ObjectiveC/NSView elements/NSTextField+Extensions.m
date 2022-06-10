//
//  NSTextField+Extensions.m
//  SetappSample-macOS-ObjectiveC
//
//  Created by Aleksandr.Bilous on 22.04.2022.
//

#import "NSTextField+Extensions.h"

@implementation NSTextField(Extensions)

+ (instancetype)label
{
    NSTextField *textField = [[NSTextField alloc] initWithFrame:NSZeroRect];
    textField.bezeled = NO;
    textField.bordered = NO;
    textField.editable = NO;
    textField.selectable = NO;
    textField.backgroundColor = [NSColor clearColor];
    textField.textColor = [NSColor colorNamed:@"dynamicInvertedColor"];
    return textField;
}

+ (instancetype)editableField
{
    NSTextField *textField = [[NSTextField alloc] initWithFrame:NSZeroRect];
    textField.cell = [[CustomNSTextFieldCell alloc] initTextCell:@""];
    textField.wantsLayer = YES;
    textField.layer.cornerRadius = 4;
    textField.bezeled = NO;
    textField.backgroundColor = [NSColor colorNamed:@"textFieldBackgroundColor"];
    textField.textColor = [NSColor colorNamed:@"dynamicInvertedColor"];
    [textField setEditable:YES];
    [textField.layer setBorderWidth:1.0];
    [textField.layer setBorderColor:[NSColor colorNamed:@"textFieldBorderColor"].CGColor];
    return textField;
}

@end

#pragma mark - CustomNSTextField

@implementation CustomNSTextFieldCell

- (NSRect)titleRectForBounds:(NSRect)frame
{
    NSRect titleRect = [super titleRectForBounds:frame];
    CGFloat minimumHeight = [self cellSizeForBounds:frame].height;
    titleRect.origin.y += (frame.size.height - minimumHeight) / 2.0;
    titleRect.size.height = minimumHeight;
    return titleRect;
}

- (void)drawInteriorWithFrame:(NSRect)cFrame inView:(NSView*)cView
{
    [super drawInteriorWithFrame:[self titleRectForBounds:cFrame] inView:cView];
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    [super drawWithFrame:[self titleRectForBounds:cellFrame] inView:controlView];
}

-(void)editWithFrame:(NSRect)rect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)delegate event:(NSEvent *)event
{
    [super editWithFrame:[self titleRectForBounds:rect] inView:controlView editor:textObj delegate:delegate event:event];
}

- (void)selectWithFrame:(NSRect)rect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)delegate start:(NSInteger)selStart length:(NSInteger)selLength
{
    [super selectWithFrame:[self titleRectForBounds:rect] inView:controlView editor:textObj delegate:delegate start:selStart length:selLength];
}

@end
