//
//  DJDrawing.h
//  123_6
//
//  Created by Michel Balamou on 20/04/2014.
//  Copyright (c) 2014 Michel Balamou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJDrawing : UIView
{
    bool main_menu;
    UIImage* MenuSprite;
    
    NSTimer *timer;
    
    bool first;
    UIImage* background;
    UIImage* panel;
    UIImage* pause;
    UIImage* Panel_Shadow;
    NSMutableArray* circles;
    NSMutableArray* map;
    
    
    int currentX;
    int currentY;
    
    bool touch;
    
    int EntireX;
    int EntireY;
    
    int xMap;
    int yMap;
    
    int xMap1;
    int yMap1;
    
    NSMutableArray* lines;
    NSMutableArray* lineTemp;
    
    NSMutableArray* combinations;
    NSMutableArray* path;
    
    int sum_num;
    
    int score;
    int best;
    
    NSString* typeOfAdding;
    NSDictionary* colors;
    
    UIFont* font;
    NSDictionary* TheFont;
    
    //Values
    int radius;
    int distance_b_circles;
    int circle_width;
    
    //Animation
    bool animation;
    NSMutableArray* frames;
    NSMutableArray* drawAnimation;
    
    //Pause_mode
    bool pause_mode;
    UIImage* pauseMenu;
    
    
    //Game over mode
    bool game_over;
 
    UIImage* GameOverSprite;
}

- (void)Initialization;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)Reload;

//Graphics
- (void)DrawText:(NSString*)text FontName:(NSString*)_font Xpos:(int)_Xpos Ypos:(int)_Ypos Color:(UIColor*)_Color Size:(float)_size;
- (void)DrawCircle:(CGRect)Rect Stroke:(int)_SWidth FillColor:(UIColor*)_FColor StrokeColor:(UIColor*)_SColor;

@end
