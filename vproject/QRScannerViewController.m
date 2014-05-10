//
//  QRScannerViewController.m
//  vproject
//
//  Created by JungHo Kim on 2014. 5. 7..
//  Copyright (c) 2014년 vproject. All rights reserved.
//

#import "QRScannerViewController.h"

@interface QRScannerViewController ()

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic) BOOL isReading;

-(BOOL)startReading;
-(void)stopReading;

@end

@implementation QRScannerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
//    return UIBarPositionTopAttached;
//}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self startReading];
    
    // Set to the flag the exact opposite value of the one that currently has.
    _isReading = !_isReading;
    self.navigationBar.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private method implementation

- (BOOL)startReading {
    NSError *error;
    
    // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
    // as the media type parameter.
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Get an instance of the AVCaptureDeviceInput class using the previous device object.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        // If any error occurs, simply log the description of it and don't continue any more.
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    // Initialize the captureSession object.
    _captureSession = [[AVCaptureSession alloc] init];
    // Set the input device on the capture session.
    [_captureSession addInput:input];
    
    
    // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    // Create a new serial dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    
    // Start video capture.
    [_captureSession startRunning];
    
    return YES;
}


-(void)stopReading{
    // Stop video capture and make the capture session object nil.
    [_captureSession stopRunning];
    _captureSession = nil;
    
    // Remove the video preview layer from the viewPreview view's layer.
    [_videoPreviewLayer removeFromSuperlayer];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate method implementation

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    // Check if the metadataObjects array is not nil and it contains at least one object.
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        // Get the metadata object.
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            // If the found metadata is equal to the QR code metadata then update the status label's text,
            // stop reading and change the bar button item's title and the flag's value.
            // Everything is done on the main thread.
            //[_lblStatus performSelectorOnMainThread:@selector(setText:) withObject:[metadataObj stringValue] waitUntilDone:NO];
                        
            NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
            NSDictionary *dic = [NSDictionary dictionaryWithObject:[metadataObj stringValue] forKey:@"UID"];
            [notificationCenter postNotificationName:@"sendScannedUID" object:nil userInfo:dic];
            
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            //[_bbitemStart performSelectorOnMainThread:@selector(setTitle:) withObject:@"Start!" waitUntilDone:NO];
            
            _isReading = NO;
            
            // If the audio player is not nil, then play the sound effect.
            if (_audioPlayer) {
                [_audioPlayer play];
            }
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            //[self.navigationController popViewControllerAnimated:NO];
        }
    }
    
    
}

- (IBAction)cancel:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
