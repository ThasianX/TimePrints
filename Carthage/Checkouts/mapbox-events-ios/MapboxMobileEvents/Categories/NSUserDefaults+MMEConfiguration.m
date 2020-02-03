#import <CommonCrypto/CommonDigest.h>

#import "MMEConstants.h"
#import "MMEDate.h"

#import "NSString+MMEVersions.h"
#import "NSUserDefaults+MMEConfiguration.h"
#import "NSUserDefaults+MMEConfiguration_Private.h"

NS_ASSUME_NONNULL_BEGIN

// MARK: -

@implementation NSUserDefaults (MME)

+ (instancetype)mme_configuration {
    static NSUserDefaults *eventsConfiguration = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        eventsConfiguration = [NSUserDefaults.alloc initWithSuiteName:MMEConfigurationDomain];
        [eventsConfiguration mme_registerDefaults];
    });

    return eventsConfiguration;
}

+ (void)mme_resetConfiguration {
    [NSUserDefaults.mme_configuration setPersistentDomain:@{} forName:MMEConfigurationDomain];
    [NSUserDefaults.mme_configuration setVolatileDomain:@{} forName:MMEConfigurationVolatileDomain];
}

// MARK: - Register Defaults

/// check for Info.plist keys which change various default configuration values
- (void)mme_registerDefaults {
    CLLocationDistance backgroundGeofence = MMEBackgroundGeofenceDefault;
    NSTimeInterval startupDelay = MMEStartupDelayDefault;
    BOOL collectionEnabledInSimulator = NO;
    
    NSString *profileName = (NSString*)[NSBundle.mme_mainBundle objectForInfoDictionaryKey:MMEEventsProfile];
    if ([profileName isEqualToString:MMECustomProfile]) {
        id customRadiusNumber = [NSBundle.mme_mainBundle objectForInfoDictionaryKey:MMECustomGeofenceRadius];
        if ([customRadiusNumber isKindOfClass:NSNumber.class]) {
            CLLocationDistance infoGeofence = [customRadiusNumber doubleValue];
            
            if (infoGeofence >= MMECustomGeofenceRadiusMinimum
             && infoGeofence <= MMECustomGeofenceRadiusMaximum) {
                backgroundGeofence = infoGeofence;
            }
            else NSLog(@"WARNING Mapbox Mobile Events Profile has invalid geofence radius: %@", customRadiusNumber);
        }
        else NSLog(@"WARNING Mapbox Mobile Events Profile has invalid geofence: %@", customRadiusNumber);

        id startupDelayNumber = [NSBundle.mme_mainBundle objectForInfoDictionaryKey:MMEStartupDelay];
        if ([startupDelayNumber isKindOfClass:NSNumber.class]) {
            NSTimeInterval infoDelay = [startupDelayNumber doubleValue];
            
            if (infoDelay > 0 && infoDelay <= MMEStartupDelayMaximum) {
                startupDelay = infoDelay;
            }
            else NSLog(@"WARNING Mapbox Mobile Events Profile has invalid startup delay: %@", startupDelayNumber);
        }
        else NSLog(@"WARNING Mapbox Mobile Events Profile has invalid startup delay: %@", startupDelayNumber);
    }

    id accountType = [NSBundle.mme_mainBundle objectForInfoDictionaryKey:MMEAccountType];
    if ([accountType isKindOfClass:NSNumber.class]) {
        [self mme_updateFromAccountType:[accountType integerValue]];
    }
    
    // legacy user agent string
    id userAgentBase = [NSBundle.mme_mainBundle objectForInfoDictionaryKey:@"MMEMapboxUserAgentBase"];
    if ([userAgentBase isKindOfClass:NSString.class]) {
        self.mme_legacyUserAgentBase = userAgentBase;
    }
    
    id hostSDKVersion = [NSBundle.mme_mainBundle objectForInfoDictionaryKey:@"MMEMapboxHostSDKVersion"];
    if ([hostSDKVersion isKindOfClass:NSString.class]) {
        self.mme_legacyHostSDKVersion = hostSDKVersion;
    }
    
    id bundleAPIURL = [NSBundle.mme_mainBundle objectForInfoDictionaryKey:MMEGLMapboxAPIBaseURL];
    if (bundleAPIURL) {
        BOOL isCNRegionURL = [bundleAPIURL isEqual:MMEAPIClientBaseChinaAPIURL];
        [self mme_setObject:@(isCNRegionURL) forVolatileKey:MMEIsCNRegion];
    }

    id infoCollectionEnabledInSimulator = [NSBundle.mme_mainBundle objectForInfoDictionaryKey:MMECollectionEnabledInSimulator];
    if ([infoCollectionEnabledInSimulator isKindOfClass:NSNumber.class]) {
        collectionEnabledInSimulator = [infoCollectionEnabledInSimulator boolValue];
    }

    [self registerDefaults:@{
        MMEStartupDelay: @(startupDelay), // seconds
        MMEBackgroundGeofence: @(backgroundGeofence), // meters
        MMEEventFlushCount: @(MMEEventFlushCountDefault), // events
        MMEEventFlushInterval: @(MMEEventFlushIntervalDefault), // seconds
        MMEIdentifierRotationInterval: @(MMEIdentifierRotationIntervalDefault), // 24 hours
        MMEConfigurationUpdateInterval: @(MMEConfigurationUpdateIntervalDefault), // 24 hours
        MMEBackgroundStartupDelay: @(MMEBackgroundStartupDelayDefault), // seconds
        MMECollectionEnabledInSimulator: @(collectionEnabledInSimulator) // boolean
    }];
}

