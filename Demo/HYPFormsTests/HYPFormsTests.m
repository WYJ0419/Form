@import UIKit;
@import XCTest;

#import "HYPForm.h"
#import "HYPFormField.h"
#import "HYPFormTarget.h"
#import "HYPFormsCollectionViewDataSource.h"

@interface HYPFormsTests : XCTestCase

@property (nonatomic, strong) HYPFormsCollectionViewDataSource *dataSource;

@end

@implementation HYPFormsTests

- (void)setUp
{
    [super setUp];

    HYPFormsLayout *layout = [[HYPFormsLayout alloc] init];

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:[[UIScreen mainScreen] bounds] collectionViewLayout:layout];

    self.dataSource = [[HYPFormsCollectionViewDataSource alloc] initWithCollectionView:collectionView andDictionary:nil disabledFieldsIDs:nil disabled:NO];
}

- (void)tearDown
{
    [super tearDown];

    self.dataSource = nil;
}

- (void)testFieldWithID
{
    HYPFormField *field = [HYPFormField fieldWithID:@"first_name" inForms:self.dataSource.forms withIndexPath:NO];
    XCTAssertEqualObjects(field.fieldID, @"first_name");

    [field sectionAndIndexInForms:self.dataSource.forms completion:^(BOOL found, HYPFormSection *section, NSInteger index) {
        if (found) {
            [section.fields removeObjectAtIndex:index];
        }
    }];

    field = [HYPFormField fieldWithID:@"first_name" inForms:self.dataSource.forms withIndexPath:NO];
    XCTAssertNil(field);
}

- (void)testIndexInForms
{
    [self.dataSource processTarget:[HYPFormTarget hideFieldTargetWithID:@"postal_code"]];
    [self.dataSource processTarget:[HYPFormTarget showFieldTargetWithID:@"postal_code"]];
    HYPFormField *field = [HYPFormField fieldWithID:@"postal_code" inForms:self.dataSource.forms withIndexPath:NO];
    NSUInteger index = [field indexInForms:self.dataSource.forms];
    XCTAssertEqual(index, 6);

    [self.dataSource processTarget:[HYPFormTarget hideFieldTargetWithID:@"image"]];
    [self.dataSource processTarget:[HYPFormTarget showFieldTargetWithID:@"image"]];
    field = [HYPFormField fieldWithID:@"image" inForms:self.dataSource.forms withIndexPath:NO];
    index = [field indexInForms:self.dataSource.forms];
    XCTAssertEqual(index, 11);

    [self.dataSource processTargets:[HYPFormTarget hideFieldTargetsWithIDs:@[@"first_name", @"address", @"image"]]];
    [self.dataSource processTarget:[HYPFormTarget showFieldTargetWithID:@"image"]];
    field = [HYPFormField fieldWithID:@"image" inForms:self.dataSource.forms withIndexPath:NO];
    index = [field indexInForms:self.dataSource.forms];
    XCTAssertEqual(index, 9);
    [self.dataSource processTargets:[HYPFormTarget showFieldTargetsWithIDs:@[@"first_name", @"address"]]];

    [self.dataSource processTargets:[HYPFormTarget hideFieldTargetsWithIDs:@[@"last_name", @"address"]]];
    [self.dataSource processTarget:[HYPFormTarget showFieldTargetWithID:@"address"]];
    field = [HYPFormField fieldWithID:@"address" inForms:self.dataSource.forms withIndexPath:NO];
    index = [field indexInForms:self.dataSource.forms];
    XCTAssertEqual(index, 4);
    [self.dataSource processTarget:[HYPFormTarget showFieldTargetWithID:@"last_name"]];
}

@end
