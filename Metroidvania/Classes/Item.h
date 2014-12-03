//
//  Item.h
//  Metroidvania
//
//  Created by Ryan Macey on 10/22/14.
//  Copyright (c) 2014 Ryan Macey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property(nonatomic,assign)NSString *name;
@property(nonatomic,assign)NSString *description;
@property(nonatomic,assign)int value;

@end
