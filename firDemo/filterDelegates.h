//
//  filterDelegates.h
//  firDemo
//
//  Created by KWTMAC01 on 8/2/17.
//  Copyright © 2017 KWTMAC01. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JNOFilter <NSObject>
-(void)didApplyFilter:(NSString*)filterVal andID:(NSString*)ID andPolygon:(NSArray*)polygon andObject:(id)object;

@end



@interface filterDelegates : NSObject
@property (nonatomic, retain) id <JNOFilter> delegate;
-(void)applyFilter:(NSString*)filterVal andID:(NSString*)ID andPolygon:(NSArray *)polygon andObject:(id)object;
+ (instancetype)sharedInstance;


@end
