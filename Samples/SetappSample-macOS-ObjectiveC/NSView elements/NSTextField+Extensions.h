//
//  NSTextField+Extension.h
//  SetappSample-macOS-ObjectiveC
//
//  Created by Aleksandr.Bilous on 22.04.2022.
//

#import <Foundation/Foundation.h>
@import Cocoa;

NS_ASSUME_NONNULL_BEGIN

@interface NSTextField (Extensions)

+ (instancetype)label;
+ (instancetype)editableField;

@end

@interface CustomNSTextFieldCell: NSTextFieldCell
@end

NS_ASSUME_NONNULL_END
