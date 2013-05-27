//
//  AppDelegate.m
//  searchAndBrowserJSONXML
//
//  Created by isletsystems on 11/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#define  kXMLUrlList @"JsonUrlList"
#define  kJSONUrlList @"XmlUrlList"

@implementation AppDelegate
@synthesize txtBoxXmlUrlList = _txtBoxXmlUrlList;
@synthesize txtBoxJsonList = _txtBoxJsonList;
@synthesize xmlUrlComboBox = _xmlUrlComboBox;
@synthesize xmlProgressIndicator = _xmlProgressIndicator;
@synthesize xmlInputText = _xmlInputText;
@synthesize xmlOutText = _xmlOutText;
@synthesize xmlBrowser = _xmlBrowser;

@synthesize jsonUrlComboBox = _jsonUrlComboBox;
@synthesize jsonProgressIndicator = _jsonProgressIndicator;
@synthesize jsonInputText = _jsonInputText;
@synthesize jsonOutText = _jsonOutText;
@synthesize jsonBrowser = _jsonBrowser;

@synthesize window = _window;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize managedObjectContext = __managedObjectContext;




- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    xmlUrlList=[NSMutableArray arrayWithArray: [[NSUserDefaults standardUserDefaults] arrayForKey:kXMLUrlList]];
    JsonUrlList=[NSMutableArray arrayWithArray: [[NSUserDefaults standardUserDefaults] arrayForKey:kJSONUrlList]];
    
    if (!xmlUrlList) {
        xmlUrlList=[[NSMutableArray alloc] init];
        [[NSUserDefaults standardUserDefaults] setObject:xmlUrlList forKey:kXMLUrlList];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [_xmlBrowser setColumnResizingType:NSBrowserUserColumnResizing];
    _XmlRootNode = nil;
    if (!JsonUrlList) {
        JsonUrlList=[[NSMutableArray alloc] init];
        [[NSUserDefaults standardUserDefaults] setObject:JsonUrlList forKey:kJSONUrlList];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [_jsonBrowser setColumnResizingType:NSBrowserUserColumnResizing];
    _JsonRootNode = nil;
    

    // Insert code here to initialize your application
}
#pragma Mark URL manager Button clicks
- (IBAction)saveURLs:(id)sender {
    NSArray * urlList;
    urlList=[self.txtBoxXmlUrlList.string componentsSeparatedByString:@"\n"];
    [xmlUrlList removeAllObjects];
    for (NSString * st in urlList) {
        if (st) {
            if (![[st stringByReplacingOccurrencesOfString:@"\r" withString:@""] isEqualTo:@""]) {
                [xmlUrlList addObject:st];
            }
        }
        
    }
    [[NSUserDefaults standardUserDefaults] setObject:xmlUrlList forKey:kXMLUrlList];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    urlList=[self.txtBoxJsonList.string componentsSeparatedByString:@"\n"];
    [JsonUrlList removeAllObjects];
    for (NSString * st in urlList) {
        if (st) {
            if (![[st stringByReplacingOccurrencesOfString:@"\r" withString:@""] isEqualTo:@""]) {
                    [JsonUrlList addObject:st];
            }
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:JsonUrlList forKey:kJSONUrlList];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}

- (IBAction)loadURLs:(id)sender {
    self.txtBoxJsonList.string=@"";
    self.txtBoxXmlUrlList.string=@"";
    for (NSString * ur in xmlUrlList) {
        [self.txtBoxXmlUrlList setString:[NSString stringWithFormat:@"%@%@\n\r",self.txtBoxXmlUrlList.string, ur]];
    }
    for (NSString * ur in JsonUrlList) {
        [self.txtBoxJsonList setString:[NSString stringWithFormat:@"%@%@\n\r",self.txtBoxJsonList.string, ur]];
    }
    
}

#pragma Mark Json Button clicks
- (IBAction)clickedJsonBrowser:(NSBrowser *)sender
{
    NSArray * paths=[sender.path componentsSeparatedByString:@"/"] ;
    NSMutableArray * pth=[[NSMutableArray alloc] init];
    int i=0;
    for (i=1; i<[paths count]; i++) {
        [pth addObject:[paths objectAtIndex:i]];
    }
    
    FSNode *chld=[_JsonRootNode childForThePath:pth];
    self.jsonOutText.string=[chld decriptionString] ;
    
}
- (IBAction)JsonProcessBtnClicked:(id)sender
{
    NSError* error;
    json = [NSJSONSerialization 
            JSONObjectWithData:[self.jsonInputText.string dataUsingEncoding:NSStringEncodingConversionAllowLossy]
            options:0 
            error:&error];
    if (error) {
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:[NSString stringWithFormat:@"Error:- %@",error.description]];
        [alert runModal];
        
        //NSLog(@"err : %@",[error description]);
    }
    else {
        
        [self loadBrowserJsonChildren];
        [_jsonBrowser loadColumnZero];
    }

    
}

- (IBAction)loadJsonUrlBottonClick:(id)sender
{
    if (self.jsonUrlComboBox.stringValue) {
        NSString *url2Search=self.jsonUrlComboBox.stringValue;
        if (![JsonUrlList containsObject:url2Search]) {
            [JsonUrlList addObject:url2Search];
            [[NSUserDefaults standardUserDefaults] setObject:JsonUrlList forKey:kJSONUrlList];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [self.jsonProgressIndicator startAnimation:@"hello"];
        NSURL *url = [[NSURL alloc] initWithString:url2Search];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (data) {
                self.jsonInputText.string = [[NSString alloc] initWithData:data
                                                                 encoding:NSUTF8StringEncoding];  // note the retain count here.
                [self.jsonProgressIndicator stopAnimation:@"hello"];
            } else {
                NSAlert *alert = [[NSAlert alloc] init];
                [alert setMessageText:[NSString stringWithFormat:@"Error:- %@",error.localizedDescription]];
                [alert runModal];
                
                [self.jsonProgressIndicator stopAnimation:@"hello"];
            }
        }
         ];
    }
 
}

