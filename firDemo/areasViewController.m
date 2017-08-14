//
//  areasViewController.m
//  firDemo
//
//  Created by KWTMAC01 on 8/2/17.
//  Copyright © 2017 KWTMAC01. All rights reserved.
//

#import "areasViewController.h"
#import "filterHeaderView.h"
#import "countryCitiesAreaList.h"
#import "filterDelegates.h"
#import "SCLAlertView.h"
@import Firebase;



#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define iosMinumumSearchbarBG @"9"





@interface areasViewController () <UITableViewDelegate,UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *areaSearchBar;
@property (nonatomic, strong) CountryCitiesListResponse *ccAreaList;
@property (strong, nonatomic)FIRDatabaseReference *rootRef;
@property (nonatomic, strong) NSMutableArray *latlongArray;
@property (nonatomic, strong) NSMutableDictionary *latlongDict;
@property (nonatomic, strong) NSMutableDictionary *coordinateDict;
@property (nonatomic, strong) NSMutableDictionary *coordinateDict1;




@end

@implementation areasViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.filteredList=self.list;

    
    
    self.areaSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    self.areaSearchBar.placeholder=@"Search Area";
    self.areaSearchBar.delegate=self;
    self.areaSearchBar.showsCancelButton=YES;
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:@"Cancel"];

    
    if (SYSTEM_VERSION_LESS_THAN(iosMinumumSearchbarBG)) {
    }
    else{
        [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTintColor:[UIColor colorWithRed:101.0f/255.0f green:45.0f/255.0f blue:162.0f/255.0f alpha:1.0f]];

    }


    
    
    
    self.areaSearchBar.barTintColor=[UIColor colorWithRed:((float)(((0xf2ebf8) & 0xFF0000) >> 16))/255.0 \
                                                 green:((float)(((0xf2ebf8) & 0xFF00) >> 8))/255.0 \
                                                  blue:((float)((0xf2ebf8) & 0xFF))/255.0 \
                                                 alpha:1.0];
    [UIBarButtonItem appearance].enabled = NO;
    self.areasTableView.tableHeaderView = self.areaSearchBar;
    
    self.areasTableView.delegate = self;
    self.areasTableView.backgroundColor = [UIColor clearColor];
    
    NSMutableArray*sections=[[NSMutableArray alloc]init];
    
    for (int x=0; x<self.list.count;x++ ) {
        
        
        SSSection *sec=[SSSection sectionWithItems:((City*)self.list[x]).areaInfo header:((City*)self.list[x]).cityName  footer:nil identifier:@"asas"];
        [self.areasTableView registerClass:filterHeaderView.class
     forHeaderFooterViewReuseIdentifier:@"dd"];
        sec.headerHeight=100;
        [sections addObject:sec];
        
        

    }
    self.elementDataSource = [[SSSectionedDataSource alloc] initWithSections:sections];

    
    if (self.list.count==0) {
        //[JNOLoader showWithStatus:@""];
    }
    
    self.elementDataSource.rowAnimation = UITableViewRowAnimationFade;
    self.elementDataSource.tableActionBlock = ^BOOL(SSCellActionType actionType,
                                                    UITableView *tableView,
                                                    NSIndexPath *indexPath) {
        return (actionType == SSCellActionTypeMove);
        return NO;
    };

    
    self.elementDataSource.tableDeletionBlock = ^(SSSectionedDataSource *aDataSource,
                                                  UITableView *tableView,
                                                  NSIndexPath *indexPath) {
        [aDataSource removeItemAtIndexPath:indexPath];
    };

    self.areasTableView.backgroundColor=[UIColor clearColor];
    self.areasTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.elementDataSource.tableView=self.areasTableView;

    
    self.elementDataSource.cellConfigureBlock = ^(UITableViewCell *cell,
                                                  Area *elementObject,
                                                  UITableView *tableView,
                                                  NSIndexPath *indexPath) {
        
        cell.textLabel.text=[elementObject.areaName capitalizedString];
        cell.textLabel.textColor=[UIColor grayColor];
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
        
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    };

    
}


-(void)viewWillAppear:(BOOL)animated
{
    [self enableCancelButton];
}




- (void)enableCancelButton{
    for (UIView *view in self.areaSearchBar.subviews){
        for (id subview in view.subviews){
            if ([subview isKindOfClass:[UIButton class]]){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10), dispatch_get_main_queue(), ^{
                    [subview setEnabled:YES];
                });
                return;
            }
        }
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SSSection*requiredSec=(SSSection*)self.elementDataSource.sections[section];
    filterHeaderView *header = (filterHeaderView*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:requiredSec.sectionIdentifier];
    if( !header )
        header = (filterHeaderView*)[[NSBundle mainBundle] loadNibNamed:@"View" owner:self options:nil][0];
    header.headerLabel.text = requiredSec.header;
    
    
    [header.addCityBtn addTarget:self action:@selector(popButtonClicked:event:) forControlEvents:UIControlEventTouchUpInside];

    header.textLabel.text=@"";
    header.detailTextLabel.text=@"";
    header.tintColor=[UIColor redColor];
    header.addCityBtn.tag=section;
    return header;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    SSSection*requiredSec=(SSSection*)self.elementDataSource.sections[(NSUInteger)indexPath.section];
    
    NSLog(@"%ld",(long)indexPath.section);
    NSString*filter=@"";
    NSArray *poly=[[NSArray alloc]init];
    
    filterDelegates*obj=[filterDelegates sharedInstance];
    
        filter=((Area*)requiredSec.items[indexPath.row]).areaName;
        poly=((Area*)requiredSec.items[indexPath.row]).polygons;

        City*city=(City*)self.filteredList[indexPath.section];

    [obj applyFilter:filter andID:city.cityName andPolygon:poly andObject:requiredSec.items[indexPath.row]];

    
    [self dismiss:nil];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.0f;
}


