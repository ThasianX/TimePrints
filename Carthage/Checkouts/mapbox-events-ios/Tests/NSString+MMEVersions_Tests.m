#import <XCTest/XCTest.h>

#import "MMEBundleInfoFake.h"

#import "NSString+MMEVersions.h"
#import "NSUserDefaults+MMEConfiguration_Private.h"

@interface NSString_MMEVersions : XCTestCase

@end

// MARK: -

/// https://regex101.com/r/vkijKf/1/

@implementation NSString_MMEVersions

/// Valid Semantic Versions
- (void)test001_positiveTests {
  XCTAssertTrue([@"0.0.4" mme_isSemverString]);
  XCTAssertTrue([@"1.2.3" mme_isSemverString]);
  XCTAssertTrue([@"10.20.30" mme_isSemverString]);
  XCTAssertTrue([@"1.1.2-prerelease+meta" mme_isSemverString]);
  XCTAssertTrue([@"1.1.2+meta" mme_isSemverString]);
  XCTAssertTrue([@"1.1.2+meta-valid" mme_isSemverString]);
  XCTAssertTrue([@"1.0.0-alpha" mme_isSemverString]);
  XCTAssertTrue([@"1.0.0-beta" mme_isSemverString]);
  XCTAssertTrue([@"1.0.0-alpha.beta" mme_isSemverString]);
  XCTAssertTrue([@"1.0.0-alpha.beta.1" mme_isSemverString]);
  XCTAssertTrue([@"1.0.0-alpha.1" mme_isSemverString]);
  XCTAssertTrue([@"1.0.0-alpha0.valid" mme_isSemverString]);
  XCTAssertTrue([@"1.0.0-alpha.0valid" mme_isSemverString]);
  XCTAssertTrue([@"1.0.0-alpha-a.b-c-somethinglong+build.1-aef.1-its-okay" mme_isSemverString]);
  XCTAssertTrue([@"1.0.0-rc.1+build.1" mme_isSemverString]);
  XCTAssertTrue([@"2.0.0-rc.1+build.123" mme_isSemverString]);
  XCTAssertTrue([@"1.2.3-beta" mme_isSemverString]);
  XCTAssertTrue([@"10.2.3-DEV-SNAPSHOT" mme_isSemverString]);
  XCTAssertTrue([@"1.2.3-SNAPSHOT-123" mme_isSemverString]);
  XCTAssertTrue([@"1.0.0" mme_isSemverString]);
  XCTAssertTrue([@"2.0.0" mme_isSemverString]);
  XCTAssertTrue([@"1.1.7" mme_isSemverString]);
  XCTAssertTrue([@"2.0.0+build.1848" mme_isSemverString]);
  XCTAssertTrue([@"2.0.1-alpha.1227" mme_isSemverString]);
  XCTAssertTrue([@"1.0.0-alpha+beta" mme_isSemverString]);
  XCTAssertTrue([@"1.2.3----RC-SNAPSHOT.12.9.1--.12+788" mme_isSemverString]);
  XCTAssertTrue([@"1.2.3----R-S.12.9.1--.12+meta" mme_isSemverString]);
  XCTAssertTrue([@"1.2.3----RC-SNAPSHOT.12.9.1--.12" mme_isSemverString]);
  XCTAssertTrue([@"1.0.0+0.build.1-rc.10000aaa-kk-0.1" mme_isSemverString]);
  XCTAssertTrue([@"99999999999999999999999.999999999999999999.99999999999999999" mme_isSemverString]);
  XCTAssertTrue([@"1.0.0-0A.is.legal" mme_isSemverString]);
}