#pragma Mark
#pragma JSON Phrasing


- (void) loadBrowserJsonChildren
{
    _JsonRootNode=nil;
    _JsonRootNode=[[FSNode alloc] initWithPath:@"/" didContainSub:YES withString:json.description];
    if ([json isKindOfClass:[NSDictionary class]]) {
        for (NSString * ky in json.allKeys) {
            [_JsonRootNode addChildrenWithPath:ky didContainSub:NO withString:[json objectForKey:ky]];
        }
    }
    else if ([json isKindOfClass:[NSArray class]])
    {
        int i;
        NSArray *tmpArr=(NSArray *)json;
        for (i=0; i<[tmpArr count]; i++) {
            [_JsonRootNode addChildrenWithPath:[NSString stringWithFormat:@"Object_%d",i] didContainSub:NO withString:[tmpArr objectAtIndex:i]];
        }
    }
    


    
}

#pragma Mark
#pragma Xml Phrasing


- (void)parseXMLFileAtURL:(NSString *)xmlString
{
    
    
    xmlFile=xmlString;    
    xmlArticles = [[NSMutableArray alloc] init];
    errorParsing=NO;
    
    NSError *error;
    xmlitem=[XMLReader dictionaryForXMLString:xmlFile error:&error];
    if (error) {
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:[NSString stringWithFormat:@"Error:- %@ \n\r %@",error.localizedDescription,error.localizedRecoverySuggestion]];
        [alert runModal];
        
        //NSLog(@"err : %@",[error description]);
        errorParsing=YES;
    }
   

    if (xmlitem.count<1) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Not a valid XML"];
        [alert runModal];
    }
    
     
    
}

#pragma Mark
#pragma button clicks



- (IBAction)loadXmlUrlBottonClick:(id)sender {
    
    if (self.xmlUrlComboBox.stringValue) {
        NSString *url2Search=self.xmlUrlComboBox.stringValue;
        if (![xmlUrlList containsObject:url2Search]) {
            [xmlUrlList addObject:url2Search];
            [[NSUserDefaults standardUserDefaults] setObject:xmlUrlList forKey:kXMLUrlList];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [self.xmlProgressIndicator startAnimation:@"hello"];
        NSURL *url = [[NSURL alloc] initWithString:url2Search];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (data) {
                self.xmlInputText.string = [[NSString alloc] initWithData:data
                                                                 encoding:NSUTF8StringEncoding];  // note the retain count here.
                [self.xmlProgressIndicator stopAnimation:@"hello"];
            } else {
                NSAlert *alert = [[NSAlert alloc] init];
                [alert setMessageText:[NSString stringWithFormat:@"Error:- %@",error.localizedDescription]];
                [alert runModal];
                
                [self.xmlProgressIndicator stopAnimation:@"hello"];
            }
        }
         ];
    }
    
}



