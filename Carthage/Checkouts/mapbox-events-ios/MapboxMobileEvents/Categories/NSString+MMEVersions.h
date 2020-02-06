#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSInteger const MMESemverInvalidVersion;

/// Semantic Version String Validation and Parsing
///
/// https://semver.org
///
@interface NSString (MMEVersions)

/// YES if this string complies with the semver specification
- (BOOL) mme_isSemverString;

// MARK: - Version Core

/// returns the core version component of the semver string, e.g. "0.0.0"
- (NSString *)mme_semverCoreComponent;

/// value is MMESemverInvalidVersion if mme_isSemverString == NO
- (NSInteger)mme_semverMajorVersion;

/// value is MMESemverInvalidVersion if mme_isSemverString == NO
- (NSInteger)mme_semverMinorVersion;

/// value is MMESemverInvalidVersion if mme_isSemverString == NO
- (NSInteger)mme_semverPatchVersion;

@end

NS_ASSUME_NONNULL_END