// MARK: - Volitile Domain

- (NSDictionary *)mme_volatileDomain {
    return [self volatileDomainForName:MMEConfigurationVolatileDomain] ?: NSDictionary.new;
}

- (void)mme_setObject:(NSObject *)value forVolatileKey:(MMEVolatileKey *)key {
    NSMutableDictionary *volatileDomain = self.mme_volatileDomain.mutableCopy;
    volatileDomain[key] = value;
    [self setVolatileDomain:volatileDomain forName:MMEConfigurationVolatileDomain];
}

- (NSObject *)mme_objectForVolatileKey:(MMEVolatileKey *)key {
    return self.mme_volatileDomain[key];
}

- (void)mme_deleteObjectForVolatileKey:(MMEVolatileKey *)key {
    NSMutableDictionary *volatileDomain = self.mme_volatileDomain.mutableCopy;
    [volatileDomain removeObjectForKey:key];
    [self setVolatileDomain:volatileDomain forName:MMEConfigurationVolatileDomain];
}

// MARK: - Persistent Domain

- (NSDictionary*)mme_PersistentDomain {
    return [self persistentDomainForName:MMEConfigurationDomain] ?: NSDictionary.new;
}

- (void)mme_setObject:(id)value forPersistentKey:(MMEPersistentKey *)key {
    NSMutableDictionary *PersistentDomain = self.mme_PersistentDomain.mutableCopy;
    PersistentDomain[key] = value;
    [self setPersistentDomain:PersistentDomain forName:MMEConfigurationDomain];
}

- (void)mme_deleteObjectForPersistentKey:(MMEPersistentKey *)key {
    NSMutableDictionary *PersistentDomain = self.mme_PersistentDomain.mutableCopy;
    [PersistentDomain removeObjectForKey:key];
    [self setPersistentDomain:PersistentDomain forName:MMEConfigurationDomain];
}

// MARK: - Event Manager Configuration

- (NSTimeInterval)mme_startupDelay {
    return (NSTimeInterval)[self doubleForKey:MMEStartupDelay];
}

- (NSUInteger)mme_eventFlushCount {
    return (NSUInteger)[self integerForKey:MMEEventFlushCount];
}

- (NSTimeInterval)mme_eventFlushInterval {
    return (NSTimeInterval)[self doubleForKey:MMEEventFlushInterval];
}

- (NSTimeInterval)mme_identifierRotationInterval {
    return (NSTimeInterval)[self doubleForKey:MMEIdentifierRotationInterval];
}

- (NSTimeInterval)mme_configUpdateInterval {
    return (NSTimeInterval)[self doubleForKey:MMEConfigurationUpdateInterval];
}

- (NSString *)mme_eventTag {
    return (NSString *)[self stringForKey:MMEConfigEventTag];
}

- (NSString *)mme_accessToken {
    return (NSString *)[self mme_objectForVolatileKey:MMEAccessToken];
}

- (void)mme_setAccessToken:(NSString *)accessToken {
    [self mme_setObject:accessToken forVolatileKey:MMEAccessToken];
}

- (NSString *)mme_legacyUserAgentBase {
    return (NSString *)[self mme_objectForVolatileKey:MMELegacyUserAgentBase];
}

- (void)mme_setLegacyUserAgentBase:(NSString *)legacyUserAgentBase {
    [self mme_setObject:legacyUserAgentBase forVolatileKey:MMELegacyUserAgentBase];
    [self mme_deleteObjectForVolatileKey:MMELegacyUserAgent];
}

- (NSString *)mme_legacyHostSDKVersion {
    return (NSString *)[self mme_objectForVolatileKey:MMELegacyHostSDKVersion];
}

- (void)mme_setLegacyHostSDKVersion:(NSString *)legacyHostSDKVersion {
    if (![legacyHostSDKVersion mme_isSemverString]) {
        NSLog(@"WARNING mme_setLegacyHostSDKVersion: version string (%@) is not a valid semantic version string: http://semver.org", legacyHostSDKVersion);
    }

    [self mme_setObject:legacyHostSDKVersion forVolatileKey:MMELegacyHostSDKVersion];
    [self mme_deleteObjectForVolatileKey:MMELegacyUserAgent];
}

