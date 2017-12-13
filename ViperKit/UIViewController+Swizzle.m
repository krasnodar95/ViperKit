//
//  UIViewController+Swizzle.m
//  ViperKit
//
//  Created by Руслан Болатаев on 08/12/2017.
//  Copyright © 2017 Lead Group. All rights reserved.
//

#import "UIViewController+Swizzle.h"

#import <objc/runtime.h>

#import "ModuleInput.h"
#import "TransitionHandler.h"

static NSString *const TokenId = @"UIViewController.prepareForSegue";

@implementation UIViewController (Swizzle)

+ (void)initialize {
  if (self == [UIViewController class]) {
    [self swizzlePrepareForSegue];
  }
}

+ (void)swizzlePrepareForSegue {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    Method oldMethod = class_getInstanceMethod(self, @selector(prepareForSegue:sender:));
    Method newMethod = class_getInstanceMethod(self, @selector(newPrepareForSegue:sender:));
    method_exchangeImplementations(oldMethod, newMethod);
  });
}

- (void)newPrepareForSegue:(UIStoryboardSegue *)segue
                    sender:(id)sender {
  [self newPrepareForSegue:segue sender:sender];
  
  UIViewController *destinationViewController = segue.destinationViewController;
  if (destinationViewController && [destinationViewController isKindOfClass: [UINavigationController class]]) {
    destinationViewController = ((UINavigationController *)destinationViewController).topViewController;
  }
  
  if (destinationViewController && [destinationViewController.class conformsToProtocol:@protocol(ModuleInput)]) {
    ((ConfigurationBlock)sender)((id<ModuleInput>)destinationViewController);
  }
}

@end
