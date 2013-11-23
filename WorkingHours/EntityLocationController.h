//
//  EntityLocationController.h
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 05/09/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Entity.h"

@interface EntityLocationController : UIViewController <MKMapViewDelegate>

@property (nonatomic, retain) Entity *entity;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;

- (CLLocationCoordinate2D) addressLocation:(NSString *)addressText;

- (IBAction)mapToStandard:(id)sender;
- (IBAction)mapToSatellite:(id)sender;
- (IBAction)mapToHybrid:(id)sender;

@end

@interface AddressAnnotation : NSObject<MKAnnotation> {
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;

- (id)initWithCoordinate:(CLLocationCoordinate2D) c;

@end



