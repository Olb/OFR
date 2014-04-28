//
//  BPBScannerViewController.m
//  Origins
//
//  Created by billy bray on 4/25/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import "BPBScannerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "BPBProductStateViewController.h"

@interface BPBScannerViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIView *directionsLabelView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIView *backgroundCameraView;

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *prevLayer;

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
    _prevLayer.frame = self.backgroundCameraView.frame;
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
    NSString *detectionString = nil;
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
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (detectionString != nil)
        {
            // Found a bar code, stop the session and launch Product State Controller
            [self.session stopRunning];
            BPBProductStateViewController *psvc = [[BPBProductStateViewController alloc] init];
            psvc.barCode = detectionString;
            // Reference to self for pop
            psvc.mvc = self.mvc;
            
            [self.navigationController pushViewController:psvc animated:YES];
            
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

@end
