//
//  Created by Sam Deane on 06/11/2012.
//  Copyright 2012 Karelia Software. All rights reserved.
//

#import "BaseCKTests.h"

#import "CK2FileManager.h"

#import <CURLHandle/CURLHandle.h>

@interface FTPAuthenticationTests : BaseCKTests

@end

@implementation FTPAuthenticationTests

- (void)fileManager:(CK2FileManager *)manager didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSString* user;
    NSString* password;

    if (challenge.previousFailureCount > 0)
    {
        user = self.originalUser;
        password = self.originalPassword;

        [self useResponseSet:@"default"];
    }
    else
    {
        user = @"bad";
        password = @"bad";
    }

    NSLog(@"authenticating as %@ %@", self.user, self.password);
    NSURLCredential* credential = [NSURLCredential credentialWithUser:user password:password persistence:NSURLCredentialPersistenceNone];
    [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
}

- (NSString*)protocol
{
    return @"FTP";
}

#pragma mark - Tests

- (void)testBadLoginThenGoodLogin
{
    // the server starts by rejecting the password
    // after the first challenge though, we switch to the "normal" responses so that it accepts it
    if ([self setupTest])
    {
        [self removeTestDirectory];
        [self useResponseSet:@"bad login"];

        NSURL* url = [self URLForTestFolder];
        [self.manager createDirectoryAtURL:url withIntermediateDirectories:YES openingAttributes:nil completionHandler:^(NSError *error) {
            STAssertNil(error, @"got unexpected error %@", error);

            [self pause];
        }];
    }

    [self runUntilPaused];
}

@end