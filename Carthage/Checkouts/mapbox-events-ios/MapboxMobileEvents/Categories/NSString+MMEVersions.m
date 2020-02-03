#import "NSString+MMEVersions.h"

static NSString * const MMESemverRegex = @"^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?$";

NSInteger const MMESemverInvalidVersion = -1;

typedef enum {
    MMESemverMatchIndex = 0,
    MMESemverMajorIndex = 1,
    MMESemverMinorIndex = 2,
    MMESemverPatchIndex = 3,
    MMESemverBuildIndex = 4,
    MMESemverReleaseIndex = 5
} MMESemverRegexIndicies;

// MARK: -

/// These need tests before being made public
@interface NSString (MMEVersion_Private)

// MARK: - Pre-Release Identifiers

/// YES if the string contains a pre-release version component
- (BOOL) mme_containsPreReleaseComponent;

/// returns the pre-release component of the semver string
- (NSString *)mme_semverPreReleaseComponent;

/// Array of dot-seperated pre-release version components
- (NSArray<NSString *>*)mme_semverPreReleaseIdentifiers;

// MARK: - Build Identifiers

/// YES if the string contains a build string precded with a `+` character
- (BOOL) mme_containsBuildStringComponent;

/// returns the build componet of the semver string
- (NSString *)mme_semverBuildStringComponent;

/// Array of dot-seperated build identifer components
- (NSArray<NSString *>*)mme_semverBuildIdentifiers;

@end

// MARK: -

@implementation NSString (MMEVersions)

+ (NSRegularExpression *)mme_semverExpression {
    static NSRegularExpression *semverExpression = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSError *expressionError = nil;
        semverExpression = [NSRegularExpression regularExpressionWithPattern:MMESemverRegex options:0 error:&expressionError];
        if (!semverExpression && expressionError) {
            NSLog(@"ERROR invalid regex pattern: %@", expressionError);
        }
    });
    return semverExpression;
}

- (BOOL) mme_isSemverString {
    NSTextCheckingResult *regexMatch = [NSString.mme_semverExpression firstMatchInString:self options:0 range:NSMakeRange(0,self.length)];
    return (regexMatch && regexMatch.range.location == MMESemverMatchIndex); // the first match MUST be the first character
}

// MARK: - Version Core

- (NSString *)mme_semverCoreComponent {
    NSString *coreComponent = nil;
    NSTextCheckingResult *regexMatch = [NSString.mme_semverExpression firstMatchInString:self options:0 range:NSMakeRange(0,self.length)];
    if (regexMatch && regexMatch.numberOfRanges >= MMESemverPatchIndex) {
        coreComponent = [@[
            [self substringWithRange:[regexMatch rangeAtIndex:MMESemverMajorIndex]],
            [self substringWithRange:[regexMatch rangeAtIndex:MMESemverMinorIndex]],
            [self substringWithRange:[regexMatch rangeAtIndex:MMESemverPatchIndex]]
        ] componentsJoinedByString:@"."];
    }
    return coreComponent;
}

- (NSInteger)mme_semverMajorVersion {
    NSInteger majorVersion = MMESemverInvalidVersion;
    NSTextCheckingResult *regexMatch = [NSString.mme_semverExpression firstMatchInString:self options:0 range:NSMakeRange(0,self.length)];
    if (regexMatch && regexMatch.numberOfRanges >= MMESemverPatchIndex) {
        majorVersion = [[self substringWithRange:[regexMatch rangeAtIndex:1]] integerValue];
    }
    return majorVersion;
}

- (NSInteger)mme_semverMinorVersion {
    NSInteger minorVersion = MMESemverInvalidVersion;
    NSTextCheckingResult *regexMatch = [NSString.mme_semverExpression firstMatchInString:self options:0 range:NSMakeRange(0,self.length)];
    if (regexMatch && regexMatch.numberOfRanges >= MMESemverPatchIndex) {
        minorVersion = [[self substringWithRange:[regexMatch rangeAtIndex:MMESemverMinorIndex]] integerValue];
    }
    return minorVersion;
}

- (NSInteger)mme_semverPatchVersion {
    NSInteger patchVersion = MMESemverInvalidVersion;
    NSTextCheckingResult *regexMatch = [NSString.mme_semverExpression firstMatchInString:self options:0 range:NSMakeRange(0,self.length)];
    if (regexMatch && regexMatch.numberOfRanges >= MMESemverPatchIndex) {
        patchVersion = [[self substringWithRange:[regexMatch rangeAtIndex:MMESemverPatchIndex]] integerValue];
    }
    return patchVersion;
}

// MARK: - Build Identifiers

- (BOOL) mme_containsBuildStringComponent {
    NSTextCheckingResult *regexMatch = [NSString.mme_semverExpression firstMatchInString:self options:0 range:NSMakeRange(0,self.length)];
    return (regexMatch && regexMatch.numberOfRanges >= MMESemverBuildIndex);
}

- (NSString *)mme_semverBuildStringComponent {
    NSString *buildString = nil;
    NSTextCheckingResult *regexMatch = [NSString.mme_semverExpression firstMatchInString:self options:0 range:NSMakeRange(0,self.length)];
    if (regexMatch && regexMatch.numberOfRanges >= MMESemverBuildIndex) {
        buildString = [self substringWithRange:[regexMatch rangeAtIndex:MMESemverBuildIndex]];
    }
    return buildString;
}

- (NSArray<NSString *>*)mme_semverBuildIdentifiers {
    return [[self mme_semverBuildStringComponent] componentsSeparatedByString:@"."];
}

// MARK: - Pre-Release Identifiers

- (BOOL) mme_containsPreReleaseComponent {
    NSTextCheckingResult *regexMatch = [NSString.mme_semverExpression firstMatchInString:self options:0 range:NSMakeRange(0,self.length)];
    return (regexMatch && regexMatch.numberOfRanges >= MMESemverReleaseIndex);
}

- (NSString *)mme_semverPreReleaseComponent {
    NSString *buildString = nil;
    NSTextCheckingResult *regexMatch = [NSString.mme_semverExpression firstMatchInString:self options:0 range:NSMakeRange(0,self.length)];
    if (regexMatch && regexMatch.numberOfRanges >= MMESemverReleaseIndex) {
        buildString = [self substringWithRange:[regexMatch rangeAtIndex:MMESemverReleaseIndex]];
    }
    return buildString;
}

- (NSArray<NSString *>*)mme_semverPreReleaseIdentifiers {
    return [[self mme_semverPreReleaseComponent] componentsSeparatedByString:@"."];
}

@end
