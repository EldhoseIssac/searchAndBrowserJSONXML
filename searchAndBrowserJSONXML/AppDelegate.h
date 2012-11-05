//
//  AppDelegate.h
//  searchAndBrowserJSONXML
//
//  Created by isletsystems on 11/10/12.
//  Copyright (c) 2012 Islet Systems All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FSNode.h"
#import "XMLReader.h"

@interface AppDelegate : NSObject <NSApplicationDelegate,NSXMLParserDelegate,NSComboBoxDelegate,NSComboBoxDataSource,NSBrowserDelegate>

{

    BOOL errorParsing;
    NSError *__autoreleasing *errorPointer;
    
    NSMutableArray *JsonUrlList;
    FSNode *_JsonRootNode;
    NSDictionary* json;
    
    NSMutableArray *xmlUrlList;
    FSNode *_XmlRootNode;
    NSString *xmlFile;
    NSMutableArray *xmlArticles;
    NSDictionary *xmlitem;
}


@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;


#pragma Mark XmlTab Objects and messages
@property (weak) IBOutlet NSComboBox *xmlUrlComboBox;
@property (weak) IBOutlet NSProgressIndicator *xmlProgressIndicator;
@property (strong) IBOutlet NSTextView *xmlInputText;
@property (strong) IBOutlet NSTextView *xmlOutText;
@property (strong) IBOutlet NSBrowser *xmlBrowser;


- (void)parseXMLFileAtURL:(NSString *)xmlString;
- (IBAction)clickedXmlBrowser:(NSBrowser *)sender;
- (IBAction)xmlProcessBtnClicked:(id)sender;
- (void) loadBrowserXmlChildren;
- (IBAction)loadXmlUrlBottonClick:(id)sender;
- (IBAction)btnXMLGeneratorClicked:(NSButton *)sender;


#pragma Mark JSON Tab Objects and messages



@property (weak) IBOutlet NSComboBox *jsonUrlComboBox;
@property (weak) IBOutlet NSProgressIndicator *jsonProgressIndicator;
@property (strong) IBOutlet NSTextView *jsonInputText;
@property (strong) IBOutlet NSTextView *jsonOutText;
@property (strong) IBOutlet NSBrowser *jsonBrowser;


- (IBAction)clickedJsonBrowser:(NSBrowser *)sender;
- (IBAction)JsonProcessBtnClicked:(id)sender;
- (void) loadBrowserJsonChildren;
- (IBAction)loadJsonUrlBottonClick:(id)sender;
- (IBAction)btnJSONGeneratorClicked:(NSButton *)sender;

#pragma Mark URL List Tab Objects and messages



- (IBAction)saveURLs:(id)sender;
- (IBAction)loadURLs:(id)sender;

@property (unsafe_unretained) IBOutlet NSTextView *txtBoxXmlUrlList;
@property (unsafe_unretained) IBOutlet NSTextView *txtBoxJsonList;


@end
