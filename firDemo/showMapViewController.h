//
//  showMapViewController.h
//  firDemo
//
//  Created by KWTMAC01 on 8/2/17.
//  Copyright © 2017 KWTMAC01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "filterDelegates.h"
#import <GoogleMaps/GoogleMaps.h>

@interface showMapViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *Citylist;
@property (nonatomic, strong) NSMutableArray *cityNameArray;
@property (nonatomic, strong) NSMutableArray *cityIDArray;


@property (nonatomic, strong) NSArray *polygonList;

@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (strong, nonatomic) filterDelegates *filterDel;

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@property (strong, nonatomic)GMSMarker *addressMarker;
@property (strong, nonatomic)GMSCameraPosition *camera;
@property (nonatomic, strong) GMSPolygon *polygon;
@property (nonatomic, strong) GMSPolygon *drawPolygon;

@property(nonatomic)CLLocationCoordinate2D *locationManager;
@property (weak, nonatomic) IBOutlet UIButton *drawMapBtn_Outlet;
@property (weak, nonatomic) IBOutlet UIButton *saveAreaBtn_Outlet;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn_outlet;



@end
