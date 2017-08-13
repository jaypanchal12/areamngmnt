//
//  filterHeaderView.h
//  firDemo
//
//  Created by KWTMAC01 on 8/2/17.
//  Copyright © 2017 KWTMAC01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SSDataSources/SSDataSources.h>


@interface filterHeaderView : SSBaseHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIButton *addCityBtn;


@end
