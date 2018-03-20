//
//  ScanViewController.m
//  Barcode
//
//  Created by Paolo Carollo on 20/03/2018.
//  Copyright © 2018 Paolo Carollo. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "ScanViewController.h"
#import "BarcodeDetailTableViewController.h"

@interface ScanViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UILabel *permissionLabel;
@property (weak, nonatomic) IBOutlet UIView *cameraView;

@property (strong, nonnull) AVCaptureVideoPreviewLayer* captureVideoPreviewLayer;
@property (strong, nonnull) AVCaptureSession *captureSession;
@property (strong, nonnull) dispatch_queue_t sessionQueue;

@property (strong, nonatomic) NSString *barcode;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  Set permission label hidden
    _permissionLabel.hidden = YES;
    
    __weak typeof(self) weakSelf = self;
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf handlePermissionFor:granted];
        });
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    if (self.captureSession && !self.captureSession.isRunning) {
        dispatch_async(_sessionQueue, ^{
            [self.captureSession startRunning];
        });
    }

}

- (void)viewWillDisappear:(BOOL)animated {
    
    dispatch_async(_sessionQueue, ^{
        if (self.captureSession.isRunning) {
            [self.captureSession stopRunning];
        }
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[BarcodeDetailTableViewController class]]) {
        BarcodeDetailTableViewController *viewController = (BarcodeDetailTableViewController *)segue.destinationViewController;
        viewController.barcode = self.barcode;
    }
}


# pragma mark: - handlers

- (void)handlePermissionFor:(BOOL)granted {
    
    if (!granted) {
        _permissionLabel.hidden = NO;
        return;
    }
    
    [self setup];
}

- (void)setup {
    
    AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
    
    [captureSession beginConfiguration];
    
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    if (videoInput) {
        [captureSession addInput:videoInput];
    }

    dispatch_queue_t sessionQueue = dispatch_queue_create("com.barcode.capturesession.queue", nil);
    AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    if (metadataOutput) {
        [captureSession addOutput:metadataOutput];
        [metadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code]];
        [metadataOutput setMetadataObjectsDelegate:self queue:sessionQueue];
    }

    _sessionQueue = sessionQueue;

    [captureSession commitConfiguration];
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    captureVideoPreviewLayer.frame = self.cameraView.bounds;
    [self.cameraView.layer addSublayer:captureVideoPreviewLayer];

    
    self.captureVideoPreviewLayer = captureVideoPreviewLayer;
    self.captureSession = captureSession;
    
    dispatch_async(_sessionQueue, ^{
        [self.captureSession startRunning];
    });
    
}

#pragma mark - delegate

- (void)captureOutput:(AVCaptureOutput *)output
didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection {
    
    if (metadataObjects.count > 0 && [metadataObjects.firstObject isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
        
        AVMetadataMachineReadableCodeObject *scan = metadataObjects.firstObject;
        NSString *barcode = scan.stringValue;
        if (barcode && barcode.length > 0) {
            
            dispatch_async(_sessionQueue, ^{
                [self.captureSession stopRunning];
            });
            
            self.barcode = barcode;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"barcodeDetailSegue" sender:nil];
            });
            
        }
    }
    
}

@end