// MARK: - Service Configuration

- (BOOL)mme_isCNRegion {
    BOOL isCNRegion = NO;
    id isCNRegionNumber = [self mme_objectForVolatileKey:MMEIsCNRegion];
    if ([isCNRegionNumber isKindOfClass:NSNumber.class]) {
        isCNRegion = [(NSNumber *)isCNRegionNumber boolValue];
    }
    
    return isCNRegion;
}

- (void)mme_setIsCNRegion:(BOOL) isCNRegion {
    [self mme_setObject:@(isCNRegion) forVolatileKey:MMEIsCNRegion];
}

- (NSURL *)mme_APIServiceURL {
    NSURL *serviceURL = nil;
    id infoPlistObject = [NSBundle.mme_mainBundle objectForInfoDictionaryKey:MMEEventsServiceURL];

    if ([infoPlistObject isKindOfClass:NSURL.class]) {
        serviceURL = infoPlistObject;
    }
    else if ([infoPlistObject isKindOfClass:NSString.class]) {
        serviceURL = [NSURL URLWithString:infoPlistObject];
    }
    else if ([self mme_isCNRegion]) {
        serviceURL = [NSURL URLWithString:MMEAPIClientBaseChinaAPIURL];
    }
    else {
        serviceURL = [NSURL URLWithString:MMEAPIClientBaseAPIURL];
    }
    
    return serviceURL;
}

- (NSURL *)mme_eventsServiceURL {
    NSURL *serviceURL = nil;
    id infoPlistObject = [NSBundle.mme_mainBundle objectForInfoDictionaryKey:MMEEventsServiceURL];

    if ([infoPlistObject isKindOfClass:NSURL.class]) {
        serviceURL = infoPlistObject;
    }
    else if ([infoPlistObject isKindOfClass:NSString.class]) {
        serviceURL = [NSURL URLWithString:infoPlistObject];
    }
    else if ([self mme_isCNRegion]) {
        serviceURL = [NSURL URLWithString:MMEAPIClientBaseChinaEventsURL];
    }
    else {
        serviceURL = [NSURL URLWithString:MMEAPIClientBaseEventsURL];
    }
    
    return serviceURL;
}

- (NSURL *)mme_configServiceURL {
    NSURL *serviceURL = nil;
    id infoPlistObject = [NSBundle.mme_mainBundle objectForInfoDictionaryKey:MMEConfigServiceURL];
    
    if ([infoPlistObject isKindOfClass:NSURL.class]) {
        serviceURL = infoPlistObject;
    }
    else if ([infoPlistObject isKindOfClass:NSString.class]) {
        serviceURL = [NSURL URLWithString:infoPlistObject];
    }
    else if ([self mme_isCNRegion]) {
        serviceURL = [NSURL URLWithString:MMEAPIClientBaseChinaConfigURL];
    }
    else {
        serviceURL = [NSURL URLWithString:MMEAPIClientBaseConfigURL];
    }
    
    return serviceURL;
}

- (NSString *)mme_userAgentString {
    static NSString *userAgent = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        userAgent = [NSString stringWithFormat:@"%@/%@ (%@; v%@)",
            NSBundle.mme_mainBundle.infoDictionary[(id)kCFBundleNameKey],
            NSBundle.mme_mainBundle.mme_bundleVersionString,
            NSBundle.mme_mainBundle.bundleIdentifier,
            NSBundle.mme_mainBundle.infoDictionary[(id)kCFBundleVersionKey]];
        
        // check all loaded frameworks for mapbox frameworks
        for (NSBundle *loaded in NSBundle.allFrameworks) {
            if (loaded != NSBundle.mme_mainBundle
            && loaded.bundleIdentifier
            && [loaded.bundleIdentifier rangeOfString:@"mapbox" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                NSString *uaFragment = [NSString stringWithFormat:@" %@/%@ (%@; v%@)",
                    loaded.infoDictionary[(id)kCFBundleNameKey],
                    loaded.mme_bundleVersionString,
                    loaded.bundleIdentifier,
                    loaded.infoDictionary[(id)kCFBundleVersionKey]];
                userAgent = [userAgent stringByAppendingString:uaFragment];
            }
        }
    });
    
    return userAgent;
}

- (NSString *)mme_legacyUserAgentString {
    NSString *legacyUAString = (NSString *)[self mme_objectForVolatileKey:MMELegacyUserAgent];
    if (!legacyUAString) {
        legacyUAString= [NSString stringWithFormat:@"%@/%@/%@ %@/%@",
            NSBundle.mme_mainBundle.bundleIdentifier,
            NSBundle.mme_mainBundle.mme_bundleVersionString,
            [NSBundle.mme_mainBundle objectForInfoDictionaryKey:(id)kCFBundleVersionKey],
            self.mme_legacyUserAgentBase,
            self.mme_legacyHostSDKVersion];
        [self mme_setObject:legacyUAString forVolatileKey:MMELegacyUserAgent];
    }
    return legacyUAString;
}

