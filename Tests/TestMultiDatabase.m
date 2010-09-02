//
//  TestMultiDatabase.m
//  SQLiteTests
//
//  Created by Samuel Sutch on 9/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GTMSenTestCase.h"
#import "SQLitePersistentObject.h"
#import "SQLiteInstanceManager.h"
#import "BasicData.h"


@interface SiloDatabase : SQLitePersistentObject
{
  NSString *iama;
}

@property(retain) NSString *ima;

@end


@implementation SiloDatabase

@synthesize ima;

+ (SQLiteInstanceManager *)manager
{
  static SQLiteInstanceManager *__manager = nil;
  if (!__manager) {
    __manager = [[SQLiteInstanceManager alloc] init];
    __manager.databaseName = @"silo.sqlite3";
  }
  return __manager;
}

@end


@interface TestMultiDatabase : SenTestCase
{
}

@end


@implementation TestMultiDatabase

- (void)setUp
{}

- (void)tearDown
{
  [[SiloDatabase manager] deleteDatabase];
}

- (void)testSeperateDatabase
{
  STAssertEqualStrings([[SiloDatabase manager] databaseName], @"silo.sqlite3", @"database name");
  SiloDatabase *d = [[SiloDatabase new] autorelease];
  d.ima = @"omgwtf";
  [d save];
  STAssertEquals([SiloDatabase count], 1, @"database count");
  [SQLitePersistentObject clearCache];
  SiloDatabase *d2 = (id)[SiloDatabase findFirstByCriteria:@"where ima='omgwtf'"];
  STAssertEquals(d2.pk, 1, @"refetch primary key");
}

@end
