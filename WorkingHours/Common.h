//
//  Common.h
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 18/08/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//

#ifndef WorkingHours_Common_h
#define WorkingHours_Common_h

#define NUMBER_YES [NSNumber numberWithBool:YES]
#define NUMBER_NO [NSNumber numberWithBool:NO]

static inline BOOL isEmpty(id thing) {
    return thing == nil
    || [thing isKindOfClass:[NSNull class]]
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}

///////////////////////////////////////
// Global user interface constants 
//
#define GLOBAL_CELL_SELECTION_STYLE UITableViewCellSelectionStyleGray

#endif

