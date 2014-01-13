//
//  Movie.m
//  RottenTomatoes
//
//  Created by Ankit Nitin Shah on 1/13/14.
//  Copyright (c) 2014 yahoo. All rights reserved.
//

#import "Movie.h"

@implementation Movie

-(id) initWithRottenTomatoesData: (NSDictionary*) data{
    self = [super init];
    if (self) {
        
        NSMutableArray* mutableCasts = [[ NSMutableArray alloc ] initWithCapacity: 5];
        for(id casts in [data valueForKey:@"abridged_cast"]){
            [mutableCasts addObject: [casts valueForKey: @"name"]];
        }
        self.abridged_cast = [NSArray arrayWithArray:mutableCasts];
        
        self.postersThumbnail = [[data valueForKey:@"posters"] valueForKey:@"thumbnail"];
        self.title =  [data valueForKey:@"title"];
        self.synopsis = [data valueForKey:@"synopsis"];
        
    }
    return self;
}

@end
