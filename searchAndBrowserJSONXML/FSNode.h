

#import <Cocoa/Cocoa.h>



// This is a simple wrapper around the file system. Its main purpose is to cache children.
@interface FSNode : NSObject {
@private
    NSString *_path;
    BOOL _didContainSub;
    NSMutableArray *_children;
    NSInteger _state;
    NSString *_decriptionString;
}

// The designated initializer
- (id)initWithPath:(NSString *)thePath didContainSub:(BOOL)didContainSub withString:(NSString *) strg;

@property(readonly, copy) NSString *path;
@property(readonly, copy) NSString *displayName;
@property NSInteger state;
@property(readonly) BOOL didContainSub;
@property(readonly, retain) NSMutableArray *children;
@property(nonatomic,copy) NSString *decriptionString;
-(void) addChildrenWithPath:(NSString *)thePath didContainSub:(BOOL) didContainSub withString:(NSString *)strg;
-(FSNode *) childForThePath:(NSArray *) pathString;
@end
