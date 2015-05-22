//
//  ArchiveFile.h
//  Ucard
//
//  Created by Ucard on 14-3-13.
//  Copyright (c) 2014年 Orange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArchiveFile : NSObject

+ (void)archiveDocumentWithRootObject:(NSMutableArray *)brr FileName:(const NSString *)name;

+ (NSMutableArray *)readDocumentWithFileName:(const NSString *)name;

+ (NSArray *)getFilelistFromDocument;

@end
