//
//  Header.h
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-22.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

#define NSStringize_helper(x) #x
#define NSStringize(x) @NSStringize_helper(x)

#define URLForFixuture(fixture) \
    [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:8080/%@", fixture]]