-(void)applyFilter{
    filterDelegates*obj=[filterDelegates sharedInstance];
    [obj applyFilter:@"" andID:nil andPolygon:nil andObject:nil];
}


- (IBAction)close:(id)sender {
    [self applyFilter];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


-(void)viewWillDisappear:(BOOL)animated{
   // if(self.list.count==0)
      //  [JNOLoader dismiss];
   // [self dismiss:nil];
}


- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSArray *filteredArray=[self filterTags:searchText];
    NSMutableArray*sections=[[NSMutableArray alloc]init];
    [self.elementDataSource removeAllSections];
    self.filteredList=[[NSMutableArray alloc]init];

    for (int x=0; x<filteredArray.count;x++ ) {
        SSSection *sec=[SSSection sectionWithItems:((City*)filteredArray[x]).areaInfo header:((City*)filteredArray[x]).cityName  footer:nil identifier:@"asas"];
        
        [self.filteredList addObject:[filteredArray objectAtIndex:x]];

        
        [self.areasTableView registerClass:filterHeaderView.class
     forHeaderFooterViewReuseIdentifier:@"dd"];
        sec.headerHeight=100;
        [sections addObject:sec];
        [self.elementDataSource appendSection:sec];
    }

   }


-(NSArray*)filterTags:(NSString*)key{
    if(key.length==0)
        return self.list;
    NSMutableArray*cities=[NSMutableArray new];
    for (int x=0;x<self.list.count;x++) {
        City*city = [self.list[x] copy];
        
        NSPredicate *predicate =  [NSPredicate predicateWithFormat:@"%K contains[c] %@", @"areaName", key];
        
        
        
        NSArray *filtered = [city.areaInfo filteredArrayUsingPredicate:predicate];
        if (filtered.count>0) {
            city.areaInfo=filtered;
            [cities addObject:city];
        }
    }
    return cities;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.areaSearchBar resignFirstResponder];
}
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar __TVOS_PROHIBITED{
    [self.areaSearchBar resignFirstResponder];
    
    [self close:nil];
}
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar{
    
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    
}


-(void)popButtonClicked:(id)sender event:(id)event{
    filterDelegates*obj=[filterDelegates sharedInstance];
    City*city=(City*)self.filteredList[((UIButton*)sender).tag];
    [obj applyFilterCityName:city];
    
    
    [self dismiss:nil];
    
}


- (IBAction)addCity:(id)sender
{

SCLAlertView *alert = [[SCLAlertView alloc] init];

UITextField *cityIDTextField = [alert addTextField:@"Enter City ID"];
UITextField *cityNameTextField = [alert addTextField:@"Enter City Name"];


[self.latlongDict setValue:nil forKey:@"lat"];
[self.latlongDict setValue:nil forKey:@"lng"];

[self.coordinateDict setValue:self.latlongDict forKey:@"coordinate"];
[self.coordinateDict1 setValue:self.coordinateDict forKey:@"coordinate1"];
[self.latlongArray addObject:self.coordinateDict1];


NSMutableDictionary *areaId1=[[NSMutableDictionary alloc]init];
NSMutableArray *areaId2=[[NSMutableArray alloc]init];

NSMutableDictionary *areaId=[[NSMutableDictionary alloc]init];
[areaId setValue:nil forKey:@"areaID"];
[areaId setValue:nil forKey:@"areaName"];
[areaId setValue:[self.latlongArray valueForKey:@"coordinate1"] forKey:@"polygons"];
[areaId1 setValue:areaId forKey:@"areaInfo"];
[areaId2 addObject:areaId1];





[alert addButton:@"Save" actionBlock:(^{
    filterDelegates*obj=[filterDelegates sharedInstance];

    NSDictionary *messageJSON1;
    self.rootRef=[[FIRDatabase database] referenceFromURL:[NSString stringWithFormat:@"%@/countryCitiesListResponse/%@",@"https://areas-managment.firebaseio.com/",@"cityInfo"]];
    messageJSON1 = @{
                     @"areaInfo":[areaId2 valueForKey:@"areaInfo"],
                     @"cityID":cityIDTextField.text,
                     @"cityName":cityNameTextField.text
                     };
    
    self.rootRef=[self.rootRef child:[NSString stringWithFormat:@"%lu", self.list.count]];
    [self.rootRef setValue:messageJSON1 withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        
    }];
    
    City*city= [[City alloc]init];
    city.cityName=cityNameTextField.text;
    city.cityID=cityIDTextField.text;
    
    [obj applyFilterCityName:city];

    

    [self dismiss:nil];

})];



[alert addButton:@"Cancel" actionBlock:(^{
})];
[alert showEdit:self title:@"Add City" subTitle:nil closeButtonTitle:nil duration:0.0f];

}
@end