// MARK: - Update Configuration

- (nullable MMEDate *)mme_configUpdateDate {
    MMEDate *updateTime = (MMEDate *)[self mme_objectForVolatileKey:MMEConfigUpdateDate];
    if (!updateTime) { // try loading from the Persistent domain
        NSData *updateData = [self objectForKey:MMEConfigUpdateData];
        if (updateData) { // unarchive the data, saving the MMEDate in the volatile domain
            NSKeyedUnarchiver* unarchiver = [NSKeyedUnarchiver.alloc initForReadingWithData:updateData];
            unarchiver.requiresSecureCoding = YES;
            updateTime = [unarchiver decodeObjectOfClass:MMEDate.class forKey:NSKeyedArchiveRootObjectKey];
        } // else nil
    }
    return updateTime;
}

- (void)mme_setConfigUpdateDate:(nullable MMEDate *)updateTime {
    if (@available(iOS 10.0, macos 10.12, tvOS 10.0, watchOS 3.0, *)) {
        if (updateTime) {
            if (updateTime.timeIntervalSinceNow <= 0) { // updates always happen in the past
                NSKeyedArchiver *archiver = [NSKeyedArchiver new];
                archiver.requiresSecureCoding = YES;
                [archiver encodeObject:updateTime forKey:NSKeyedArchiveRootObjectKey];
                NSData *updateData = archiver.encodedData;
                [self mme_setObject:updateData forPersistentKey:MMEConfigUpdateData];
                [self mme_setObject:updateTime forVolatileKey:MMEConfigUpdateDate];
            }
            else NSLog(@"WARNING Mapbox Mobile Events Config Update Date cannot be set to a future date: %@", updateTime);
        }
    }
}

// MARK: - Location Collection

- (BOOL)mme_isCollectionEnabled {
    BOOL collectionEnabled = ![self boolForKey:MMECollectionDisabled];
    
#if TARGET_OS_SIMULATOR
    // disable collection in the simulator unless explicitly enabled for testing
    if (!self.mme_isCollectionEnabledInSimulator) {
        collectionEnabled = NO;
    }
#endif

    // if not explicitly disabled, or in simulator, check for low power mode
    if (@available(iOS 9.0, *)) {
        if (collectionEnabled && [NSProcessInfo instancesRespondToSelector:@selector(isLowPowerModeEnabled)]) {
                collectionEnabled = !NSProcessInfo.processInfo.isLowPowerModeEnabled;
        }
    }

    return collectionEnabled;
}

- (void)mme_setIsCollectionEnabled:(BOOL) collectionEnabled {
    [self mme_setObject:@(!collectionEnabled) forPersistentKey:MMECollectionDisabled];
}

- (BOOL)mme_isCollectionEnabledInSimulator {
    return [self boolForKey:MMECollectionEnabledInSimulator];
}

// MARK: - Background Collection

- (BOOL)mme_isCollectionEnabledInBackground {
    BOOL collectionEnabled = self.mme_isCollectionEnabled;
    if (collectionEnabled) { // check to see if it's seperately disabled
        id collectionDisabled = [self objectForKey:MMECollectionDisabledInBackground];
        if (collectionDisabled && [collectionDisabled isKindOfClass:NSNumber.class]) { //
            collectionEnabled = ![(NSNumber *)collectionDisabled boolValue];
        }
    }
    return collectionEnabled;
}

- (NSTimeInterval)mme_backgroundStartupDelay {
    return (NSTimeInterval)[self doubleForKey:MMEBackgroundStartupDelay];
}

-(CLLocationDistance)mme_backgroundGeofence {
    return (CLLocationDistance)[self doubleForKey:MMEBackgroundGeofence];
}

// MARK: - Certificate Pinning and Revocation

- (NSArray<NSString *>*)mme_certificateRevocationList {
    NSArray<NSString *>* crl = @[];
    id crlObject = [self objectForKey:MMECertificateRevocationList];
    if ([crlObject isKindOfClass:NSArray.class]) {
        crl = (NSArray*)crlObject;
    }
    
    return crl;
}

