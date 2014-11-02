//
//  Utilities.h
//  BU Transit Redux
//
//  Created by Ross Tang Him on 11/2/14.
//
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject

+(NSString *) minutesMapFromArrivalEstimate: (NSDictionary *) arrivalEstimate;
+(NSString *) minutesFromArrivalEstimate: (NSDictionary *) arrivalEstimate;

@end
