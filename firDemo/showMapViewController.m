//
//  showMapViewController.m
//  firDemo
//
//  Created by KWTMAC01 on 8/2/17.
//  Copyright © 2017 KWTMAC01. All rights reserved.
//

#import "showMapViewController.h"
#import "countryCitiesAreaList.h"
#import "areasViewController.h"
#import "filterDelegates.h"
#import "LMGeocoder.h"
@import Firebase;


@interface showMapViewController ()<JNOFilter,GMSMapViewDelegate>
@property (strong, nonatomic)FIRDatabaseReference *rootRef;
@end
//CGPoint location;
UIImageView *drawImage;
CGPoint lastPoint;

CGPoint currentPoint;

NSMutableArray *latLang;
BOOL mouseSwiped;







@implementation showMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    latLang=[[NSMutableArray alloc]init];
    
    self.filterDel=[filterDelegates sharedInstance];
    self.filterDel.delegate=self;
    [self fetchAreaFromFirbase];
    //map
    
    self.camera = [GMSCameraPosition cameraWithLatitude:self.mapView.myLocation.coordinate.latitude
                                              longitude:self.mapView.myLocation.coordinate.longitude
                                                   zoom:13];
    self.mapView.camera = self.camera;
    self.mapView.trafficEnabled=YES;
    self.mapView.myLocationEnabled = YES;
    self.mapView.delegate=self;
    
       
    double longitude=self.mapView.myLocation.coordinate.longitude;
    double latitude=self.mapView.myLocation.coordinate.latitude;
    if(longitude==0||latitude==0){
       // longitude=47.983;
       // latitude=29.3519;
    }
    
    if(!self.addressMarker)
        self.addressMarker = [[GMSMarker alloc] init];
    self.addressMarker.position = CLLocationCoordinate2DMake(latitude,longitude);
    self.addressMarker.title = @"";
    self.addressMarker.snippet = @"";
    self.addressMarker.icon = [UIImage imageNamed:@"home_icon"];
    self.addressMarker.map=self.mapView;
    self.camera = [GMSCameraPosition cameraWithLatitude:latitude
                                              longitude:longitude
                                                   zoom:self.mapView.camera.zoom];
    self.mapView.camera = self.camera;
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    double longitude=self.mapView.myLocation.coordinate.longitude;
    double latitude=self.mapView.myLocation.coordinate.latitude;
    
    if(longitude==0||latitude==0){
        //longitude=47.983;
       // latitude=29.3519;
    }

    if(!self.addressMarker)
        self.addressMarker = [[GMSMarker alloc] init];
    self.addressMarker.position = CLLocationCoordinate2DMake(latitude,longitude);
    self.addressMarker.title = @"";
    self.addressMarker.snippet = @"";
    self.addressMarker.icon = [UIImage imageNamed:@"home_icon"];
    self.addressMarker.map=self.mapView;
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.1];
    self.camera = [GMSCameraPosition cameraWithLatitude:latitude
                                              longitude:longitude
                                                   zoom:self.mapView.camera.zoom];
    self.mapView.camera = self.camera;
    [CATransaction commit];
    
}

-(void)didApplyFilter:(NSString*)filterVal andID:(NSString*)ID andPolygon:(NSArray*)polygon andObject:(id)object;
{
    if (!object) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{

    self.areaLabel.text=[filterVal capitalizedString];
        
        self.polygonList=polygon;
        [self drawAreaBorders];
        [self getCityName];
        

    });
   }

-(void)getCityName{
    NSString *cityDetail=[NSString stringWithFormat:@"%@,Kuwait",self.areaLabel.text];
    
    [[LMGeocoder sharedInstance] geocodeAddressString:cityDetail
                                              service:kLMGeocoderGoogleService
                                    completionHandler:^(NSArray *results, NSError *error) {
                                        if (results.count && !error) {
                                            LMAddress *address = [results firstObject];
                                            NSLog(@"Coordinate: (%f, %f)", address.coordinate.latitude, address.coordinate.longitude);
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                
                                                self.addressMarker.position = CLLocationCoordinate2DMake(address.coordinate.latitude,address.coordinate.longitude);
                                                
                                                self.camera = [GMSCameraPosition cameraWithLatitude:address.coordinate.latitude
                                                                                          longitude:address.coordinate.longitude
                                                                                               zoom:13];
                                                self.addressMarker.map=self.mapView;
                                                
                                                self.mapView.camera = self.camera;

                                                
                                            });
                                            
                                            
                                        }
                                        
                                        else
                                            NSLog(@"%@",error);
                                    }];

}


-(void)fetchAreaFromFirbase
{
    self.rootRef= [[FIRDatabase database] referenceFromURL:[NSString stringWithFormat:@"%@/countryCitiesListResponse",@"https://areas-managment.firebaseio.com/"]];
    [self.rootRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (snapshot.exists)
             {
                 if (![snapshot.value isKindOfClass:NSDictionary.class]) {
                   //  NSLog(@"%@",snapshot.value);
                     return ;
                 }
               //  NSLog(@"%@",snapshot.value);
                 NSError *error=nil;
                 
                 CountryCitiesListResponse *CCLR=[[CountryCitiesListResponse alloc]init];
                 
                 CCLR= [MTLJSONAdapter modelOfClass:CountryCitiesListResponse.class  fromJSONDictionary:snapshot.value error:&error];
                 self.Citylist=CCLR.cityInfo;
                 
               //  NSLog(@"%@", self.Citylist);
                 if ([self.areaLabel.text isEqualToString:@""]) {
                     [self selectArea:nil];
                 }
                 
                 
             }
             
             
         });
     }];
}