/// The Certificate Pinning config
- (NSDictionary *)mme_certificatePinningConfig {
    NSMutableArray *comPublicKeys = @[
        @"T4XyKSRwZ5icOqGmJUXiDYGa+SaXKTGQXZwhqpwNTEo=",
        @"KlV7emqpeM6V2MtDEzSDzcIob6VwkdWHiVsNQQzTIeo=",
        @"16TK3iq9ZB4AukmDemjUyhcPTUnsSuqd5OB5zOrheZY=",
        @"F16cPFncMDkB4XbRfK64H1dqncNg6JOdd+w2qElR/hM=",
        @"45PQwWtFAHQd/cVzMVuhkwOQwCF+JE4ZViA4gkzvWeQ=",
        @"mCzfopN5vqaerktI/172w8T7qw2sfRXgUL4Z7xA2e/c=",
        @"rFFCqIOOKu7KH1v73IHb6mzZQth7cVvVDaH+EjkNfKM=",
        @"pZBpEiH9vLwSICbogdpgyGG3NCjVKw4oG2rEWRf03Vk=",
        @"gPgpSOzaLjbIpDLlh302x2irQTzWfsQqIWhUsreMMzI=",
        @"wLHqvUDDQfFymRVS2O6AF5nkuAY+KJZpI4+pohK+SUE=",
        @"yAEZR9ydeTrMlcUp91PHdmJ3lBa86IWsKRwiM0KzS6Q=",
        @"k3NZbP68SikfwacfWDm4s3YJDsPVWJSOF4GlCWo5RJA=",
        @"1PRG2KOhfDE+xMS1fxft5CtQO99mzqhpl4gPz/64IxQ=",
        @"FBibSsaWfYYIkij1x4Oc9Lt0jHl+6AhBTWAypcOphhc=",
        @"X0K6GmWp00Pb0YATdlCPeXaZR/NxxHTv41OAEkymkbU=",
        @"DU/+Q9Itbb4WuSfuTvOgPtxtF6eAbTH7pUFn17/o5E0=",
        @"BYGHyEqtaJEZn+02i4jy4dGRRFNr6xckQjTL7DMZFes=",
        @"zr1/pj8y4FUbrxIYRaHVZWvhsMPzDVW0R+ljPHrX5Sw=",
        @"fS9IR9OWsirEnSAqParPG0BzZJ+Dk4CiHfPv1vEjrf0=",
        @"f1B7KmHknBSXNjTC8ac/Hf7hwU2goerE53TJppr0OH0=",
        @"OKbbVU/+cTlszrJkxKaQraFAoVyjPOqa5Uq8Ndd4AUg=",
        @"I0xGZF5s9kGHJHz6nKN+nYJKwf8ev1MdWkGt7EI7A7g=",
        @"anATIIIqUd4o7Asto7X7OEJ+m7YTUr0aJKHZXqL92w0=",
        @"JXFJ+lQK4GwJpJlHSZ2ZAR5luZDwMdaa2hJyhqHc1L8=",
        @"64k4IzkPceL/hQywCCvJLQds8FPMPwtclhFOR/taKAQ=",
        @"c079Pt5XXCwSv+pROEF+YW5gRoyzJ248bPxVLrUYkHM=",
        @"46ofOPUGR3SYcMB+MmXqowYKan/c18LBTV2sAk13WKc=",
        @"4qwz7KaBHxEX+YxO8STVowTg2BxlOd98GNU5feRjdjU=",
        @"hp54/fY89ziuBBp1zv3YaC8H9/G8/Xp97hdzRVdcqQ0=",
        @"BliQkuPecuHEp3FN3r1HogAkmsLtZz3ZImqLSpJoJzs=",
        @"GayCH1YATG/OS5h1bq79XRmcq/aqwoObu2OYfPN7vQc=",
        @"fW6I4HEBwa1Pwi1dldkb+ljs4re5ZY2JbsCiCxCOCgI=",
        @"GcqilfT04N2efVIWlzJWO04gdpwYC4sLnOx3TJIKA9E=",
        @"+1CHLRDE6ehp61cm8+NDMvd32z0Qc4bgnZRLH0OjE94=",
        @"4vJWNxtoMLAY35dbzKeDI+4IAFOW97WNkTWnNMtY5TA=",
        @"1YjWX9tieIA1iGkJhm7UapH6PiwGViZBWrXA3UJUAWc=",
        @"X+RKpA7gtptrZ9yI1C96Isw5RV8dQyx5z7I/xfCaBl8=",
        @"hqFsdAuHVvjX3NuaUBVZao94V30SdXLAsG1O0ajgixw=",
        @"wYl9ZFQd2LWKfjDuEQxo7S0CcrPkP9A3vb20fbHf1ZQ=",
        @"Y3ax6OgoQkcStQZ2hrIAqMDbaEEwX6xZfMZEnVcn/4k=",
        @"taSOM7qPorxZ64Whrl5ZiNCGlZqLrVPOIBwPr/Nkw6U=",
        @"KB5X/PyAAiRc7W/NjUyd6xbDdibuOTWBJB2MqHHF/Ao=",
        @"hRQ7yTW/P5l76uNNP3MXNgshlmcbDNHMtBxCbUtGAWE=",
        @"AoclhkrtKF+qHKKq0wUS4oXLwlJtWlywtiLndnNzS2U=",
        @"5ikvGB5KkNlwesHRqjYvkZGlxP6OLMbaCkpflTM4DNM=",
        @"qK2GksTrZ7LXDBkNWH6FnuNGxgxPpwNSK+NgknU7H1U=",
        @"K3qyQniCBiGmfutYDE7ryDY2YoTORgp4DOgK1laOqfo=",
        @"B7quINbFSUen02LQ9kwtYXnsJtixTpKafzXFkcRb7RU=",
        @"Kc7lrHTlRfLaeRaEof6mKKmBH2eYHMYkxOy3yGlzUWg=",
        @"7s1BUHi/AW/beA2jXamNTUgbDMH4gVPR9diIhnN1o0Q=",
        //Digicert, 2018, SHA1 Fingerprint=5F:AB:D8:86:2E:7D:8D:F3:57:6B:D8:F2:F4:57:7B:71:41:90:E3:96
        @"3coVlMAEAYhOEJHgXwloiPDGaF+ZfxHZbVoK8AYYWVg=",
        //Digicert, 2018, SHA1 Fingerprint=1F:B8:6B:11:68:EC:74:31:54:06:2E:8C:9C:C5:B1:71:A4:B7:CC:B4
        @"5kJvNEMw0KjrCAu7eXY5HZdvyCS13BbA0VJG1RSP91w=",
        //GeoTrust, 2018, SHA1 Fingerprint=57:46:0E:82:B0:3F:E7:2C:AE:AC:CA:AF:2B:1D:DA:25:B4:B3:8A:4A
        @"+O+QJCmvoB/FkTd0/5FvmMSvFbMqjYU+Txrw1lyGkUQ=",
        //GeoTrust, 2018, SHA1 Fingerprint=7C:CC:2A:87:E3:94:9F:20:57:2B:18:48:29:80:50:5F:A9:0C:AC:3B
        @"zUIraRNo+4JoAYA7ROeWjARtIoN4rIEbCpfCRQT6N6A=",
    ].mutableCopy;
    
    NSMutableArray *cnPublicKeys = @[
        @"6+ErFga5JfYfvwx2JbEJJNmUXJFnXIKllrbPKmvWqNc=",
        @"vLkrnr8JTAVaYPwY/jBkKCe+YQWleaHPU3Tlqom+gCg=",
        @"UofZo86l1bDjTiHyKXurqgfkYaYjtjyTrOYYR68XLG8=",
        @"wSE/ahOwDVj7tMLMOjoAr1gIoBoWrUhQOBliQ82/bGk=",
        @"RKHNDCiwHVTR5vKksBOcpfaojpsfCMFQ9MAE01ac8Tk=",
        @"enUlaLivnHjrJBFVcvr8gwVTVcjXWOv8n96jU5towo8=",
        @"Cul962ner+uZmwBQybZi0CHlFiZ3uFnZJe/lKqnqL6k=",
        @"WswAtgVhFf6bIpavbiBL2GOP+e/zWqnECQrK17qKOLU=",
        @"O+4Y2hugHTXgiaf6s2Zt4Vc7M3l3lLLu+6ugYGLI1x0=",
        @"tfeXXd8OZXRbuZgeOanQAsgQlgdh4GBIIyCDvULtwLA=",
        @"A+vWP93KGIMHeADZtj9S/mSIQtvzGz5G671aRKf3NlY=",
        @"malXG7/2Qay6uSfQxLGm2Lob8MVjSPkzNrtdnwpHhuA=",
        @"zfBsiWe9eHeGevBcYtrGiPQ0zCr2IvB08S7ESSWqVN8=",
        @"o8bx+G1dysezoWAvOXBsl4/E6LcABFSqy6J8si5Cryk=",
        @"YrsgZS2RzrUtunIndi031Ye/HyMn7WQQweav4xgR6qk=",
        @"HQqyJQU7b+X/v1297LXK4TxKMwdC72Qzqy7Jx5W3LgA=",
        @"00lmpHvG3dPLQ/hsewpHNLsK9vruPV+0hcQAl7FmRxI=",
        @"lrmOBGfUptzfKOgSLUCKRvhfYNLH94x2ZKaX5ijBbTs=",
        @"nf4V9/G5BE3bNy7TDkvqc7MaIkfcA625hjtQM7FJkcM=",
        @"/0K/iJYfENe5o5arEhWfT7sailUd/QBY3ws0wD9dggU=",
        @"SDnReAbazEH28n7pV5M/8A0M8ggJrO8/teE7oCJ7OGU=",
        @"gruIKpo+vo5XKJ8t6yoPeNrpjWSsdnyaxkSLe/vSz2U=",
        @"a4CTRze+fw6iUhnKA7Ph2Qt41eco42RBFcHITnYcNoY=",
        @"8wc+3VCcufdq1JzdsxtaleFLA/u/peBtjfdPOeFKsIo=",
        @"a5foMaNKMbLYMnB079u3G2oxhSRSHilwljENMsBiQwE=",
        @"r1t+lUCzuncTnfM/QtclWIA7zhN8AYYUWlIimDhI0HM=",
        @"dFS5RaEoQf7naXnfYnP1AuQMxyJwygHAXRG4bOZD6OM=",
        @"zSAUiJZbnZdUu2bKUNf21r7RXJPzHGuMFxwPx7aLhfg=",
        @"UmlVTDcbkUR075i+thE9Q1fOxPIGn8PmQ51R+XL4fK8=",
        @"Zx+aoQE1cmiSN1TwvCo1Qpvuwjbq35eH4DsmkXKacIo=",
        @"TAOftRoKGrOsFjgCtUzHswja6MykOf9UZaoljB6TYso=",
        @"tW+psPLgOjPSsSMZPxc/PDGw0vBIpIZz32av4NEzVjc=",
        @"35zTxuHmPcNqJ5OSW02V+9ghV3TJYmBI3arMTuC1z9w=",
        @"ciiuiChtsyaTUEkDZ/N1KJaAgr4bIAIM13R0B9NVt6M=",
        @"cwUwdyqZ6YOMWX5zcJcYarQ5okvMLxj/Rd4dUpkRFHM=",
        @"tShTLeS4OltlKlE3MQUvXlJsGrCFgFo/nXvl5t0qba8=",
        @"qy6BTLAetvqNOFfT/M3pZSRo9FRaF8KudDGgHy8Fxis=",
        @"AOOutVCG4tDUsn13XyTAsx3cTZtIGajdCxSJoGZ+jp4=",
        @"0LqMhNP7UHpAVl6+ON7AzsqeMWZb1ElB5AL0kPS6ktI=",
        @"Zqng4S5spV0NeKT8MrE8CJFMBTP188PG9iEi7/9HDyo=",
        @"i/4rsupujT8Ww/2yIGJ3wb6R7GDw2FHPyOM5sWh87DQ=",
        @"cvlddgcP0XDOIKnCr+h+2zy2Tt8pnCPdw1l+PiEyS5o=",
        @"UhpcxVytZbC4dx2Dnjjg6k02Ylf5jLo3C3AxchaKhh0=",
        @"ZJfLxFuRg/1giSVrnj6aZmU5T//PP2eU7NLXXeqdH7s=",
        @"ZnL4xB/aLV5W0YSZVefBRZSRTeoLzjJkk7CBvz75/m8=",
        @"d4GNs3j9rUym4ogDTWX7AXTaI3K3gt46S2tvL6Hh/bQ=",
        @"R9Wa2ON8VRWRF5OyDDaSDMhf7ysK1ykV1XSq20RMDFM=",
        @"QMMBDJh3g1QgkGV6m+T4i2weBGj/W2+fVG73slK3mJE=",
        @"ENU8M1yItdL5EP0G+I4hz4iuGlAUIHWCe4ipwXB/c/A=",
        @"PA1lecwXNRXY/Vpy0VN+jQEYChN4hCAF36oB0Ygx3wQ=",
        // Digicert, 2016, SHA1 Fingerprint=0A:80:27:6E:1C:A6:5D:ED:1D:C2:24:E7:7D:0C:A7:24:0B:51:C8:54
        @"Tb0uHZ/KQjWh8N9+CZFLc4zx36LONQ55l6laDi1qtT4=",
        // Digicert, 2017, SHA1 Fingerprint=E2:8E:94:45:E0:B7:2F:28:62:D3:82:70:1F:C9:62:17:F2:9D:78:68
        @"yGp2XoimPmIK24X3bNV1IaK+HqvbGEgqar5nauDdC5E=",
        // Geotrust, 2016, SHA1 Fingerprint=1A:62:1C:B8:1F:05:DD:02:A9:24:77:94:6C:B4:1B:53:BF:1D:73:6C
        @"BhynraKizavqoC5U26qgYuxLZst6pCu9J5stfL6RSYY=",
        // Geotrust, 2017, SHA1 Fingerprint=20:CE:AB:72:3C:51:08:B2:8A:AA:AB:B9:EE:9A:9B:E8:FD:C5:7C:F6
        @"yJLOJQLNTPNSOh3Btyg9UA1icIoZZssWzG0UmVEJFfA=",
    ].mutableCopy;
    
    // apply the CRL
    if (NSUserDefaults.mme_configuration.mme_certificateRevocationList) {
        [comPublicKeys removeObjectsInArray:NSUserDefaults.mme_configuration.mme_certificateRevocationList];
        [cnPublicKeys removeObjectsInArray:NSUserDefaults.mme_configuration.mme_certificateRevocationList];
    }
    
    return @{
        MMEEventsMapboxCom:     comPublicKeys,
        MMEEventsMapboxCN:      cnPublicKeys,
#if DEBUG
        MMEEventsTilestreamNet: @[@"f0eq9TvzcjRVgNZjisBA1sVrQ9b0pJA5ESWg6hVpK2c="]
#endif
    };
}