// Invalid Semantic Versions
- (void)test001_negativeTests {
    XCTAssertFalse([@"1" mme_isSemverString]);
    XCTAssertFalse([@"1.2" mme_isSemverString]);
    XCTAssertFalse([@"1.2.3-0123" mme_isSemverString]);
    XCTAssertFalse([@"1.2.3-0123.0123" mme_isSemverString]);
    XCTAssertFalse([@"1.1.2+.123" mme_isSemverString]);
    XCTAssertFalse([@"+invalid" mme_isSemverString]);
    XCTAssertFalse([@"-invalid" mme_isSemverString]);
    XCTAssertFalse([@"-invalid+invalid" mme_isSemverString]);
    XCTAssertFalse([@"-invalid.01" mme_isSemverString]);
    XCTAssertFalse([@"alpha" mme_isSemverString]);
    XCTAssertFalse([@"alpha.beta" mme_isSemverString]);
    XCTAssertFalse([@"alpha.beta.1" mme_isSemverString]);
    XCTAssertFalse([@"alpha.1" mme_isSemverString]);
    XCTAssertFalse([@"alpha+beta" mme_isSemverString]);
    XCTAssertFalse([@"alpha_beta" mme_isSemverString]);
    XCTAssertFalse([@"alpha." mme_isSemverString]);
    XCTAssertFalse([@"alpha.." mme_isSemverString]);
    XCTAssertFalse([@"beta" mme_isSemverString]);
    XCTAssertFalse([@"1.0.0-alpha_beta" mme_isSemverString]);
    XCTAssertFalse([@"-alpha." mme_isSemverString]);
    XCTAssertFalse([@"1.0.0-alpha.." mme_isSemverString]);
    XCTAssertFalse([@"1.0.0-alpha..1" mme_isSemverString]);
    XCTAssertFalse([@"1.0.0-alpha...1" mme_isSemverString]);
    XCTAssertFalse([@"1.0.0-alpha....1" mme_isSemverString]);
    XCTAssertFalse([@"1.0.0-alpha.....1" mme_isSemverString]);
    XCTAssertFalse([@"1.0.0-alpha......1" mme_isSemverString]);
    XCTAssertFalse([@"1.0.0-alpha.......1" mme_isSemverString]);
    XCTAssertFalse([@"01.1.1" mme_isSemverString]);
    XCTAssertFalse([@"1.01.1" mme_isSemverString]);
    XCTAssertFalse([@"1.1.01" mme_isSemverString]);
    XCTAssertFalse([@"1.2" mme_isSemverString]);
    XCTAssertFalse([@"1.2.3.DEV" mme_isSemverString]);
    XCTAssertFalse([@"1.2-SNAPSHOT" mme_isSemverString]);
    XCTAssertFalse([@"1.2.31.2.3----RC-SNAPSHOT.12.09.1--..12+788" mme_isSemverString]);
    XCTAssertFalse([@"1.2-RC-SNAPSHOT" mme_isSemverString]);
    XCTAssertFalse([@"-1.0.3-gamma+b7718" mme_isSemverString]);
    XCTAssertFalse([@"+justmeta" mme_isSemverString]);
    XCTAssertFalse([@"9.8.7+meta+meta" mme_isSemverString]);
    XCTAssertFalse([@"9.8.7-whatever+meta+meta" mme_isSemverString]);
    XCTAssertFalse([@"99999999999999999999999.999999999999999999.99999999999999999----RC-SNAPSHOT.12.09.1--------------------------------..12" mme_isSemverString]);
}

- (void)test003_coreComponent {
    XCTAssertTrue([[@"1.1.2-prerelease+meta" mme_semverCoreComponent] isEqualToString:@"1.1.2"]);
    XCTAssertTrue([[@"1.1.2+meta" mme_semverCoreComponent] isEqualToString:@"1.1.2"]);
    XCTAssertTrue([[@"1.1.2+meta-valid" mme_semverCoreComponent] isEqualToString:@"1.1.2"]);
}

- (void)test004_majorVersion {
    XCTAssertTrue([@"1.2.3" mme_semverMajorVersion] == 1);
}

- (void)test005_minorVersion {
    XCTAssertTrue([@"1.2.3" mme_semverMinorVersion] == 2);
}

- (void)test006_patchVersion {
    XCTAssertTrue([@"1.2.3" mme_semverPatchVersion] == 3);
}

- (void)test007_bundleVersionString {
    NSBundle *fakeBundle = [MMEBundleInfoFake bundleWithFakeInfo:@{@"CFBundleShortVersionString": @"1.2.3"}];
    XCTAssertTrue([fakeBundle.mme_bundleVersionString mme_isSemverString]);
}

- (void)test008_invalidBundleVersionString {
    NSBundle *fakeBundle = [MMEBundleInfoFake bundleWithFakeInfo:@{@"CFBundleShortVersionString": @"1.2.3.4"}];
    XCTAssertFalse([fakeBundle.mme_bundleVersionString mme_isSemverString]);
}

- (void)test009_bundleSemanticVersionString {
    NSBundle *fakeBundle = [MMEBundleInfoFake bundleWithFakeInfo:@{@"MGLSemanticVersionString": @"1.2.3"}];
    XCTAssertTrue([fakeBundle.mme_bundleVersionString mme_isSemverString]);
}

- (void)test010_invalidSementicBundleVersionString {
    NSBundle *fakeBundle = [MMEBundleInfoFake bundleWithFakeInfo:@{@"MGLSemanticVersionString": @"1.2.3.4"}];
    XCTAssertFalse([fakeBundle.mme_bundleVersionString mme_isSemverString]);
}

@end
