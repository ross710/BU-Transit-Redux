//
//  Utilities.m
//  BU Transit Redux
//
//  Created by Ross Tang Him on 11/2/14.
//
//

#import "Utilities.h"

@implementation Utilities

+(NSString *) minutesMapFromArrivalEstimate: (NSDictionary *) arrivalEstimate {
    if (arrivalEstimate) {
        NSArray *arrivals = [arrivalEstimate objectForKey:@"arrivals"];
        
        //Time
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
        
        
        NSString *retString = @"";
        for (NSDictionary *arrivalDict in arrivals) {
            NSDate *arrivalAt = [dateFormat dateFromString:[arrivalDict objectForKey:@"arrival_at"]];
            
            retString = [NSString stringWithFormat:@"%@, %@ min",retString, [self minutesBetweenTwoDates:[NSDate date] :arrivalAt]];
        }
        
        
        
        return [retString substringFromIndex:2];
        
    } else {
        return @"--";
    }
}

+(NSString *) minutesFromArrivalEstimate: (NSDictionary *) arrivalEstimate {
    if (arrivalEstimate) {
        NSArray *arrivals = [arrivalEstimate objectForKey:@"arrivals"];
        
        //Time
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
        
        
        NSString *retString = @"";
        for (NSDictionary *arrivalDict in arrivals) {
            NSDate *arrivalAt = [dateFormat dateFromString:[arrivalDict objectForKey:@"arrival_at"]];
            
            retString = [NSString stringWithFormat:@"%@, %@",retString, [self minutesBetweenTwoDates:[NSDate date] :arrivalAt]];
        }
        
        
        
        return [retString substringFromIndex:2];

    } else {
        return @"--";
    }
}


#pragma mark - diff between two dates
+(NSString *) minutesBetweenTwoDates: (NSDate *) date1 :(NSDate *) date2 {
    unsigned int unitFlags = NSMinuteCalendarUnit;
    
    NSCalendar *currCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *conversionInfo = [currCalendar components:unitFlags fromDate:date1 toDate:date2  options:0];
    
    NSInteger numMin = [conversionInfo minute];
    if (numMin < -10) {
        return @"???";
    }
    return [NSString stringWithFormat:@"%ld", (long)[conversionInfo minute]];
}
@end