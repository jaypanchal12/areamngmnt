//
//  countryCitiesAreaList.h
//  firDemo
//
//  Created by KWTMAC01 on 8/2/17.
//  Copyright © 2017 KWTMAC01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>


@interface CountryCitiesListResponse :  MTLModel <MTLJSONSerializing>
@property(nonatomic, copy,readonly) NSString *returnCode;
@property(nonatomic, copy,readonly) NSString *MessageText;
@property(nonatomic, copy,readonly) NSMutableArray *cityInfo;
@end


@interface countryCitiesAreasList :  MTLModel <MTLJSONSerializing>
@property(nonatomic, copy,readonly) CountryCitiesListResponse *countryCitiesListResponse;
@end


@interface Category :  MTLModel <MTLJSONSerializing>
@property(nonatomic, copy) NSString *categoryID;
@property(nonatomic, copy)NSString *catergoryName;
@property(nonatomic, copy) NSArray *attributes;

@end

@interface CategoryInfo :  MTLModel <MTLJSONSerializing>
@property(nonatomic, copy) NSString *categoryTypeID;
@property(nonatomic, copy)NSString *catergoryTypeName;
@property(nonatomic, copy) NSArray *categoriesInfo;
@end


@interface Area:  MTLModel <MTLJSONSerializing>
@property(nonatomic, copy,readonly) NSString *areaID;
@property(nonatomic, copy,readonly) NSString *areaName;
@property(nonatomic, copy,readonly) NSArray *polygons;
@end

@interface City :  MTLModel <MTLJSONSerializing>
@property(nonatomic, copy) NSString *cityID;
@property(nonatomic, copy) NSString *cityName;
@property(nonatomic, copy) NSArray<Area*> *areaInfo;
@end

@interface Coordinate :  MTLModel <MTLJSONSerializing>
@property(nonatomic, copy,readonly) NSString *lat;
@property(nonatomic, copy,readonly) NSString *lng;
@end

@interface CoordinateMain :  MTLModel <MTLJSONSerializing>
@property(nonatomic, copy,readonly) Coordinate *coordinate;
@end



