//
//  countryCitiesAreaList.m
//  firDemo
//
//  Created by KWTMAC01 on 8/2/17.
//  Copyright © 2017 KWTMAC01. All rights reserved.
//

#import "countryCitiesAreaList.h"
//#import "JNOResturantMenuList.h"


@implementation CountryCitiesListResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"returnCode":@"returnCode",
             @"MessageText":@"MessageText",
             @"cityInfo":@"cityInfo"
             };
}


+ (NSValueTransformer *)categoryTypeJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id obj, BOOL *success, NSError *__autoreleasing *error) {
        //obj=[(NSDictionary*)obj objectForKey:@"categoriesInfo"];
        if([obj isKindOfClass:[NSArray class]]){
            return [MTLJSONAdapter modelsOfClass:CategoryInfo.class fromJSONArray:obj error:nil];
        }   else{
            return [[NSArray alloc]initWithObjects: [MTLJSONAdapter modelOfClass:CategoryInfo.class  fromJSONDictionary:(NSDictionary*)obj error:nil], nil];
        }}];
}

/*+ (NSValueTransformer *)cityInfoJSONTransformer {
 return  [MTLJSONAdapter arrayTransformerWithModelClass:[JNOCity class]];
 }*/

+ (NSValueTransformer *)cityInfoJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id obj, BOOL *success, NSError *__autoreleasing *error) {
        if([obj isKindOfClass:[NSArray class]]){
            NSError *err;
            NSArray*ar= [MTLJSONAdapter modelsOfClass:City.class fromJSONArray:obj error:&err];
            NSLog(@"%@",err);
            return ar;
        }   else{
            return [[NSArray alloc]initWithObjects: [MTLJSONAdapter modelOfClass:City.class  fromJSONDictionary:(NSDictionary*)obj error:nil], nil];
        }}];
}

@end


@implementation countryCitiesAreasList

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"countryCitiesListResponse":@"countryCitiesListResponse"
             };
}

@end

@implementation Category

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"categoryID":@"categoryID",
             @"catergoryName":@"catergoryName",
             @"attributes":@"attributes",
             };
}
//+ (NSValueTransformer *)attributesJSONTransformer {
//    return [MTLValueTransformer transformerUsingForwardBlock:^id(id obj, BOOL *success, NSError *__autoreleasing *error) {
//        if([obj isKindOfClass:[NSArray class]]){
//            return [MTLJSONAdapter modelsOfClass:JNOAttributes.class fromJSONArray:obj error:nil];
//        }   else{
//            return [[NSArray alloc]initWithObjects: [MTLJSONAdapter modelOfClass:JNOAttributes.class  fromJSONDictionary:(NSDictionary*)obj error:nil], nil];
//        }}];
//}

@end

@implementation CategoryInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"categoryTypeID":@"categoryTypeID",
             @"catergoryTypeName":@"catergoryTypeName",
             @"categoriesInfo":@"categoriesInfo"
             };
}
+ (NSValueTransformer *)categoriesInfoJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id obj, BOOL *success, NSError *__autoreleasing *error) {
        if([obj isKindOfClass:[NSArray class]]){
            return [MTLJSONAdapter modelsOfClass:Category.class fromJSONArray:obj error:nil];
        }   else{
            return [[NSArray alloc]initWithObjects: [MTLJSONAdapter modelOfClass:Category.class  fromJSONDictionary:(NSDictionary*)obj error:nil], nil];
        }}];
}

@end
@implementation City

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"cityID":@"cityID",
             @"cityName":@"cityName",
             @"areaInfo":@"areaInfo"
             };
}
+ (NSValueTransformer *)areaInfoJSONTransformer {
    return  [MTLJSONAdapter arrayTransformerWithModelClass:[Area class]];
}

@end


@implementation CoordinateMain

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"coordinate":@"coordinate",
             };
}

+ (NSValueTransformer *)coordinateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id obj, BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter modelOfClass:Coordinate.class  fromJSONDictionary:(NSDictionary*)obj error:nil];
    }];
}

@end

@implementation Coordinate

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"lat":@"lat",
             @"lng":@"lng",
             };
}

@end

@implementation Area

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"areaID":@"areaID",
             @"areaName":@"areaName",
             @"polygons":@"polygons"
             };
}

/*+ (NSValueTransformer *)categoryIDsJSONTransformer {
 return  [MTLJSONAdapter arrayTransformerWithModelClass:[NSNumber class]];
 }*/

+ (NSValueTransformer *)polygonsJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id obj, BOOL *success, NSError *__autoreleasing *error) {
        if([obj isKindOfClass:[NSArray class]]){
            return [MTLJSONAdapter modelsOfClass:CoordinateMain.class fromJSONArray:obj error:nil];
        }   else{
            return [[NSArray alloc]initWithObjects: [MTLJSONAdapter modelOfClass:CoordinateMain.class  fromJSONDictionary:(NSDictionary*)obj error:nil], nil];
        }}];
}

+ (NSValueTransformer *)categoryIDsJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id obj, BOOL *success, NSError *__autoreleasing *error) {
        if([obj isKindOfClass:[NSArray class]]){
            return obj;
        }   else{
            return [[NSArray alloc]initWithObjects:obj, nil];
        }}];
}
@end
