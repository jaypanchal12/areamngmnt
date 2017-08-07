//
//  filterDelegates.m
//  firDemo
//
//  Created by KWTMAC01 on 8/2/17.
//  Copyright © 2017 KWTMAC01. All rights reserved.
//

#import "filterDelegates.h"

@implementation filterDelegates

+ (instancetype)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
        
    });
    return _sharedObject;
}
-(void)applyFilter:(NSString*)filterVal andID:(City*)ID  andPolygon:(NSArray *)polygon andObject:(id)object{
    [self.delegate didApplyFilter:filterVal andID:ID andPolygon:polygon andObject:object];
}


@end
