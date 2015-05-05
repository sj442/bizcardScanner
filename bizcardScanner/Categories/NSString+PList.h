//
//  NSString+PList.h
//  Conquer
//
//  Created by Leo Reubelt on 3/31/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString PListKey;

static PListKey *PLFilter = @"filter";
static PListKey *PLRequired = @"required";
static PListKey *PLPassword = @"password";
static PListKey *PLvalue = @"value";
static PListKey *PLfailed = @"failed";
static PListKey *PLinput = @"input";
static PListKey *PLsetting = @"setting";
static PListKey *PLinfo = @"info";
static PListKey *PLassignee = @"assignee";
static PListKey *PLprice = @"price";
static PListKey *PLget = @"get";
static PListKey *PLevent = @"event";
static PListKey *PLweb = @"web";
static PListKey *PLcustom = @"custom";
static PListKey *PLqualifier = @"qualifier";
static PListKey *PLdue = @"due";
static PListKey *PLnet = @"net";
static PListKey *PLactivity = @"activity";
static PListKey *PLproduct = @"product";
static PListKey *PLaccount = @"account";
static PListKey *PLunavailable = @"unavailable";
static PListKey *PLscanner = @"scanner";
static PListKey *PLunit = @"unit";
static PListKey *PLmonth = @"month";
static PListKey *PLin = @"in";
static PListKey *PLincomplete = @"incomplete";
static PListKey *PLtype = @"type";
static PListKey *PLmissing = @"missing";
static PListKey *PLtitle = @"title";
static PListKey *PLdelete = @"delete";
static PListKey *PLlead = @"lead";
static PListKey *PLcode = @"code";
static PListKey *PLupdate = @"update";
static PListKey *PLmarket = @"market";
static PListKey *PLdate = @"date";
static PListKey *PLstreet = @"street";
static PListKey *PLphoneNumber = @"phone_number";
static PListKey *PLnot = @"not";
static PListKey *PLdiscount = @"discount";
static PListKey *PLbarCode = @"bar_code";
static PListKey *PLissue = @"issue";
static PListKey *PLselect = @"select";
static PListKey *PLtask = @"task";
static PListKey *PLyes = @"yes";
static PListKey *PLbio = @"bio";
static PListKey *PLprocessing = @"processing";
static PListKey *PLbadge = @"badge";
static PListKey *PLstage = @"stage";
static PListKey *PLform = @"form";
static PListKey *PLrequest = @"request";
static PListKey *PLcontact = @"contact";
static PListKey *PLyear = @"year";
static PListKey *PLlist = @"list";
static PListKey *PLexport = @"export";
static PListKey *PLscan = @"scan";
static PListKey *PLnews = @"news";
static PListKey *PLcity = @"city";
static PListKey *PLjob = @"job";
static PListKey *PLqualified = @"qualified";
static PListKey *PLsave = @"save";
static PListKey *PLforecast = @"forecast";
static PListKey *PLscore = @"score";
static PListKey *PLconquer = @"conquer";
static PListKey *PLsign = @"sign";
static PListKey *PLaccess = @"access";
static PListKey *PLtag = @"tag";
static PListKey *PLadd = @"add";
static PListKey *PLaddress = @"address";
static PListKey *PLall = @"all";
static PListKey *PLerror = @"error";
static PListKey *PLemail = @"email";
static PListKey *PLstate = @"state";
static PListKey *PLsuccessfully = @"successfully";
static PListKey *PLmember = @"member";
static PListKey *PLcomplete = @"complete";
static PListKey *PLgroup = @"group";
static PListKey *PLclosed = @"closed";
static PListKey *PLfield = @"field";
static PListKey *PLplease = @"please";
static PListKey *PLuser = @"user";
static PListKey *PLimage = @"image";
static PListKey *PLup = @"up";
static PListKey *PLnote = @"note";
static PListKey *PLurl = @"url";
static PListKey *PLname = @"name";
static PListKey *PLtext = @"text";
static PListKey *PLalert = @"alert";
static PListKey *PLcreate = @"create";
static PListKey *PLyesterday = @"yesterday";
static PListKey *PLedit = @"edit";
static PListKey *PLbusiness_card = @"business_card";
static PListKey *PLassign = @"assign";
static PListKey *PLpipeline = @"pipeline";
static PListKey *PLlink = @"link";
static PListKey *PLcategory = @"category";
static PListKey *PLopportunity = @"opportunity";
static PListKey *PLcompany = @"company";
static PListKey *PLtomorrow = @"tomorrow";
static PListKey *PLfirst = @"first";
static PListKey *PLcancel = @"cancel";
static PListKey *PLstatus = @"status";
static PListKey *PLno = @"no";
static PListKey *PLquarter = @"quarter";
static PListKey *PLzipCode = @"zip_code";
static PListKey *PLcall = @"call";
static PListKey *PLtoday = @"today";
static PListKey *PLok = @"ok";
static PListKey *PLcamera = @"camera";
static PListKey *PLmessage = @"message";
static PListKey *PLreport = @"report";
static PListKey *PLchoose = @"choose";
static PListKey *PLout = @"out";
static PListKey *PLsuite = @"suite";
static PListKey *PLend = @"end";
static PListKey *PLlast = @"last";
static PListKey *PLtarget = @"target";
static PListKey *PLtotal = @"total";
static PListKey *PLqualify = @"qualify";
static PListKey *PLwith = @"with";
static PListKey *PLsend = @"send";
static PListKey *PLdone = @"done";
static PListKey *PLquota = @"quota";
static PListKey *PLchat = @"chat";
static PListKey *PLtime = @"time";
static PListKey *PLparticipant = @"participant";
static PListKey *PLstart = @"start";
static PListKey *PLsent = @"sent";
static PListKey *PLreset = @"reset";
static PListKey *PLsubmit = @"submit";
static PListKey *PLsql = @"sql";
static PListKey *PLclose = @"close";
static PListKey *PLnew = @"new";
static PListKey *PLmore = @"more";
static PListKey *PLNumOfUnits = @"numOfUnits";
static PListKey *PLNumber = @"number";
static PListKey *PLTrained = @"trained";
static PListKey *PLQualification = @"qualification";
static PListKey *PLCannibalized = @"cannibalized";
static PListKey *PLAnnual = @"annual";

@interface NSString (PList)

+ (NSString *)plistWouldYouLikeToAddA:(PListKey *)keyOne aboutYour:(PListKey *)keyTwo;

+ (NSString *)firsName;

+ (NSString *)lastName;

+ (NSString *)webLink;

+ (NSString *)webLinks;

#pragma mark - Public - Instance

- (NSString *)pluralWord;

- (NSString *)pleaseChooseAStringWithPlural:(BOOL)plural;

- (NSString *)noneYetString;

- (NSString *)pleaseInputString;

- (NSString *)isRequiredString;

@end
