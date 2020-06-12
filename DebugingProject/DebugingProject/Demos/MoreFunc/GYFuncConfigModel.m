//
//  GYFunctionModel.m
//
//
//  Created by ShenYj on 2020/3/12.
//  Copyright © 2020 ShenYj. All rights reserved.
//

#import "GYFuncConfigModel.h"

#pragma mark -

@implementation GYFuncConfigModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
        @"selectedFuncIDs" : @[@"default", @"selectedFuncIDs"],
        @"groupData": @[@"data", @"groupData"]
    };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"groupData" : [GYFunctionGroupModel class],
    };
}

@end


#pragma mark -

@implementation GYFunctionGroupModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
        @"groupID" : @[@"groupId", @"groupID"],
        @"funcData": @[@"groupData", @"funcData"]
    };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"funcData" : [GYFunctionModel class],
    };
}

@end



#pragma mark -

@implementation GYFunctionModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
        @"functionID" : @[@"functionId", @"functionID"],
        @"functionIcon": @[@"icon", @"functionIcon"]
    };
}


@end
