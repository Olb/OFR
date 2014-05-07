//
//  BPBScannerViewController.m
//  Origins
//
//  Created by billy bray on 4/25/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import "BPBScannerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "BPBGoodStateViewController.h"
#import "BPBHarmfulStateViewController.h"
#import "BPBUnknownStateViewController.h"
#import "BPBProductStateViewController.h"
#import "BPBDataFetch.h"
#import "BPBConstants.h"
#import <MapKit/MapKit.h>

#define HARMFUL_TEST_BARCODE 9780321942050
#define GOOD_TEST_BARCODE 9781449342753
#define UNKNOWN_TEST_BARCODE 9780321942051

@interface BPBScannerViewController () <AVCaptureMetadataOutputObjectsDelegate, BPBDataFetchDelegate>

@property (weak, nonatomic) IBOutlet UIView *directionsLabelView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIView *backgroundCameraView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (strong, nonatomic) NSString *storeName;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *prevLayer;
@property (nonatomic, copy) NSString *detectionString;
@property (nonatomic) CLLocationCoordinate2D storeLocation;

@end

@implementation BPBScannerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Enable swipe to get out
    // Swipe up gesture for Snapshot
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(returnSwipeRight:)];
    swipeRight.numberOfTouchesRequired = 1;
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.backgroundCameraView addGestureRecognizer:swipeRight];
    
    // Setup delegate as self for getting store name
    BPBDataFetch *df = [BPBDataFetch sharedFetcher];
    df.delegate = self;
    // Get store name - will set Store label when complete
    [df getStoreName];
    
    // Edge on directions label view
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path,NULL,0.0,0.0);
    CGPathAddLineToPoint(path, NULL, self.directionsLabelView.bounds.size.width/2-10, 0.0f);
    CGPathAddLineToPoint(path, NULL, self.directionsLabelView.bounds.size.width/2, -10.0f);
    CGPathAddLineToPoint(path, NULL, self.directionsLabelView.bounds.size.width/2+10, 0.0f);
    CGPathAddLineToPoint(path, NULL, self.directionsLabelView.bounds.size.width/2-10, 0.0f);
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setPath:path];
    [shapeLayer setFillColor:[[UIColor colorWithWhite:1.0f alpha:1.0f] CGColor]];
    [shapeLayer setAnchorPoint:CGPointMake(0.0f, 0.0f)];
    [shapeLayer setPosition:CGPointMake(0.0f, 0.0f)];
    [[self.directionsLabelView layer] addSublayer:shapeLayer];
    
    CGPathRelease(path);
    
    // Get a session for scanner
    _session = [[AVCaptureSession alloc] init];
    // Set device for video
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    // Get input device
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_input) {
        [_session addInput:_input];
    } else {
        NSLog(@"Error: %@", error);
    }
    // Get output for metadata
    _output = [[AVCaptureMetadataOutput alloc] init];
    // Set output delegate
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    // Add output to session
    [_session addOutput:_output];
    // We want all possible metadata types
    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
    // Set the layer for the scanner
    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _prevLayer.frame = self.backgroundCameraView.bounds;
    // Preserve aspect ration and fill layers bounds
    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.backgroundCameraView.layer addSublayer:_prevLayer];
    
    [_session startRunning];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Get the captured output and launch Product State Controller once capture successfull
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    self.detectionString = nil;
    // Check for multiple barcode types
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
    // See which barcode it is
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                self.detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (self.detectionString != nil)
        {
            // Found a bar code, stop the session and launch Product State Controller
            [self.session stopRunning];
            BPBDataFetch *df = [BPBDataFetch sharedFetcher];
            [df fetchProductInfo:self.detectionString];
            
            break;
        }
//        else
//            _label.text = @"(none)";
    }
    
    //self.backgroundCameraView.frame = highlightViewRect;
    
    
   // self.backgroundCameraView
}

-(void)returnSwipeRight:(UIGestureRecognizer*)g
{
    [self.navigationController popToViewController:self.mvc animated:YES];

}

#pragma mark - BPBDataFetch Delegate methods
// Delegate method to set store name;
- (void)setStoreName:(NSString*)storeName
{
    self.storeNameLabel.text = storeName;
}

-(void)setProductImpact:(NSInteger)impact withName:(NSString*)name withImage:(UIImage*)image withDescription:(NSString*)description
{
    BPBProductStateViewController *psvc;
    if (impact == GoodImpact) {
        psvc = [[BPBGoodStateViewController alloc] init];
    } else if (impact == HarmfulImpact) {
        psvc = [[BPBHarmfulStateViewController alloc] init];
    } else {
        psvc = [[BPBUnknownStateViewController alloc] init];
    }
    
    // Reference to main view controller for pop and method calls
    psvc.mvc = self.mvc;
    psvc.storeName = self.storeNameLabel.text;
    psvc.productImage = image;
    psvc.productDescription = description;
    psvc.impact = impact;
    psvc.productName = name;
    psvc.productBarcode = self.detectionString;
    psvc.storeLocation = self.storeLocation;
    
    [self.navigationController pushViewController:psvc animated:YES];

}

-(void)setStoreLocation:(CLLocationCoordinate2D)coord
{
    self.storeLocation = coord;
}

- (IBAction)addBadProduct:(id)sender
{
    self.storeNameLabel.text = @"Home Depot";
    self.detectionString = @"9780321942050";
    [self setProductImpact:HarmfulImpact
                  withName:@"Office Tools"
                 withImage:[UIImage imageNamed:@"office_tools.png"]
           withDescription:@"These tools are known to be harmful to the environment"];
}

- (IBAction)addGoodProduct:(id)sender
{
    self.storeNameLabel.text = @"Joe's Mill";
    self.detectionString = @"9781449342753";
    [self setProductImpact:GoodImpact
                  withName:@"Handcrafted Chair"
                 withImage:[UIImage imageNamed:@"chair.png"]
           withDescription:@"This chair has been manufactured in a manner known to be friendly towards the environment"];
}

- (IBAction)addUnknownProduct:(id)sender {
    self.storeNameLabel.text = @"Walmart";
    self.detectionString = @"9780321942051";
    [self setProductImpact:UnknownImpact
                  withName:@"Wallet"
                 withImage:[UIImage imageNamed:@"wallet.png"]
           withDescription:@"Tweet at the retailer to request Origin Made, sustainable alternatives"];
}

@end
