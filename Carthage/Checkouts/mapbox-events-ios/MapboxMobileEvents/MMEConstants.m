#import "MMEConstants.h"

NSString * const MMEAPIClientBaseAPIURL = @"https://api.mapbox.com";
NSString * const MMEAPIClientBaseChinaAPIURL = @"https://api.mapbox.cn";
NSString * const MMEAPIClientBaseEventsURL = @"https://events.mapbox.com";
NSString * const MMEAPIClientBaseChinaEventsURL = @"https://events.mapbox.cn";
NSString * const MMEAPIClientEventsPath = @"events/v2";
NSString * const MMEAPIClientEventsConfigPath = @"events-config";
NSString * const MMEAPIClientAttachmentsPath = @"attachments/v1";
NSString * const MMEAPIClientHeaderFieldUserAgentKey = @"User-Agent";
NSString * const MMEAPIClientHeaderFieldContentTypeKey = @"Content-Type";
NSString * const MMEAPIClientHeaderFieldContentTypeValue = @"application/json";
NSString * const MMEAPIClientAttachmentsHeaderFieldContentTypeValue = @"multipart/form-data";
NSString * const MMEAPIClientHeaderFieldContentEncodingKey = @"Content-Encoding";
NSString * const MMEAPIClientHTTPMethodPost = @"POST";
NSString * const MMEAPIClientHTTPMethodGet = @"GET";
NSString * const MMEResponseKey = @"MMEResponseKey";

NSString * const MMEDebugEventType = @"debug.type";
NSString * const MMEDebugEventTypeError = @"error";
NSString * const MMEDebugEventTypeFlush = @"flush";
NSString * const MMEDebugEventTypePush = @"push";
NSString * const MMEDebugEventTypePost = @"post";
NSString * const MMEDebugEventTypePostFailed = @"postFailed";
NSString * const MMEDebugEventTypeTurnstile = @"turnstile";
NSString * const MMEDebugEventTypeTurnstileFailed = @"turnstileFailed";
NSString * const MMEDebugEventTypeBackgroundTask = @"backgroundTask";
NSString * const MMEDebugEventTypeMetricCollection = @"metricCollection";
NSString * const MMEDebugEventTypeLocationManager = @"locationManager";
NSString * const MMEDebugEventTypeTelemetryMetrics = @"telemMetrics";
NSString * const MMEDebugEventTypeCertPinning = @"certPinning";

NSString * const MMEEventTypeAppUserTurnstile = @"appUserTurnstile";
NSString * const MMEEventTypeTelemetryMetrics = @"telemetryMetrics";
NSString * const MMEEventTypeLocation = @"location";
NSString * const MMEEventTypeVisit = @"visit";
NSString * const MMEEventTypeLocalDebug = @"debug";
NSString * const MMEEventTypeMapLoad = @"map.load";
NSString * const MMEventTypeOfflineDownloadStart = @"map.offlineDownload.start";
NSString * const MMEventTypeOfflineDownloadEnd = @"map.offlineDownload.end";

