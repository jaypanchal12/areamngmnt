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

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define iosMinumumSearchbarBG @"9"




@interface areasViewController () <UITableViewDelegate,UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *areaSearchBar;



@end

@implementation areasViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    //header.headerLabel.backgroundColor=[UIColor lightGrayColor];
    header.textLabel.text=@"";
    header.detailTextLabel.text=@"";
    header.tintColor=[UIColor redColor];
    return header;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    SSSection*requiredSec=(SSSection*)self.elementDataSource.sections[(NSUInteger)indexPath.section];
    NSString*filter=@"";
    NSArray *poly=[[NSArray alloc]init];
    
    filterDelegates*obj=[filterDelegates sharedInstance];
    
        filter=((Area*)requiredSec.items[indexPath.row]).areaName;
        poly=((Area*)requiredSec.items[indexPath.row]).polygons;

        City*city=(City*)self.list[indexPath.section];
    [obj applyFilter:filter andID:city.cityName andPolygon:poly andObject:requiredSec.items[indexPath.row]];
    
    
    [self dismiss:nil];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.0f;
}


-(void)applyFilter{
    filterDelegates*obj=[filterDelegates sharedInstance];
    [obj applyFilter:@"" andID:@"" andPolygon:nil andObject:nil];
}


- (IBAction)close:(id)sender {
    [self applyFilter];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


-(void)viewWillDisappear:(BOOL)animated{
    if(self.list.count==0)
      //  [JNOLoader dismiss];
    [self dismiss:nil];
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
    for (int x=0; x<filteredArray.count;x++ ) {
        SSSection *sec=[SSSection sectionWithItems:((City*)filteredArray[x]).areaInfo header:((City*)filteredArray[x]).cityName  footer:nil identifier:@"asas"];
        [self.areasTableView registerClass:filterHeaderView.class
     forHeaderFooterViewReuseIdentifier:@"dd"];
        sec.headerHeight=100;
        [sections addObject:sec];
        [self.elementDataSource appendSection:sec];
    }
    // self.elementDataSource = [[SSSectionedDataSource alloc] initWithSections:sections];
    
}


-(NSArray*)filterTags:(NSString*)key{
    if(key.length==0)
        return self.list;
    NSMutableArray*cities=[NSMutableArray new];
    for (int x=0;x<self.list.count;x++) {
        City*city = [self.list[x] copy];
      //  NSPredicate *predicate =    [NSPredicate predicateByType:JNOPredicateContains fieldKey:@"areaName" text:key];
        
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




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