- (IBAction)xmlProcessBtnClicked:(id)sender {
        [self parseXMLFileAtURL:self.xmlInputText.string];
    
    if (errorParsing) {
        
        //NSLog(@"err : %@",[error description]);
    }
    else {
        
        [self loadBrowserXmlChildren];
        [_xmlBrowser loadColumnZero];
    }
    
}
#pragma Mark
#pragma mark ComboxDelegate
// ==========================================================
// Combo box data source methods
// ==========================================================

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox {
    if ([aComboBox isEqualTo:_xmlUrlComboBox]) {
        
        return [xmlUrlList count];
        
    }
    else 
    {
        return [JsonUrlList count];
    }
    return 0;
}
- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)loc {
    if ([aComboBox isEqualTo:_xmlUrlComboBox]) {
        return [xmlUrlList objectAtIndex:loc];
    }
    else {
        return [JsonUrlList objectAtIndex:loc];
    }
    return nil;
}
- (NSUInteger)comboBox:(NSComboBox *)aComboBox indexOfItemWithStringValue:(NSString *)string {
    
    if ([aComboBox isEqualTo:_xmlUrlComboBox]) {
        return [xmlUrlList indexOfObject: string];
    }
    else {
        return [JsonUrlList indexOfObject: string];
    }
    return 0;

}

- (NSString *) firstGenreMatchingPrefix:(NSString *)prefix {
    NSString *string = nil;
    NSString *lowercasePrefix = [prefix lowercaseString];
    NSEnumerator *stringEnum = [xmlUrlList objectEnumerator];
    while ((string = [stringEnum nextObject])) {
        if ([[string lowercaseString] hasPrefix: lowercasePrefix]) return string;
    }
    return nil;
}

- (NSString *)comboBox:(NSComboBox *)aComboBox completedString:(NSString *)inputString {
    // This method is received after each character typed by the user, because we have checked the "completes" flag for genreComboBox in IB.
    // Given the inputString the user has typed, see if we can find a genre with the prefix, and return it as the suggested complete string.
    NSString *candidate = [self firstGenreMatchingPrefix: inputString];
    return (candidate ? candidate : inputString);
}

#pragma Mark
#pragma Browser Delegate
#pragma mark NSBrowserDelegate
- (id)rootItemForBrowser:(NSBrowser *)browser {
    if ([browser isEqualTo:self.jsonBrowser]) {
        return _JsonRootNode;
    }
    else if ([browser isEqualTo:self.xmlBrowser]) {
          return _XmlRootNode; 
    }
    return nil;
}
- (NSInteger)browser:(NSBrowser *)browser numberOfChildrenOfItem:(id)item {

    return [[(FSNode *)item children] count];
}
- (id)browser:(NSBrowser *)browser child:(NSInteger)index ofItem:(id)item {
    return [[(FSNode *)item children] objectAtIndex:index];
}
- (BOOL)browser:(NSBrowser *)browser isLeafItem:(id)item {
    return ![(FSNode *)item didContainSub];
}
- (id)browser:(NSBrowser *)browser objectValueForItem:(id)item {
    return [(FSNode *)item displayName];
}

-(void)browser:(NSBrowser *)sender willDisplayCell:(id)cell atRow:(NSInteger)row column:(NSInteger)column {
    NSIndexPath *indexPath = [sender indexPathForColumn:column];
    indexPath = [indexPath indexPathByAddingIndex:row];
    FSNode *node = [sender itemAtIndexPath:indexPath];
    [cell setTitle:[node displayName]];
    [cell setState:[node state]];
}
- (IBAction)clickedXmlBrowser:(NSBrowser *)sender {
    NSArray * paths=[sender.path componentsSeparatedByString:@"/"] ;
    NSMutableArray * pth=[[NSMutableArray alloc] init];
    int i=0;
    for (i=1; i<[paths count]; i++) {
        [pth addObject:[paths objectAtIndex:i]];
    }
    if ([sender isEqualTo:self.jsonBrowser]) {
        FSNode *chld=[_JsonRootNode childForThePath:pth];
        self.jsonOutText.string=[chld decriptionString] ;
    }
    else if ([sender isEqualTo:self.xmlBrowser]) {
        FSNode *chld=[_XmlRootNode childForThePath:pth];
        self.xmlOutText.string=[chld decriptionString] ;
    }
    
}
- (void) loadBrowserXmlChildren
{
    _XmlRootNode=nil;
    _XmlRootNode=[[FSNode alloc] initWithPath:@"/" didContainSub:YES withString:xmlitem.description];
    if ([xmlitem isKindOfClass:[NSDictionary class]]) {
        for (NSString * ky in xmlitem.allKeys) {
            [_XmlRootNode addChildrenWithPath:ky didContainSub:NO withString:[xmlitem objectForKey:ky]];
        }
    }
    else if ([xmlitem isKindOfClass:[NSArray class]])
    {
        int i;
        NSArray *tmpArr=(NSArray *)xmlitem;
        for (i=0; i<[tmpArr count]; i++) {
            [_XmlRootNode addChildrenWithPath:[NSString stringWithFormat:@"Object_%d",i] didContainSub:NO withString:[tmpArr objectAtIndex:i]];
        }
    }
}




@end
