//
//  AldJSONSerializable.h
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 27/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AldJSONSerializable <NSObject>

-(id)             initFromSerialization: (NSDictionary *)jsonData;
-(NSDictionary *) serialize;

@end
