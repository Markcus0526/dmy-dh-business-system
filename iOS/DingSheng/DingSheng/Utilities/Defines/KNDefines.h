//
//  KNDefines.h
//  EverAfter
//
//  Created by Franck De Girolami on 5/24/13.
//  Copyright (c) 2013 EverAfter. All rights reserved.
//

#ifndef EverAfter_KNDefines_h
#define EverAfter_KNDefines_h

//#define TRY_CATCH(x) @try { x } @catch (NSException* e) {}
//
#define ASSIGN_IF_EXISTS(field,value) @try { if ((value) != nil) { field = value; } } @catch (NSException* e) {}
#define TEST_AND_ASSIGN_IF_EXISTS(test_value,field,value) @try { if ((test_value) != nil) { field = value; } } @catch (NSException* e) {}

#ifdef DEBUG
#define DebugNSLog  NSLog
#else
#define DebugNSLog(s,...)
#endif

#endif
