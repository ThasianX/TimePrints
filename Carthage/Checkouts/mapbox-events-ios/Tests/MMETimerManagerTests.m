@import XCTest;

#import "MMETimerManager.h"

@interface MMETimerManager (Test)
@property (nonatomic) NSTimer *timer;

@end

// MARK: -

@interface MMETimerManagerTests : XCTestCase
@property (nonatomic) XCTestExpectation *timerSelectorCompletionExpectation;

@end

// MARK: -

@implementation MMETimerManagerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testExample {
    self.timerSelectorCompletionExpectation = [self expectationWithDescription:@"It should message the selector"];
    
    MMETimerManager *timerManager = [[MMETimerManager alloc] initWithTimeInterval:1 target:self selector:@selector(workToDoWhenTimerCompletes)];
    [timerManager start];
    
    [self waitForExpectations:@[self.timerSelectorCompletionExpectation] timeout:10];
    
    [timerManager cancel];
    XCTAssertNil(timerManager.timer);
}

- (void)workToDoWhenTimerCompletes {
    [self.timerSelectorCompletionExpectation fulfill];
}

@end
