//
//  areasViewController.h
//  firDemo
//
//  Created by KWTMAC01 on 8/2/17.
//  Copyright © 2017 KWTMAC01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SSDataSources/SSDataSources.h>


@interface areasViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *areasTableView;
@property (nonatomic, strong) SSSectionedDataSource *elementDataSource;


@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, strong) NSMutableArray *filteredList;
- (IBAction)addCity:(id)sender;


@end
