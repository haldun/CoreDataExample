//
//  MNDRecordingViewController.m
//  CoreDataExample
//
//  Created by Haldun Bayhantopcu on 18/10/13.
//  Copyright (c) 2013 Monoid. All rights reserved.
//

#import "MNDRecordingViewController.h"
#import "MNDRecording.h"
#import "MNDDataModel.h"


@interface MNDRecordingViewController () <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate>

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (nonatomic) NSURLSession *session;
@property (nonatomic) NSURLSessionDownloadTask *downloadTask;

@end


@implementation MNDRecordingViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  NSInteger recordingIdentifier = 1;
  
  // Fetch recording data from core data
  NSManagedObjectContext *managedObjectContext = [[MNDDataModel sharedDataModel] managedObjectContext];
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Recording"];
  fetchRequest.predicate = [NSPredicate predicateWithFormat:@"identifier == %d", recordingIdentifier];
  NSError *error;
  NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
  
  if (results) {
    MNDRecording *recording = [results firstObject];
    if (recording) {
      self.title = recording.title;
    }
  } else {
    // TODO Deal with error
  }
}

- (IBAction)startDownload:(id)sender
{
  if (self.downloadTask) {
    return;
  }

  self.session = [self backgroundSession];
  self.progressView.progress = 0;
  
  NSURL *downloadURL = [NSURL URLWithString:@"http://asset.powerfm.com.tr/CenkErdem/podcast/CENKERDEM15102013.mp3"];
  NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL];
  self.downloadTask = [self.session downloadTaskWithRequest:request];
  [self.downloadTask resume];
}

- (NSURLSession *)backgroundSession
{
  static NSURLSession *session = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfiguration:@"coredataexample"];
    session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
  });
  return session;
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
  if (downloadTask == self.downloadTask) {
    double progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(), ^{
      self.progressView.progress = progress;
    });
  }
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)downloadURL
{
  NSLog(@"Download finished");
  
  // Copy the file to the Documents directory and update recording
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSArray *urls = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
  NSURL *documentsDirectory = [urls firstObject];
  NSURL *originalURL = [[downloadTask originalRequest] URL];
  NSURL *destinationURL = [documentsDirectory URLByAppendingPathComponent:[originalURL lastPathComponent]];
  
  NSLog(@"original url: %@", originalURL);
  NSLog(@"destination url: %@", destinationURL);
  
  NSError *error;
  
  [fileManager removeItemAtURL:destinationURL error:nil];
  BOOL success = [fileManager copyItemAtURL:downloadURL toURL:destinationURL error:&error];
  
  if (success) {
    dispatch_async(dispatch_get_main_queue(), ^{
      self.progressView.hidden = YES;
    });
  } else {
    NSLog(@"error during copy: %@", error.localizedDescription);
  }
}

@end
