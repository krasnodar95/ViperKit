//
//  TransitionHandler.h
//  ViperKit
//
//  Created by Руслан Болатаев on 13/12/2017.
//  Copyright © 2017 Lead Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ModuleInput;

typedef void(^ConfigurationBlock)(id<ModuleInput>);

@protocol TransitionHandler <NSObject>

@property (nonatomic, strong, readonly) id<ModuleInput> moduleInput;

-(void)openModule: (NSString *)segueIdentifier;
-(void)openModule: (NSString *)segueIdentifier
configurationBlock: (ConfigurationBlock)configurationBlock;
-(void)closeCurrentModuleAnimated: (BOOL)animated;

@end
