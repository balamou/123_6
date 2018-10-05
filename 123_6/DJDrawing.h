//
//  DJDrawing.h
//  123_6
//
//  Created by Michel Balamou on 20/04/2014.
//  Copyright (c) 2014 Michel Balamou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJSticker.h"
#import "Appirater.h"

@interface DJDrawing : UIView
{
    NSString* deviceType;
    
    CGPoint Cur;
    
    //bool main_menu;
    NSTimer *timer;
    
    bool first;
    
    NSString* scene_mode;
    
    //Main menu+++
    UIImage* MenuSprite;
    NSMutableArray* main_buttons;
    //Main menu---
    
    //PLAY+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    UIImage* panel;
    DJSticker* pause_button;
    UIImage* Panel_Shadow;
    int scorePanelY;
    int tutotialY;
    
    NSMutableArray* map; //The matrix which saves the data
    
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
    
    int diameter_animation;
    //PLAY-------------------------------------------------------------------------------------------------------------------
    
    

    
    //Pause_mode++++++
    UIImage* pauseMenu;
    NSMutableArray* Buttons;
    //Pause_mode------
    
    
    //Game over mode+++++++++++++++
    UIImage* GameOverSprite;
    
    DJSticker* replay_go;
    DJSticker* main_menu_go;
    
    bool GO_Animation;
    double alpha;
    //Game over mode---------------
    
    
    
    //Tutorial mode++++++++
    NSMutableArray* tutorial;
    int frame;
    DJSticker* t_play;
    
    CGPoint firstPosition;
    int DisplayX;
    bool transition;
    
    NSTimer* tutorialSwap;
    UIImage* indicators;
    UIImage* selected;
    bool FirstGame;
    //Tutorial mode--------
}

- (NSString *)platformRawString;
- (NSString *)platformNiceString;
- (void)Initialization;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)Reload:(bool)allow;
- (void)Swap;

//Graphics
- (void)DrawText:(NSString*)text FontName:(NSString*)_font Xpos:(int)_Xpos Ypos:(int)_Ypos Color:(UIColor*)_Color Size:(float)_size;
- (void)DrawCircle:(CGRect)Rect Stroke:(int)_SWidth FillColor:(UIColor*)_FColor StrokeColor:(UIColor*)_SColor;
- (void)GamePlayDraw;
- (void)MainMenuDraw;
- (int)getTextWidth:(NSString*)text FontName:(NSString*)_font Size:(float)_size;
- (void)checkForGameOver;
- (void)TutorialDraw;

//Rate
- (void)rate;
@end
