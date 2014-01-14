//
//  Movie.h
//  RottenTomatoes
//
//  Created by Ankit Nitin Shah on 1/13/14.
//  Copyright (c) 2014 yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property (strong, nonatomic) NSArray *abridged_cast;
@property (strong, nonatomic) NSString *postersThumbnail;
@property (strong, nonatomic) NSString *synopsis;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSData *thumbnailData;
@property (strong, nonatomic) NSString *originalImage;
@property (strong, nonatomic) NSString *mpaaRating;
@property (strong, nonatomic) NSString *runtime;
@property (strong, nonatomic) NSString *theaterReleaseDate;
@property (strong, nonatomic) NSString *audienceScore;

-(id) initWithRottenTomatoesData: (NSDictionary*) data;

@end
