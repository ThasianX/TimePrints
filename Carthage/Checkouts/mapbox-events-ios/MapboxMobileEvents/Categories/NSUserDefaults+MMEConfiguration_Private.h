#ifndef NSUserDefaults_MMEConfiguration_Private_h
#define NSUserDefaults_MMEConfiguration_Private_h

#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const MMEConfigurationDomain = @"com.mapbox.events";
static NSString * const MMEConfigurationVolatileDomain = @"com.mapbox.events.volatile";

// MARK: MMEConfigurationDomain Keys

typedef NSString MMEPersistentKey;

static MMEPersistentKey * const MMEStartupDelay = @"MMEStartupDelay";
static MMEPersistentKey * const MMEEventFlushCount = @"MMEEventFlushCount";
static MMEPersistentKey * const MMEEventFlushInterval = @"MMEEventFlushInterval";
static MMEPersistentKey * const MMEIdentifierRotationInterval = @"MMEIdentifierRotationInterval";
static MMEPersistentKey * const MMEConfigurationUpdateInterval = @"MMEConfigurationUpdateInterval";
static MMEPersistentKey * const MMECollectionDisabled = @"MMECollectionDisabled";
static MMEPersistentKey * const MMECollectionDisabledInBackground = @"MMECollectionDisabledInBackground";
static MMEPersistentKey * const MMEBackgroundStartupDelay = @"MMEBackgroundStartupDelay";
static MMEPersistentKey * const MMEBackgroundGeofence = @"MMEBackgroundGeofence";
static MMEPersistentKey * const MMECertificateRevocationList = @"MMECertificateRevocationList";
static MMEPersistentKey * const MMEConfigEventTag = @"MMEConfigEventTag";
static MMEPersistentKey * const MMEConfigUpdateData = @"MMEConfigUpdateData";

// MARK: - MMEConfigurationVolatileDomain

typedef NSString MMEVolatileKey;

static MMEVolatileKey * const MMEIsCNRegion = @"MMEIsCNRegion";
static MMEVolatileKey * const MMEAccessToken = @"MMEAccessToken";
static MMEVolatileKey * const MMELegacyUserAgent = @"MMELegacyUserAgent";
static MMEVolatileKey * const MMELegacyUserAgentBase = @"MMELegacyUserAgentBase";
static MMEVolatileKey * const MMELegacyHostSDKVersion = @"MMELegacyHostSDKVersion";
static MMEVolatileKey * const MMEConfigUpdateDate = @"MMEConfigUpdateDate";

// MARK: - Info.plist Keys

static NSString * const MMEAccountType = @"MGLMapboxAccountType";
static NSString * const MMEEventsProfile = @"MMEEventsProfile";
static NSString * const MMECustomGeofenceRadius = @"MMECustomGeofenceRadius";
static NSString * const MMECustomProfile = @"Custom";
static NSString * const MMEGLMapboxAPIBaseURL = @"MGLMapboxAPIBaseURL";
static NSString * const MMEEventsServiceURL = @"MMEEventsServiceURL";
static NSString * const MMEConfigServiceURL = @"MMEConfigServiceURL";
static NSString * const MMECollectionEnabledInSimulator = @"MMECollectionEnabledInSimulator";

// MARK: - Info.plist Values

static NSUInteger const MMEAccountType1 = 1;
static NSUInteger const MMEAccountType2 = 2;

// MARK: - Service Hosts

static NSString * const MMEAPIMapboxCom = @"api.mapbox.com";
static NSString * const MMEEventsMapboxCom = @"events.mapbox.com";
static NSString * const MMEConfigMapboxCom = @"config.mapbox.com";

static NSString * const MMEAPIMapboxCN = @"api.mapbox.cn";
static NSString * const MMEEventsMapboxCN = @"events.mapbox.cn";
static NSString * const MMEConfigMapboxCN = @"config.mapbox.cn";

#if DEBUG
static NSString * const MMEAPITilestreamNet = @"cloudfront-staging.tilestream.net";
static NSString * const MMEEventsTilestreamNet = @"api-events-staging.tilestream.net";
static NSString * const MMEConfigTilestreamNet = @"api-events-config-staging.tilestream.net";
#endif

static NSString * const MMEAPIClientBaseConfigURL = @"https://config.mapbox.com";
static NSString * const MMEAPIClientBaseChinaConfigURL = @"https://config.mapbox.cn";

// MARK: - Config Service Keys

static NSString * const MMERevokedCertKeys = @"RevokedCertKeys"; // legacy
static NSString * const MMEConfigCRLKey = @"crl"; // certificate revocation list
static NSString * const MMEConfigTTOKey = @"tto"; // telemetry type option
static NSString * const MMEConfigGFOKey = @"gfo"; // geo-fence option
static NSString * const MMEConfigBSOKey = @"bso"; // background startup option
static NSString * const MMEConfigTagKey = @"tag"; // event tag

// MARK: - Constants

static int const MMEEventFlushCountDefault = 180; // events
static NSTimeInterval const MMEEventFlushIntervalDefault = 180; // seconds
static NSTimeInterval const MMEIdentifierRotationIntervalDefault = 24 * 60 * 60; // 24 hours
static NSTimeInterval const MMEConfigurationUpdateIntervalDefault = 24 * 60 * 60; // 24 hours
static NSTimeInterval const MMEBackgroundStartupDelayDefault = 15.0; // seconds
static NSTimeInterval const MMEStartupDelayDefault = 1;
static CLLocationDistance const MMEBackgroundGeofenceDefault = 300.0; // Meters

// MARK: - Limits

static CLLocationDistance const MMECustomGeofenceRadiusMinimum = 300.0;
static CLLocationDistance const MMECustomGeofenceRadiusMaximum = 1200.0;
static NSTimeInterval const MMEStartupDelayMaximum = 100;

// MARK: -

@interface NSUserDefaults (MMEConfiguration_Private)

+ (void)mme_resetConfiguration;

// MARK: -

- (void)mme_registerDefaults;
- (NSError *)mme_updateFromConfigServiceData:(NSData *)configData;

- (void)mme_deleteObjectForVolatileKey:(MMEVolatileKey *)key;
- (void)mme_deleteObjectPersistentKey:(MMEPersistentKey *)key;

@end

// MARK: -

@interface NSBundle (MMEConfiguration_Private)
@property(class, nonatomic, null_resettable, setter=mme_setMainBundle:) NSBundle *mme_mainBundle;
@property(nonatomic, readonly) NSString *mme_bundleVersionString;

@end

NS_ASSUME_NONNULL_END

#endif /* NSUserDefaults_MMEConfiguration_Private_h */
