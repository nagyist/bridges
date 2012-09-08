//
//  RiverNode.m
//  Cocos2DSimpleGame
//
//  Created by Zack Grossbart on 8/19/12.
//
//

#import "BridgeNode.h"
#import "BridgeColors.h"

@interface BridgeNode()
@property (readwrite) bool vertical;
@property (readwrite, retain) CCSprite *bridge;
@property (nonatomic, assign, getter=isCrossed, readwrite) bool crossed;
@property (nonatomic, assign, readwrite) int color;
@property (readwrite) LayerMgr *layerMgr;
@property (nonatomic, assign, readwrite) int tag;
@property (nonatomic, assign, readwrite) int coins;
@property (readwrite) int direction;
@end

@implementation BridgeNode

-(id) initWithOrient:(bool) vertical:(int) tag: (int) color:(LayerMgr*) layerMgr {
    self=[super init];
    return [self initWithOrientAndDir:vertical:NONE:tag:color:layerMgr];
}

-(id)initWithOrientAndDir: (bool)vertical:(int)dir: (int) tag:(int) color:(LayerMgr*) layerMgr {
    self=[super init];
    return [self initWithOrientAndDirAndCoins:vertical:NONE:tag:color:layerMgr:0];
}

-(id)initWithOrientAndDirAndCoins: (bool)vertical:(int)dir: (int) tag:(int) color:(LayerMgr*) layerMgr:(int)coins {
    if( (self=[super init] )) {
        self.layerMgr = layerMgr;
        self.tag = tag;
        self.color = color;
        self.vertical = vertical;
        self.direction = dir;
        
        [self setBridgeSprite:[CCSprite spriteWithSpriteFrameName:[self getSpriteName]]];
        
        self.coins = coins;
        
        if (self.coins > 0) {
            _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
            _label.text = [NSString stringWithFormat:@"%i", self.coins];
            _label.textColor = [UIColor blackColor];
            _label.backgroundColor = [UIColor lightGrayColor];
            _label.layer.cornerRadius = 6;
            _label.font = [UIFont fontWithName:@"Verdana" size: 11.0];
            _label.textAlignment = UITextAlignmentCenter;
            [_label sizeToFit];
            
            _label.frame = CGRectMake(0, 0, _label.frame.size.width + 6, _label.frame.size.height + 3);
        }
    }
    
    return self;
}

- (void) addSprite {
    [self.layerMgr addChildToSheet:self.bridge];
}

-(void)setBridgeSprite:(CCSprite*)bridge {
    self.bridge = bridge;
    self.bridge.tag = [self tag];
}

-(void)setBridgePosition:(CGPoint)p {
    self.bridge.position = ccp(p.x, p.y);
    if (_label != nil) {
        _label.frame = CGRectMake((p.x + (self.bridge.contentSize.width / 2)) - (_label.frame.size.width / 2), [LayerMgr normalizeYForControl:p.y] - ((self.bridge.contentSize.height / 2) + (_label.frame.size.height / 2)), _label.frame.size.width, _label.frame.size.height);
    }
}

-(CGPoint)getBridgePosition {
    return self.bridge.position;
}

- (void) undo {
    if (_label != nil) {
        self.coins++;
        _label.text = [NSString stringWithFormat:@"%i", self.coins];
    }
    
    if (self.crossed) {
        CCSpriteFrameCache* cache = [CCSpriteFrameCache sharedSpriteFrameCache];
        CCSpriteFrame* frame = [cache spriteFrameByName:[self getSpriteName]];
        [self.bridge setDisplayFrame:frame];
        
        self.crossed = false;
    }
    
}

-(NSString*)getSpriteName {
    if (self.vertical) {
        if (self.color == RED) {
            if (self.direction == UP) {
                return @"bridge_red_up.png";
            } else if (self.direction == DOWN) {
                return @"bridge_red_down.png";
            } else {
                return @"bridge_v_red.png";
            }
        } else if (self.color == BLUE) {
            if (self.direction == UP) {
                return @"bridge_blue_up.png";
            } else if (self.direction == DOWN) {
                return @"bridge_blue_down.png";
            } else {
                return @"bridge_v_blue.png";
            }
        } else if (self.color == GREEN) {
            if (self.direction == UP) {
                return @"bridge_green_up.png";
            } else if (self.direction == DOWN) {
                return @"bridge_green_down.png";
            } else {
                return @"bridge_v_green.png";
            }
        } else if (self.color == ORANGE) {
            if (self.direction == UP) {
                return @"bridge_orange_up.png";
            } else if (self.direction == DOWN) {
                return @"bridge_orange_down.png";
            } else {
                return @"bridge_v_orange.png";
            }
        } else {
            if (self.direction == UP) {
                return @"bridge_up.png";
            } else if (self.direction == DOWN) {
                return @"bridge_down.png";
            } else {
                return @"bridge_v.png";
            }
        }
    } else {
        if (self.color == RED) {
            if (self.direction == LEFT) {
                return @"bridge_red_left.png";
            } else if (self.direction == RIGHT) {
                return @"bridge_red_right.png";
            } else {
                return @"bridge_h_red.png";
            }
        } else if (self.color == BLUE) {
            if (self.direction == LEFT) {
                return @"bridge_blue_left.png";
            } else if (self.direction == RIGHT) {
                return @"bridge_blue_right.png";
            } else {
                return @"bridge_h_blue.png";
            }
        } else if (self.color == GREEN) {
            if (self.direction == LEFT) {
                return @"bridge_green_left.png";
            } else if (self.direction == RIGHT) {
                return @"bridge_green_right.png";
            } else {
                return @"bridge_h_green.png";
            }
        } else if (self.color == ORANGE) {
            if (self.direction == LEFT) {
                return @"bridge_orange_left.png";
            } else if (self.direction == RIGHT) {
                return @"bridge_orange_right.png";
            } else {
                return @"bridge_h_orange.png";
            }
        } else {
            if (self.direction == LEFT) {
                return @"bridge_left.png";
            } else if (self.direction == RIGHT) {
                return @"bridge_right.png";
            } else {
                return @"bridge_h.png";
            }
        }
    }
}

-(void)cross {
    
    if (self.coins > 0) {
        self.coins--;
        _label.text = [NSString stringWithFormat:@"%i", self.coins];
    }
    
    if (self.coins == 0 && !self.crossed) {
        CCSpriteFrameCache* cache = [CCSpriteFrameCache sharedSpriteFrameCache];
        CCSpriteFrame* frame;
        if (self.vertical) {
            frame = [cache spriteFrameByName:@"bridge_v_x.png"];
        } else {
            frame = [cache spriteFrameByName:@"bridge_h_x.png"];
        }
        [self.bridge setDisplayFrame:frame];
    }
    self.crossed = true;
}

-(NSArray*) controls {
    NSMutableArray *controls = [NSMutableArray arrayWithCapacity:1];
    if (_label != nil) {
        [controls addObject:_label];
    }
    return controls;
}

-(void)dealloc {
    
    if (_label != nil) {
        [_label dealloc];
    }
    
    [self.bridge dealloc];
    [super dealloc];
}

@end