NSString * const MMEEventKeyArrivalDate = @"arrivalDate";
NSString * const MMEEventKeyDepartureDate = @"departureDate";
NSString * const MMEEventKeyLatitude = @"lat";
NSString * const MMEEventKeyLongitude = @"lng";
NSString * const MMEEventKeyMaxZoomLevel = @"maxZoom";
NSString * const MMEEventKeyMinZoomLevel = @"minZoom";
NSString * const MMEEventKeyZoomLevel = @"zoom";
NSString * const MMEEventKeySpeed = @"speed";
NSString * const MMEEventKeyStyleURL = @"styleURL";
NSString * const MMEEventKeyCourse = @"course";
NSString * const MMEEventHorizontalAccuracy = @"horizontalAccuracy";
NSString * const MMEEventKeyLocalDebugDescription = @"debug.description";
NSString * const MMEEventKeyErrorCode = @"error.code";
NSString * const MMEEventKeyErrorDomain = @"error.domain";
NSString * const MMEEventKeyErrorDescription = @"error.description";
NSString * const MMEEventKeyErrorFailureReason = @"error.failureReason";
NSString * const MMEEventKeyErrorNoReason = @"No Reason";
NSString * const MMEEventKeyErrorNoDomain = @"No Domain";
NSString * const MMEEventKeyEvent = @"event";
NSString * const MMEEventKeyCreated = @"created";
NSString * const MMEEventKeyVendorId = @"userId";
NSString * const MMEEventKeyModel = @"model";
NSString * const MMEEventKeyDevice = @"device";
NSString * const MMEEventKeySkuId = @"skuId";
NSString * const MMEEventKeyEnabledTelemetry = @"enabled.telemetry";
NSString * const MMEEventKeyOperatingSystem = @"operatingSystem";
NSString * const MMEEventKeyResolution = @"resolution";
NSString * const MMEEventKeyAccessibilityFontScale = @"accessibilityFontScale";
NSString * const MMEEventKeyOrientation = @"orientation";
NSString * const MMEEventKeyPluggedIn = @"pluggedIn";
NSString * const MMEEventKeyWifi = @"wifi";
NSString * const MMEEventKeyShapeForOfflineRegion = @"shapeForOfflineRegion";
NSString * const MMEEventKeySource = @"source";
NSString * const MMEEventKeySessionId = @"sessionId";
NSString * const MMEEventKeyApplicationState = @"applicationState";
NSString * const MMEEventKeyAltitude = @"altitude";
NSString * const MMEEventKeyLocationAuthorization = @"locationAuthorization";
NSString * const MMEEventKeyLocationEnabled = @"locationEnabled";
NSString * const MMEEventKeyFailedRequests = @"failedRequests";
NSString * const MMEEventKeyHeader = @"header";
NSString * const MMEEventKeyPlatform = @"platform";
NSString * const MMEEventKeyUserAgent = @"userAgent";
NSString * const MMEEventKeyiOS = @"iOS";
NSString * const MMEEventKeyMac = @"macOS";
NSString * const MMEEventSDKIdentifier = @"sdkIdentifier";
NSString * const MMEEventSDKVersion = @"sdkVersion";
NSString * const MMEEventDateUTC = @"dateUTC";
NSString * const MMEEventRequests = @"requests";
NSString * const MMEEventTotalDataSent = @"totalDataSent";
NSString * const MMEEventCellDataSent = @"cellDataSent";
NSString * const MMEEventWiFiDataSent = @"wifiDataSent";
NSString * const MMEEventTotalDataReceived = @"totalDataReceived";
NSString * const MMEEventCellDataReceived = @"cellDataReceived";
NSString * const MMEEventWiFiDataReceived = @"wifiDataReceived";
NSString * const MMEEventAppWakeups = @"appWakeups";
NSString * const MMEEventEventCountPerType = @"eventCountPerType";
NSString * const MMEEventEventCountFailed = @"eventCountFailed";
NSString * const MMEEventEventCountTotal = @"eventCountTotal";
NSString * const MMEEventEventCountMax = @"eventCountMax";
NSString * const MMEEventDeviceLat = @"deviceLat";
NSString * const MMEEventDeviceLon = @"deviceLon";
NSString * const MMEEventDeviceTimeDrift = @"deviceTimeDrift";
NSString * const MMEEventConfigResponse = @"configResponse";
NSString * const MMEEventStatusDenied = @"denied";
NSString * const MMEEventStatusRestricted = @"restricted";
NSString * const MMEEventStatusNotDetermined = @"notDetermined";
NSString * const MMEEventStatusAuthorizedAlways = @"always";
NSString * const MMEEventStatusAuthorizedWhenInUse = @"whenInUse";
NSString * const MMEEventUnknown = @"unknown";

NSString * const MMEVisionEventPrefix = @"vision.";

NSString * const MMENavigationEventPrefix = @"navigation.";
NSString * const MMEEventTypeNavigationDepart = @"navigation.depart";
NSString * const MMEEventTypeNavigationArrive = @"navigation.arrive";
NSString * const MMEEventTypeNavigationCancel = @"navigation.cancel";
NSString * const MMEEventTypeNavigationFeedback = @"navigation.feedback";
NSString * const MMEEventTypeNavigationReroute = @"navigation.reroute";
NSString * const MMEventTypeNavigationCarplayConnect = @"navigation.carplay.connect";
NSString * const MMEventTypeNavigationCarplayDisconnect = @"navigation.carplay.disconnect";

NSString * const MMESearchEventPrefix = @"search.";
NSString * const MMEEventTypeSearchSelected = @"search.selected";
NSString * const MMEEventTypeSearchFeedback = @"search.feedback";

NSString * const MMEEventSource = @"mapbox";

#pragma mark - mobile.crash events

