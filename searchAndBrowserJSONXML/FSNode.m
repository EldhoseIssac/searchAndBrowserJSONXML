

#import "FSNode.h"

@implementation FSNode
@synthesize path = _path, state = _state, didContainSub = _didContainSub;
@dynamic displayName, children,decriptionString;
- (id)initWithPath:(NSString *)thePath didContainSub:(BOOL)didContainSub withString:(NSString *) strg;
{    if (self = [super init]) {
        _path = thePath ;
        _didContainSub = didContainSub;
        self.decriptionString=strg;
    }
    return self;
}
- (void)dealloc {
    _path=nil;
    _children=nil;
    _decriptionString=nil;
}
- (NSString *)displayName {
    return [_path lastPathComponent];
}
- (NSArray *)children {
    
    return _children;
}
-(void) setDecriptionString:(NSObject *)decString
{

    if ([decString isKindOfClass:[NSString class]]) {
         _decriptionString=[decString description];
        _didContainSub=NO;
    }
    else if([decString isKindOfClass:[NSDictionary class]]){
       
        _decriptionString=[decString description];
        NSDictionary *dic=(NSDictionary *) decString;
        for (NSString *ky in [dic allKeys]) {
            [self addChildrenWithPath:ky didContainSub:NO withString:[dic objectForKey:ky]];
        }
        _didContainSub=YES;
    }
    else if ([decString isKindOfClass:[NSArray class]]) {
        _decriptionString=[decString description];
        NSArray *arr=(NSArray *) decString;
        int i=0;
        for (i=0; i<[arr count]; i++) {
            [self addChildrenWithPath:[NSString stringWithFormat:@"%@_%d",_path,i]  didContainSub:NO withString:[arr objectAtIndex:i]];
            
        }
        _didContainSub=YES;
    }
    else {
        _decriptionString=[decString description];
        _didContainSub=NO;
    }
    
    
}
-(NSString *)decriptionString
{
    return _decriptionString;
}
-(void) addChildrenWithPath:(NSString *)thePath didContainSub:(BOOL) didContainSub withString:(NSString *)strg
{
    if (_children==nil) {
        _children=[[NSMutableArray alloc] init];
    }
    FSNode *nod=[[FSNode alloc] initWithPath:thePath didContainSub:didContainSub withString:strg];
    [_children addObject:nod];
}
-(FSNode *) childForThePath:(NSArray *) pathString
{
    if ([pathString count]<1) {
        return nil;
    }
    else if (pathString.count==1) {
        for ( FSNode *retNode in self.children) {
            if ([[pathString objectAtIndex:0] isEqualToString: [retNode displayName]]) {
                return retNode;
            }
        }
        return nil;
    }
    else {
        NSMutableArray * nwPath=[[NSMutableArray alloc] init];
        int i;
        for (i=1; i<[pathString count]; i++) {
            [nwPath addObject:[pathString objectAtIndex:i]];
        }
        
        for ( FSNode *retNode in self.children) {
            if ([[pathString objectAtIndex:0] isEqualToString: [retNode displayName]]) {
                return [retNode childForThePath:nwPath];
            }
        }
        return nil;
        
        
    }
    return nil;
}

@end
