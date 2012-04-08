//
//  SynthesizeSingleton.h
//  CocoaWithLove
//
//  Created by Matt Gallagher on 20/10/08.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file without charge in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#define SYNTHESIZE_SINGLETON_FOR_CLASS_WITH_CUSTOM_METHOD_NAME(classname, methodname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)methodname \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [[self alloc] init]; \
} \
} \
\
return shared##classname; \
}

#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
SYNTHESIZE_SINGLETON_FOR_CLASS_WITH_CUSTOM_METHOD_NAME(classname, shared##classname)
