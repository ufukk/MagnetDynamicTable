//
//  UIView+SubviewByName.m
//  UIView_SubviewByName
//
//  Created by ufuk on 06/03/15.
//  Copyright (c) 2015 macroismicro. All rights reserved.
//

#import "UIView+SubviewByName.h"
#import <objc/runtime.h>

static const void *nameViewMapPropertyKey = &nameViewMapPropertyKey;
static const void *groupViewMapPropertyKey = &groupViewMapPropertyKey;

@implementation UIView(SubviewByName)

- (NSMutableDictionary *)nameViewMap {
    return objc_getAssociatedObject(self, nameViewMapPropertyKey);
}

- (void)setNameViewMap:(NSMutableDictionary *)nameViewMap {
    objc_setAssociatedObject(self, nameViewMapPropertyKey, nameViewMap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)groupNameViewMap {
    return objc_getAssociatedObject(self, groupViewMapPropertyKey);
}

- (void)setGroupNameViewMap:(NSMutableDictionary *)groupNameViewMap {
    objc_setAssociatedObject(self, groupViewMapPropertyKey, groupNameViewMap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)checkMaps {
    if(self.nameViewMap == nil)
        self.nameViewMap = [NSMutableDictionary new];
    
    if(self.groupNameViewMap == nil)
        self.groupNameViewMap = [NSMutableDictionary new];

}

- (UIView *)subviewByName:(NSString *)name {
    int tag = [[self.nameViewMap objectForKey:name] intValue];
    for(UIView *view in self.subviews) {
        if(view.tag == tag)
            return view;
    }
    return nil;
}

- (NSArray *)subviewsByGroupName:(NSString *)groupName {
    NSMutableArray *result = [NSMutableArray new];
    NSArray *tags = [self.groupNameViewMap objectForKey:groupName];
    for(UIView *view in self.subviews) {
        if([tags containsObject:[NSNumber numberWithInt:view.tag]])
            [result addObject:view];
    }
    
    return result;
}

- (void)removeSubviewWithName:(NSString *)name {
    UIView *view = [self subviewByName:name];
    if(view != nil)
        [view removeFromSuperview];
}

- (void)removeSubviewsWithGroupName:(NSString *)groupName {
    for(UIView *view in [self subviewsByGroupName:groupName]) {
        [view removeFromSuperview];
    }
}

- (void)setNames:(NSArray *)names groupNames:(NSArray *)groupNames forSubviews:(NSArray *)subviews {
    [self checkMaps];
    for(int i = 0; i < subviews.count; i++) {
        UIView *view = [subviews objectAtIndex:i];
        if(view.tag < TAG_INDEX_OFFSET || view.tag > TAG_INDEX_OFFSET + self.nameViewMap.count) {
            view.tag = [NSNumber numberWithInt:TAG_INDEX_OFFSET + self.nameViewMap.count].intValue;
        }
        if(names.count > i)
            [self.nameViewMap setObject:[NSNumber numberWithInt:view.tag] forKey:[names objectAtIndex:i]];
        
        if(groupNames.count > i)
            [self.nameViewMap setObject:[NSNumber numberWithInt:view.tag] forKey:[names objectAtIndex:i]];
    }
}

- (void)addSubview:(UIView *)view withName:(NSString *)name {
    [self addSubview:view withName:name groupName:nil];
}

- (void)addSubview:(UIView *)view withGroupName:(NSString *)groupName {
    [self addSubview:view withName:nil groupName:groupName];
}

- (void)addSubview:(UIView *)view withName:(NSString *)name groupName:(NSString *)groupName {
    [self addSubview:view];
    
    [self checkMaps];
    
    NSNumber *tag = [NSNumber numberWithInt:self.nameViewMap.count + TAG_INDEX_OFFSET];
    view.tag = tag.intValue;
    
    if(name != nil) {
        [self.nameViewMap setObject:tag forKey:name];
    }
    
    if(groupName != nil) {
        NSMutableArray *list = [NSMutableArray arrayWithArray:[self.groupNameViewMap objectForKey:groupName]];
        [list addObject:tag];
        [self.groupNameViewMap setObject:list forKey:groupName];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
