//
//  EFEntityObjectMapping.m
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-21.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

#import "EFEntityObjectMappings.h"

@interface EFObjectManager()

@property(nonatomic,readwrite) NSString *appKey;

@end

@implementation EFObjectManager

+ (EFObjectManager*)managerWithBaseURL:(NSURL *)baseURL withAppKey:(NSString*)appKey
{
    EFObjectManager *instance = [super managerWithBaseURL:baseURL];
    instance.appKey = appKey;
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/javascript"];
    
    [instance addResponseDescriptor:EFEventEntity.responseDescriptor];
    
    return instance;
}

- (RKObjectRequestOperation *)objectRequestOperationWithRequest:(NSURLRequest *)request
                                                        success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                                                        failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure
{
    RKObjectRequestOperation *op = [super objectRequestOperationWithRequest:request success:success failure:failure];
    op.HTTPRequestOperation.acceptableContentTypes = [NSSet setWithObjects:@"text/javascript",@"text/plain",@"application/json", nil];
    return op;
}

- (NSMutableURLRequest*)requestWithObject:(id)object
    method:(RKRequestMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters
{
    parameters = parameters ? [NSMutableDictionary dictionaryWithDictionary:parameters] :
            [NSMutableDictionary dictionary];
    
    [parameters setValue:self.appKey forKey:@"app_key"];
    return [super requestWithObject:object method:method path:path parameters:parameters];
}

@end

@implementation EFEventEntity (EFObjectEntityProtocol)

+ (RKObjectMapping*)objectMapping
{
    RKObjectMapping *mapping = [[RKObjectMapping alloc] initWithClass:[self class]];

	[mapping addAttributeMappingsFromDictionary:@{
		@"title":	@"title",
        @"start_time" : @"startTime"
	}];
    
    [mapping addPropertyMapping:
           [RKRelationshipMapping relationshipMappingFromKeyPath:@"image" toKeyPath:@"image" withMapping:EFEventImage.objectMapping]
    ];
    
    [mapping addPropertyMapping:
           [RKRelationshipMapping relationshipMappingFromKeyPath:@"image.thumb" toKeyPath:@"thumbImage" withMapping:EFEventImage.objectMapping]
    ];    

    [mapping addPropertyMapping:
           [RKRelationshipMapping relationshipMappingFromKeyPath:@"performers.performer" toKeyPath:@"performer" withMapping:EFPerformerEntity.objectMapping]
    ];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:nil toKeyPath:@"venue" withMapping:EFVenueEntity.objectMapping]];
    
        
	return mapping;
}

+ (RKResponseDescriptor*)responseDescriptor
{
    return [RKResponseDescriptor responseDescriptorWithMapping:self.objectMapping method:RKRequestMethodGET pathPattern:nil keyPath:@"events.event" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}

@end

@implementation EFVenueEntity (EFObjectEntityProtocol)

+ (RKObjectMapping*)objectMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
	[mapping addAttributeMappingsFromDictionary:@{
		@"venue_id":	@"ID",
        @"venue_name" : @"name"
	}];
    return mapping;
}

@end

@implementation EFEventImage (EFObjectEntityProtocol)

+ (RKObjectMapping*)objectMapping
{
     RKObjectMapping *imageMapping = [RKObjectMapping mappingForClass:[self class]];
    [imageMapping addAttributeMappingsFromArray:@[
        @"width", @"height", @"url"
    ]];
    return imageMapping;
}

@end

@implementation EFPerformerEntity(EFObjectEntityProtocol)

+ (RKObjectMapping*)objectMapping
{
    RKObjectMapping *imageMapping = [RKObjectMapping mappingForClass:[self class]];
    [imageMapping addAttributeMappingsFromArray:@[
        @"name"
    ]];
    return imageMapping;
}

@end

@implementation RKPaginator (EFObjectEntityProtocol)

+ (RKObjectMapping*)objectMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RKPaginator class]];
    [mapping addAttributeMappingsFromDictionary:@{
        @"page_size"   : @"perPage",
        @"total_items" : @"objectCount"
    }];
    return mapping;
}

+ (RKResponseDescriptor*)responseDescriptor
{    
   return [RKResponseDescriptor responseDescriptorWithMapping:self.objectMapping method:RKRequestMethodGET pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}

@end