// MARK: - Configuration Service

- (NSError *)mme_updateFromConfigServiceData:(NSData *)configData {
    NSError *updateError = nil;
    if (configData) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:configData options:kNilOptions error:&updateError];
        if (json) {
            [self mme_updateFromConfigServiceObject:json updateError:&updateError];
        }
    }
    
    return updateError;
}

- (void)mme_updateFromAccountType:(NSInteger)typeCode {
    if (typeCode == MMEAccountType1) {
        [self mme_setObject:@(YES) forPersistentKey:MMECollectionDisabled];
    }
    else if (typeCode == MMEAccountType2) {
        [self mme_setObject:@(YES) forPersistentKey:MMECollectionDisabledInBackground];
    }
}

- (BOOL)mme_updateFromConfigServiceObject:(NSDictionary *)configDictionary updateError:(NSError **)updateError{
    BOOL success = NO;
    if (configDictionary) {
        if ([configDictionary.allKeys containsObject:MMERevokedCertKeys]) {
            NSError *error = [NSError errorWithDomain:MMEErrorDomain code:MMEErrorConfigUpdateError userInfo:@{
                NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Config object contains invalid key: %@", MMERevokedCertKeys]
            }];
            if (error && updateError) {
                *updateError = error;
            }
            return success;
        }

        id configCRL = [configDictionary objectForKey:MMEConfigCRLKey];
        if ([configCRL isKindOfClass:NSArray.class]) {
            for (NSString *publicKeyHash in configCRL) {
                NSData *pinnedKeyHash = [[NSData alloc] initWithBase64EncodedString:publicKeyHash options:(NSDataBase64DecodingOptions)0];
                if ([pinnedKeyHash length] != CC_SHA256_DIGEST_LENGTH){
                    NSError *error = [NSError errorWithDomain:MMEErrorDomain code:MMEErrorConfigUpdateError userInfo:@{
                        NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Hash value invalid: %@", pinnedKeyHash]
                    }];
                    if (error && updateError) {
                        *updateError = error;
                    }
                    return success;
                }
            }
            
            [self mme_setObject:configCRL forPersistentKey:MMECertificateRevocationList];
        }
        
        id configTTO = [configDictionary objectForKey:MMEConfigTTOKey];
        if ([configTTO isKindOfClass:NSNumber.class]) {
            [self mme_updateFromAccountType:[configTTO integerValue]];
        }
        
        id configGFO = [configDictionary objectForKey:MMEConfigGFOKey];
        if ([configGFO isKindOfClass:NSNumber.class]) {
            CLLocationDistance gfoDistance = [configGFO doubleValue];
            if (gfoDistance >= MMECustomGeofenceRadiusMinimum
             && gfoDistance <= MMECustomGeofenceRadiusMaximum) {
                [self mme_setObject:@(gfoDistance) forPersistentKey:MMEBackgroundGeofence];
            }
            else { // fallback to the default
                [self removeObjectForKey:MMEBackgroundGeofence];
            }
        }
        
        id configBSO = [configDictionary objectForKey:MMEConfigBSOKey];
        if ([configBSO isKindOfClass:NSNumber.class]) {
            NSTimeInterval bsoInterval = [configBSO doubleValue];
            if (bsoInterval > 0 && bsoInterval <= MMEStartupDelayMaximum) {
                [self mme_setObject:@(bsoInterval) forPersistentKey:MMEBackgroundStartupDelay];
            }
        }
        
        id configTag = [configDictionary objectForKey:MMEConfigTagKey];
        if ([configTag isKindOfClass:NSString.class]) {
            [self mme_setObject:configTag forPersistentKey:MMEConfigEventTag];
        }
        
        success = YES;
    }
    return success;
}