-(IBAction)selectArea:(id)sender
{
    
    [self removeBorders ];
        UIStoryboard*storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        areasViewController *controller = [storyBoard instantiateViewControllerWithIdentifier:@"areas"];
        controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        controller.list=self.Citylist;
        [self presentViewController:controller animated:YES completion:nil];
    
    

}

-(void)viewWillAppear:(BOOL)animated
{

}

-(void) removeBorders{
    
    
    self.polygon.map = nil;

    
}


-(void)drawAreaBorders{
    GMSMutablePath*pathDynamic = [[GMSMutablePath alloc] init];
    for(CoordinateMain* coor in self.polygonList){
            CLLocation *loc = [[CLLocation alloc] initWithLatitude:coor.coordinate.lat.doubleValue longitude:coor.                          coordinate.lng.doubleValue];
            [pathDynamic addCoordinate:loc.coordinate];//Add your location in mutable path
                   }

    
                 
            self.polygon = [GMSPolygon polygonWithPath:pathDynamic];
            // Add the polyline to the map.
                self.polygon.strokeColor =[UIColor purpleColor ];
                self.polygon.strokeWidth = 2.0f;
                self.polygon.map = self.mapView;
                self.polygon.fillColor=[UIColor colorWithRed:101.0f/255.0f green:45.0f/255.0f blue:144.0f/255.0f alpha:0.2f];
}


- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position{
    
    
    self.addressMarker.position = position.target;
    
    
}

//Draw polygon from map

-(IBAction)drawMap:(id)sender{
    
    self.mapView.userInteractionEnabled = NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    drawImage.image = [defaults objectForKey:@"drawImageKey"];
    
    drawImage = [[UIImageView alloc] initWithImage:nil];
    
    drawImage.frame = CGRectMake(0, 0, self.mapView.frame.size.width, self.mapView.frame.size.height);
    
    [self.mapView addSubview:drawImage];
    
    drawImage.backgroundColor = [UIColor clearColor];
    

    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    

    UITouch *touch = [[event allTouches] anyObject];
    
    if ([touch tapCount] == 2) {
        
        drawImage.image = nil;
        
    }
    
   // location = [touch locationInView:self.mapView];
    
    
    lastPoint = [touch locationInView:self.mapView];
    
    lastPoint.y -= 0;
    
    mouseSwiped = YES;
    
    [super touchesBegan: touches withEvent: event];
    

}



-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    currentPoint = [touch locationInView:self.mapView];
    
    UIGraphicsBeginImageContext(CGSizeMake(self.mapView.frame.size.width, self.mapView.frame.size.height));
    
    [drawImage.image drawInRect:CGRectMake(0, 0, self.mapView.frame.size.width, self.mapView.frame.size.height)];
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapButt);
    
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.0);
    
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.5, 0, 0.5, 1);
    
    
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    [drawImage setFrame:CGRectMake(0, 0, self.mapView.frame.size.width, self.mapView.frame.size.height)];
    
    drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    //converting points to latitude and longitude
    
    if (mouseSwiped) {
        
        NSLog(@"CurrentPoint:%@",NSStringFromCGPoint(currentPoint));
        NSLog(@"last point:%@",NSStringFromCGPoint(lastPoint));
        
        
        CLLocationCoordinate2D centerOfMapCoord =[self.mapView.projection coordinateForPoint: currentPoint];        //Step 2

        
        CLLocation *towerLocation = [[CLLocation alloc] initWithLatitude:centerOfMapCoord.latitude longitude:centerOfMapCoord.longitude];
        
        [latLang addObject:towerLocation];
        
    }
    
    lastPoint = currentPoint;
    
}



-(IBAction)saveMap:(id)sender {
    
    [drawImage removeFromSuperview];
    
    self.mapView.userInteractionEnabled=YES;
    
    GMSMutablePath*pathDynamic = [[GMSMutablePath alloc] init];
    
    for(int idx = 0; idx < [latLang count]; idx++) {
        
        CLLocation* locationCL = [latLang objectAtIndex:idx];
        
        [pathDynamic addCoordinate:locationCL.coordinate];//Add your location in mutable path
        
        
    }
    
    self.polygon = [GMSPolygon polygonWithPath:pathDynamic];
    // Add the polyline to the map.
    //  self.polygon.fillColor = [UIColor colorWithRed:43.0f/255.0f green:181.0f/255.0f blue:54.0f/255.0f alpha:0.001];
    self.polygon.strokeColor =[UIColor purpleColor ];
    self.polygon.strokeWidth = 2.0f;
    self.polygon.map = self.mapView;
    self.polygon.fillColor=[UIColor colorWithRed:101.0f/255.0f green:45.0f/255.0f blue:144.0f/255.0f alpha:0.2f];
    
}

@end
