//
//  EntityLocationController.m
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 05/09/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//
#import "Logger.h"
#import "Common.h"
#import "DateUtils.h"
#import "Address.h"
#import "Schedule.h"
#import "ImageUtils.h"
#import "EntityLocationController.h"

@implementation EntityLocationController

@synthesize entity = _entity;
@synthesize mapView = _mapView;

- (void)dealloc
{
    [_mapView release];
    [_entity release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    TRC_ENTRY
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;

    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta=0.01;
    span.longitudeDelta=0.01;
    
    Address *address = (Address *) self.entity.address;
    
    CLLocationCoordinate2D location = [self addressLocation:[address addressAsString]];
    region.span=span;
    region.center=location;
    AddressAnnotation *annotation = [[AddressAnnotation alloc] initWithCoordinate:location];
    annotation.title = _entity.name;
    
    if ([_entity.schedule count])
    {
        for (Schedule *schedule in _entity.schedule)
        {
            // check that current week day is in schedule
            if ([DateUtils currentWeekDay:schedule.mon :schedule.tue :schedule.wed :schedule.thu :schedule.fri :schedule.sat :schedule.sun])
            {    
                // check current time is in schedule
                if ([DateUtils currentTimeAfter:schedule.start andBefore:schedule.end])
                {
                    annotation.subtitle = [DateUtils periodAsString:schedule.start :schedule.end];
                    break;
                } 
            }    
        }
    }

    [_mapView setDelegate:self];
    [_mapView addAnnotation:annotation];
    [_mapView setRegion:region animated:TRUE];
    [_mapView regionThatFits:region];

    [annotation release];
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    // show call out annotaion without click on the pin
    [mapView selectAnnotation:[[mapView annotations] lastObject] animated:NO];
}

- (void)viewDidUnload
{
    self.mapView = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (CLLocationCoordinate2D) addressLocation:(NSString *)addressText 
{
    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv", 
                           [addressText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSError *error = nil;
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSASCIIStringEncoding error:&error];
    if (locationString)
    {
        TRC_DBG(@"Location is [%@]", locationString);
    }
    else 
    {
        TRC_ERR(@"Error during creating location [%@]", error);
    }

    NSArray *listItems = [locationString componentsSeparatedByString:@","];
    
    double latitude = 0.0;
    double longitude = 0.0;
    
    if([listItems count] >= 4 && [[listItems objectAtIndex:0] isEqualToString:@"200"]) {
        latitude = [[listItems objectAtIndex:2] doubleValue];
        longitude = [[listItems objectAtIndex:3] doubleValue];
    }
    else 
    {
        //Show error
    }
    CLLocationCoordinate2D location;
    location.latitude = latitude;
    location.longitude = longitude;
    
    return location;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    TRC_ENTRY
    static NSString *ANNOTATION_IDENTIFIER = @"ANNOTATION_IDENTIFIER";
    
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:ANNOTATION_IDENTIFIER];
    if (!annotationView)
    {
        annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ANNOTATION_IDENTIFIER] autorelease];
    }    
    
    annotationView.annotation = annotation;
    annotationView.canShowCallout = YES;
    
    if (_entity.thumbnail)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[ImageUtils image:_entity.thumbnail scaledToSize:CGSizeMake(30, 30)]];
        annotationView.leftCalloutAccessoryView = imageView;
        [imageView release];    
    }
    
    return annotationView;
}

- (IBAction)mapToStandard:(id)sender 
{
    _mapView.mapType = MKMapTypeStandard;
}

- (IBAction)mapToSatellite:(id)sender
{
    _mapView.mapType = MKMapTypeSatellite;
}

- (IBAction)mapToHybrid:(id)sender
{
    _mapView.mapType = MKMapTypeHybrid;
}

@end

@implementation AddressAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

- (id)initWithCoordinate:(CLLocationCoordinate2D) c
{
    coordinate=c;
    return self;
}

- (void)dealloc
{
    [title release];
    [subtitle release];
    [super dealloc];
}
@end

