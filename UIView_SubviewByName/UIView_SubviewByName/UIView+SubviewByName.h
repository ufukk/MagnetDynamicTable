//
//  UIView+SubviewByName.h
//  UIView_SubviewByName
//
//  Created by ufuk on 06/03/15.
//  Copyright (c) 2015 macroismicro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

static const int TAG_INDEX_OFFSET = 10000;

@interface UIView(SubviewByName)

@property (nonatomic, strong) NSMutableDictionary *nameViewMap;

@property (nonatomic) NSMutableDictionary *groupNameViewMap;

- (UIView *)subviewByName:(NSString *)name;

- (NSArray *)subviewsByGroupName:(NSString *)groupName;

- (void)addSubview:(UIView *)view withName:(NSString *)name;

- (void)addSubview:(UIView *)view withGroupName:(NSString *)groupName;

- (void)addSubview:(UIView *)view withName:(NSString *)name groupName:(NSString *)groupName;

- (void)setNames:(NSArray *)names groupNames:(NSArray *)groupNames forSubviews:(NSArray *)subviews;

- (void)removeSubviewWithName:(NSString *)name;

- (void)removeSubviewsWithGroupName:(NSString *)groupName;

@end