@end

// MARK: -

@implementation NSBundle (MME)

static NSBundle *MMEMainBundle = nil;

+ (NSBundle *)mme_mainBundle {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self mme_setMainBundle:nil];
    });
    return MMEMainBundle;
}

+ (void)mme_setMainBundle:(nullable NSBundle *)mainBundle {
    if (mainBundle) {
        MMEMainBundle = mainBundle;
    }
    else {
        MMEMainBundle = NSBundle.mainBundle;
    }
}

// MARK: -


- (NSString *)mme_bundleVersionString {
    NSString *bundleVersion = @"0.0.0";

    // check for MGLSemanticVersionString in Mapbox.framework
    if ([self.infoDictionary.allKeys containsObject:@"MGLSemanticVersionString"]) {
        bundleVersion = self.infoDictionary[@"MGLSemanticVersionString"];
    }
    else if ([self.infoDictionary.allKeys containsObject:@"CFBundleShortVersionString"]) {
        bundleVersion = self.infoDictionary[@"CFBundleShortVersionString"];
    }

    if (![bundleVersion mme_isSemverString]) {
        NSLog(@"WARNING bundle %@ version string (%@) is not a valid semantic version string: http://semver.org", self, bundleVersion);
    }
    
    return bundleVersion;
}

@end

NS_ASSUME_NONNULL_END