NSString * const MMEEventMobileCrash = @"mobile.crash";
NSString * const MMEEventKeyOSVersion = @"osVersion";
NSString * const MMEEventKeyBuildType = @"buildType";
NSString * const MMEEventKeyIsSilentCrash = @"isSilent";
NSString * const MMEEventKeyStackTrace = @"stackTrace";
NSString * const MMEEventKeyStackTraceHash = @"stackTraceHash";
NSString * const MMEEventKeyInstallationId = @"installationID";
NSString * const MMEEventKeyThreadDetails = @"threadDetails";
NSString * const MMEEventKeyAppId = @"appId";
NSString * const MMEEventKeyAppVersion = @"appVersion";
NSString * const MMEEventKeyAppStartDate = @"appStartDate";
NSString * const MMEEventKeyCustomData = @"threadDetails";

#pragma mark - MMEErrorDomain

NSErrorDomain const MMEErrorDomain = @"MMEErrorDomain";

NSString * const MMEErrorEventAttributesKey = @"eventAttributes";
NSString * const MMEErrorUnderlyingExceptionKey = @"underlyingException";

#pragma mark - Deprecated

NSString * const MMEErrorDescriptionKey = @"errorDescription";
NSString * const MMEEventKeyVendorID = MMEEventKeyVendorId;
NSString * const MMEEventKeyInstallationID = MMEEventKeyInstallationId;
NSString * const MMEEventKeyAppID = MMEEventKeyAppId;

NSString * const MMELoggerHTML = @"<html><head><script type='text/javascript' src='https://www.gstatic.com/charts/loader.js'></script><script type='text/javascript'>google.charts.load('current', {'packages':['timeline']});var container = document.getElementById('timeline-tooltip');var dataString;function addData(data) {dataString = data}window.webkit.messageHandlers.data.postMessage('data');google.charts.setOnLoadCallback(drawChart); function drawChart() {var dataTable = new google.visualization.DataTable({cols: [{id: 'eventType', label: 'Event Type', type: 'string'},{id: 'instance', type: 'string'},{type: 'string', role: 'tooltip', p:{html:true}},{id: 'start', label: 'Event Start Time', type: 'datetime'},{id: 'end', label: 'Event End Time', type: 'datetime'}],rows: dataString});var options = {'title':'Telemetry Log Data','width':1024,'height':400,'timeline': { groupByRowLabel: true },tooltip: {isHtml: true}};var chart = new google.visualization.Timeline(document.getElementById('chart_div'));google.visualization.events.addListener(chart, 'ready', afterDraw);chart.draw(dataTable, options);}function afterDraw() {window.webkit.messageHandlers.complete.postMessage('complete');}</script></head><body><div id=\"timeline-tooltip\" style=\"height: 180px;\"></div><div id='chart_div'></div></body></html>";

NSString * const MMELoggerShareableHTML = @"<html><head><script type='text/javascript' src='https://www.gstatic.com/charts/loader.js'></script><script type='text/javascript'>google.charts.load('current', {'packages':['timeline']});var container = document.getElementById('timeline-tooltip');var dataString;function addData(data) {dataString = data};google.charts.setOnLoadCallback(drawChart); function drawChart() {var dataTable = new google.visualization.DataTable({cols: [{id: 'eventType', label: 'Event Type', type: 'string'},{id: 'instance', type: 'string'},{type: 'string', role: 'tooltip', p:{html:true}},{id: 'start', label: 'Event Start Time', type: 'datetime'},{id: 'end', label: 'Event End Time', type: 'datetime'}],rows: dataString});var options = {'title':'Telemetry Log Data','width':1024,'height':400,'timeline': { groupByRowLabel: true },tooltip: {isHtml: true}};var chart = new google.visualization.Timeline(document.getElementById('chart_div'));google.visualization.events.addListener(chart, 'ready', afterDraw);chart.draw(dataTable, options);}function afterDraw() {}</script></head><body><div id=\"timeline-tooltip\" style=\"height: 180px;\"></div><div id='chart_div'></div></body></html>";

NSString * const MMEEventKeyGestureId = @"gesture";
NSString * const MMEEventKeyGestureID = MMEEventKeyGestureId;
NSString * const MMEEventGestureSingleTap = @"SingleTap";
NSString * const MMEEventGestureDoubleTap = @"DoubleTap";
NSString * const MMEEventGestureTwoFingerSingleTap = @"TwoFingerTap";
NSString * const MMEEventGestureQuickZoom = @"QuickZoom";
NSString * const MMEEventGesturePanStart = @"Pan";
NSString * const MMEEventGesturePinchStart = @"Pinch";
NSString * const MMEEventGestureRotateStart = @"Rotation";
NSString * const MMEEventGesturePitchStart = @"Pitch";
NSString * const MMEEventTypeMapTap = @"map.click";
NSString * const MMEEventTypeMapDragEnd = @"map.dragend";
NSString * const MMEAPIClientBaseURL = MMEAPIClientBaseEventsURL;
