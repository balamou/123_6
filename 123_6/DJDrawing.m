//
//  DJDrawing.m
//  123_6
//
//  Created by Michel Balamou on 20/04/2014.
//  Copyright (c) 2014 Michel Balamou. All rights reserved.
//

#import "DJDrawing.h"
#include <sys/sysctl.h> // for line 31
#define rgb(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0  blue:b/255.0 alpha:1.0]
#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0  blue:b/255.0 alpha:a/255.0]

#define num(a) [NSNumber numberWithInt:a]
#define toInt(a) [a intValue]


@implementation DJDrawing

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (NSString *)platformRawString {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}
- (NSString *)platformNiceString {
    NSString *platform = [self platformRawString];
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad 1";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (4G,2)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (4G,3)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return platform;
}
-(void)Initialization
{
    deviceType = [self platformNiceString];
    
    scene_mode=@"Main menu";
    
    font = [UIFont fontWithName:@"Charcoal" size: 22.0];
    TheFont = [[NSDictionary alloc] initWithObjectsAndKeys: font, NSFontAttributeName,nil,NSForegroundColorAttributeName, nil];
 
    Cur=CGPointMake(-1, -1);
    
    //MAIN MENU++++++++++++++++++++++++++++++++++++++++++++++++
    MenuSprite=[UIImage imageNamed:@"Main_menu.png"];
    
    main_buttons=[NSMutableArray new];
    NSMutableArray* names=[NSMutableArray new];
    [names addObject:@"MPlay_button"];
    [names addObject:@"MRate_button"];
    [names addObject:@"MTutorial_button"];
    [names addObject:@"MLeaderboard_button"];
    
    for (int i=0;i<4;i++)
        [main_buttons addObject:[[DJSticker alloc]initWithClicked:[NSString stringWithFormat:@"%@.png",names[i]] Clicked:[NSString stringWithFormat:@"%@_clicked.png",names[i]] Pos:CGPointMake(45, 120+i*(60+20))]];
    
    
    //PLAY+++++++++++++++++++++++++++++++++++++++++++
    //NSArray* objects=[NSArray arrayWithObjects:rgb(63,153,105),rgb(192,87,10),rgb(18,66,100),rgb(146,40,87), nil];
    NSArray* objects=[NSArray arrayWithObjects:rgb(49,124,70),rgb(214,138,18),rgb(14,103,160),rgb(220,50,118), nil];
    NSArray* keys=[NSArray arrayWithObjects:num(1),num(2),num(3),num(4), nil];
    
    colors=[NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    

    panel=[UIImage imageNamed:@"Panel.png"];
    Panel_Shadow=[UIImage imageNamed:@"Panel_Shadow.png"];
    
    
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(countDownDuration) userInfo:nil repeats:YES];
    
    tutorialSwap = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(Swap) userInfo:nil repeats:YES];
    
    map=[NSMutableArray new];
    
    for(int i=0;i<16;i++)
        [map addObject:num(arc4random()%3+1)];
    
    
    touch=false;
    
    EntireX=25;
    tutotialY=0;
    scorePanelY=15;
    
    if ([deviceType isEqualToString:@"iPhone 4"] || [deviceType isEqualToString:@"iPhone 4S"])
    {
        EntireY=120;
        scorePanelY=15;
        tutotialY=0;
    }
    else
        if ([deviceType isEqualToString:@"iPhone 5"])
        {
            EntireY=180;
            scorePanelY=75;
            tutotialY=30;
        }
   
    pause_button=[[DJSticker alloc]initWithClicked:@"Pause.png" Clicked:@"Pause_clicked.png" Pos:CGPointMake(255, scorePanelY+10)];
    
    
    xMap=0;
    yMap=0;
    
    
    sum_num=0;
    
    score=0;
    
    typeOfAdding=@"";
    
    best=0;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    best=toInt([prefs objectForKey:@"Best"]);
    
    FirstGame=true;
    
    FirstGame=[prefs boolForKey:@"FirstGame"];
    
    if (FirstGame==NO)
    {
        scene_mode=@"Tutorial";
        [prefs setBool:true forKey:@"FirstGame"];
    }
    
    distance_b_circles=9;
    circle_width=59;
    radius=59/2;
    
    animation=false;
    
    diameter_animation=circle_width;
  
    
    //PAUSE++++++++++++++++++++++++++++
    pauseMenu=[UIImage imageNamed:@"Pause_menu.png"];
    
    Buttons=[NSMutableArray new];
    names=[NSMutableArray new];
    [names addObject:@"Continue_button"];
    [names addObject:@"Replay_button"];
    [names addObject:@"Rate_button"];
    [names addObject:@"HowToPlay_button"];
    
    for (int i=0;i<4;i++)
        [Buttons addObject:[[DJSticker alloc]initWithClicked:[NSString stringWithFormat:@"%@.png",names[i]] Clicked:[NSString stringWithFormat:@"%@_clicked.png",names[i]] Pos:CGPointMake(45, 120+i*(60+20))]];
    
    //GAME OVER++++++++++++++++++++++++
    GO_Animation=false;
    alpha=0.0;
    
    GameOverSprite=[UIImage imageNamed:@"Game_over.png"];
    replay_go=[[DJSticker alloc] initWithClicked:@"Replay_go_button.png" Clicked:@"Replay_go_button_clicked.png" Pos:CGPointMake(45, 300)];
    main_menu_go=[[DJSticker alloc] initWithClicked:@"Main_menu_go_button.png" Clicked:@"Main_menu_go_button_clicked.png" Pos:CGPointMake(45, 380)];
    
    //TUTORIAL++++++++++++++++++++++++
    tutorial=[NSMutableArray new];
    
    for (int i=0;i<5;i++)
        [tutorial addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Tutorial_%i.png",i+1]]];
    
    frame=0;
    
    t_play=[[DJSticker alloc] initWithClicked:@"T_play.png" Clicked:@"T_play_clicked.png" Pos:CGPointMake(46,tutotialY+287)];
    
    transition=false;
    
    indicators=[UIImage imageNamed:@"Indicators.png"];
    selected=[UIImage imageNamed:@"Selected.png"];
}






#pragma mark TIMER++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-(void)countDownDuration
{
if([scene_mode isEqualToString:@"Play"])
{
    bool clear=false;
    
    if (animation==true)
    {
        [map replaceObjectAtIndex:[[path lastObject] intValue] withObject:[NSNumber numberWithInt:sum_num]];
     
     
        if (diameter_animation-10>0)
            diameter_animation-=10;
        else
        {
            animation=false;
            clear=true;
            diameter_animation=circle_width;
        }
        
        [self setNeedsDisplay];
    }

        if (clear==true)
            [self Reload:true];
}
    
    

  
}

-(void)Swap
{
    //GAME OVER++++++++++++++++++++++
        if (GO_Animation==true)
        {
            if (alpha+(10)/255.0<=1)
                alpha+=(10)/255.0;
            else
            {
                GO_Animation=false;
                alpha=0.0;
            }
            
            [self setNeedsDisplay];
        }
    
    
    //TUTORIAL+++++++++++++++++
    if ([scene_mode isEqualToString:@"Tutorial"])
    {
        if (transition==true)
        {
            int inc=10; //Increment
            
            if (DisplayX+inc<0)
                DisplayX+=inc;
            else
                if (DisplayX-inc>0)
                    DisplayX-=inc;
                else
                {
                    DisplayX=0;
                    transition=false;
                }
            
            
            [self setNeedsDisplay];
        }
    }
}


#pragma mark USER INTERACTIONS+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *myTouch = [[touches allObjects] objectAtIndex: 0];
    CGPoint currentPos = [myTouch locationInView: self];
    Cur=[myTouch locationInView: self];
    
    currentX=currentPos.x;
    currentY=currentPos.y;
    
    
    if ([scene_mode isEqualToString:@"Main menu"])
    {
        [self setNeedsDisplay];
    }
    else
         if ([scene_mode isEqualToString:@"Game over"])
        {
             [self setNeedsDisplay];
        }
        else
            if ([scene_mode isEqualToString:@"Pause"])
            {
               [self setNeedsDisplay];
            }
            else
                if ([scene_mode isEqualToString:@"Play"])
                {
                    if (currentX>EntireX && currentX<EntireX+4*(circle_width+distance_b_circles)+circle_width)
                    {
                        if (currentY>EntireY && currentY<EntireY+4*(circle_width+distance_b_circles)+circle_width)
                        {
                            xMap=(currentX-EntireX)/(circle_width+distance_b_circles);
                            yMap=(currentY-EntireY)/(circle_width+distance_b_circles);
                            
                            if (xMap>=0 && xMap<4 && yMap>=0 && yMap<4)
                            {
                                sum_num=[map[xMap+4*yMap] intValue];
                                touch=true;
                            }
                            
                            [self setNeedsDisplay];
                        }
                    }
                    
                    
                    [self setNeedsDisplay];
                }
                else
                    if ([scene_mode isEqualToString:@"Tutorial"])
                    {
                        firstPosition=currentPos;
                        
                        [self setNeedsDisplay];
                    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([scene_mode isEqualToString:@"Play"])
    {
    UITouch *myTouch = [[touches allObjects] objectAtIndex: 0];
    CGPoint currentPos = [myTouch locationInView: self];
    
    int X1=currentPos.x;
    int Y1=currentPos.y;
    
    if (X1>EntireX && X1<EntireX+4*(circle_width+distance_b_circles)+circle_width)
    {
        if (Y1>EntireY && Y1<EntireY+4*(circle_width+distance_b_circles)+circle_width)
        {
            xMap1=(X1-EntireX)/(circle_width+distance_b_circles);
            yMap1=(Y1-EntireY)/(circle_width+distance_b_circles);
            
            
            if (xMap>=0 && xMap<4 && yMap>=0 && yMap<4)
            {
            lineTemp=[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:xMap*(circle_width+distance_b_circles)+radius+EntireX],[NSNumber numberWithInt:yMap*(circle_width+distance_b_circles)+radius+EntireY],[NSNumber numberWithInt:X1],[NSNumber numberWithInt:Y1], nil];
            }
            
            
            //Add line to the matrix+++
            if (xMap>=0 && xMap<4 && yMap>=0 && yMap<4 && xMap1>=0 && xMap1<4 && yMap1>=0 && yMap1<4)
            if(xMap==xMap1-1 || xMap==xMap1+1 || xMap==xMap1)
            {
                if(yMap==yMap1-1 || yMap==yMap1+1 || yMap==yMap1)
                {
                    if (xMap+4*yMap!=xMap1+4*yMap1) //If the coordinates in the map are not the same
                    {
                        int tempX=EntireX+xMap1*(circle_width+distance_b_circles)+radius;
                        int tempY=EntireY+yMap1*(circle_width+distance_b_circles)+radius;
                        
                        double distance=sqrt((tempX-X1)*(tempX-X1)+(tempY-Y1)*(tempY-Y1));
                        
                        
                        if (distance<=radius)
                        {
                        bool allow=false;
                        bool already_taken=false;
                        
                        //Check if the point is already connected+++
                        if (path!=nil)
                        for (int z=0;z<[path count];z++)
                        {
                            if ([path[z] intValue]==xMap1+4*yMap1)
                                already_taken=true;
                        }
                        //Check if the point is already connected---
                        
                        
                        if (already_taken==false)
                        {
                            
                        if ([map[xMap+4*yMap] intValue]==[map[xMap1+4*yMap1] intValue])
                        {
                            if ([typeOfAdding isEqualToString:@""])
                            {
                            typeOfAdding=@"Same";
                            allow=true;
                            }
                            else
                                if ([typeOfAdding isEqualToString:@"Same"])
                                    allow=true;
                            
                        }
                        else
                            if([map[xMap+4*yMap] intValue]==[map[xMap1+4*yMap1] intValue]-1)
                            {
                                if ([typeOfAdding isEqualToString:@""])
                                {
                                typeOfAdding=@"Increasing";
                                allow=true;
                                }
                                else
                                    if ([typeOfAdding isEqualToString:@"Increasing"])
                                        allow=true;
                            }
                            
                        
                        if (allow==true)
                        {
                            bool add=true;
                            
                            for(int i=0;i<[combinations count];i++)
                            {
                            if ([combinations[i] isEqualToString:[NSString stringWithFormat:@"%i-%i",xMap+4*yMap,xMap1+4*yMap1]] || [combinations[i] isEqualToString:[NSString stringWithFormat:@"%i-%i",xMap1+4*yMap1,xMap+4*yMap]])
                            {
                                add=false;
                                break;
                            }
                                
                               
                            }
                            
                            if (add==true)
                            {
                                //Adding the point to the path+++
                                if (path==nil)
                                    path=[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:xMap+4*yMap], nil];
                                else
                                    if ([[path lastObject] intValue]!=xMap+4*yMap)
                                    {
                                        [path addObject:[NSNumber numberWithInt:xMap+4*yMap]];
                                    }
                                
                                [path addObject:[NSNumber numberWithInt:xMap1+4*yMap1]];
                                //Adding the point to the path---
                                
                                if (sum_num==0)
                                sum_num+=[map[xMap+4*yMap] intValue]+[map[xMap1+4*yMap1] intValue];
                                else
                                    sum_num+=[map[xMap1+4*yMap1] intValue];
                             
                                
                                
                                NSMutableArray* Component=[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:xMap*(circle_width+distance_b_circles)+radius+EntireX],[NSNumber numberWithInt:yMap*(circle_width+distance_b_circles)+radius+EntireY],[NSNumber numberWithInt:xMap1*(circle_width+distance_b_circles)+radius+EntireX],[NSNumber numberWithInt:yMap1*(circle_width+distance_b_circles)+radius+EntireY], nil];
                            
                                if (lines==nil)
                                    lines=[NSMutableArray arrayWithObjects:Component, nil];
                                else
                                    [lines addObject:Component];
                            
                            
                                if(combinations==nil)
                                {
                                    combinations=[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%i-%i",xMap+4*yMap,xMap1+4*yMap1], nil]  ;
                                }
                                else
                                {
                                    [combinations  addObject:[NSString stringWithFormat:@"%i-%i",xMap+4*yMap,xMap1+4*yMap1]];
                                }
                                
                            
                                xMap=(currentPos.x-EntireX)/(circle_width+distance_b_circles);
                                yMap=(currentPos.y-EntireY)/(circle_width+distance_b_circles);
                                
                                [lineTemp removeAllObjects];
                                lineTemp=nil;
                            }
                            
                            
                        }
                        }
                        }
                    }
                }
            //Add line to the matrix---
                
            }
         
            
            [self setNeedsDisplay];
        }
    }
    }
    else
        if ([scene_mode isEqualToString:@"Tutorial"])
        {
            UITouch *myTouch = [[touches allObjects] objectAtIndex:0];
            CGPoint currentPos = [myTouch locationInView: self];
            
            int X1=currentPos.x;
            
            DisplayX=(-1)*(firstPosition.x-X1);
            
            [self setNeedsDisplay];
        }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *myTouch = [[touches allObjects] objectAtIndex: 0];
    CGPoint currentPos = [myTouch locationInView: self];
    
    Cur=CGPointMake(-1, -1);
    
    if ([scene_mode isEqualToString:@"Main menu"])
    {
        if ([main_buttons[0] Touch:currentPos])
            scene_mode=@"Play";
        
        if ([main_buttons[1] Touch:currentPos]) //Rate
        {
            [self rate];
        }
        
        if ([main_buttons[2] Touch:currentPos])
            scene_mode=@"Tutorial";
     
        [self setNeedsDisplay];
    }
    else
        if ([scene_mode isEqualToString:@"Game over"])
        {
            if ([replay_go Touch:currentPos])
            {
                score=0;
                
                [map removeAllObjects];
                map=[NSMutableArray new];
                
                for(int i=0;i<16;i++)
                    [map addObject:num(arc4random()%3+1)];
                
                scene_mode=@"Play";
            }
            
            if ([main_menu_go Touch:currentPos])
            {
                score=0;
                
                [map removeAllObjects];
                map=[NSMutableArray new];
                
                for(int i=0;i<16;i++)
                    [map addObject:num(arc4random()%3+1)];
                
                scene_mode=@"Main menu";
            }
            
            [self setNeedsDisplay];
        }
        else
            if ([scene_mode isEqualToString:@"Pause"])
            {
                if ([Buttons[0] Touch:currentPos])
                    scene_mode=@"Play";
                
                if ([Buttons[1] Touch:currentPos]) //Restart
                {
                    score=0;
                    
                    [map removeAllObjects];
                    map=[NSMutableArray new];
                    
                    for(int i=0;i<16;i++)
                        [map addObject:num(arc4random()%3+1)];
                    
                    scene_mode=@"Play";
                }
                
                if ([Buttons[2] Touch:currentPos]) //Rate
                {
                    [self rate];
                }
                    
                if ([Buttons[3] Touch:currentPos]) //Restart
                    scene_mode=@"Tutorial";
                
                [self setNeedsDisplay];
            }
            else
    if ([scene_mode isEqualToString:@"Play"])
    {
        bool allow=false;
        
        if ([typeOfAdding isEqualToString:@"Increasing"])
        {
            if ([path count]>2)
                allow=true;
        }
        else
            if ([typeOfAdding isEqualToString:@"Same"])
            {
                allow=true;
            }
        
        
        
        if (allow==true)
        {
            animation=true;
            score+=sum_num;
        }
        else
        {
            animation=false;
            [self Reload:false];
        }
        
        //Score+++
        if (score>best)
        {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:num(score) forKey:@"Best"];
            
            best=score;
        }
        //Score---
        
        //Pause Button+++
        if ([pause_button Touch:currentPos])
        {
            scene_mode=@"Pause";
            [self setNeedsDisplay];
        }
        //Pause Button---
        
        
        [self setNeedsDisplay];
    }
    else
        if ([scene_mode isEqualToString:@"Tutorial"])
        {
            UIImage* temp=tutorial[0];
            
            if (abs(DisplayX)>=temp.size.width/2 && DisplayX<0)
            {
            if (frame<4)
            {
                frame++;
                
                DisplayX+=temp.size.width;
            }
            }
            else
                if (abs(DisplayX)>=temp.size.width/2 && DisplayX>0)
                {
                if (frame>0)
                {
                    frame--;
                    
                    DisplayX-=temp.size.width;
                }
                }
            
            if (DisplayX!=0)
                transition=true;
            
            
            
            if (frame==4 && transition==false)
            {
                if ([t_play Touch:currentPos])
                {
                    scene_mode=@"Play";
                    frame=0;
                }
            }

            
            [self setNeedsDisplay];
        }
}


-(void)Reload:(bool)allow
{
    if (allow==true)
    {
    for(int i=0;i<[path count];i++)
        [map replaceObjectAtIndex:[path[i] intValue] withObject:[NSNumber numberWithInt:0]];
    
    if(path!=nil)
        [map replaceObjectAtIndex:[[path lastObject] intValue] withObject:[NSNumber numberWithInt:sum_num]];
    }
    
    sum_num=0;
    
    [combinations removeAllObjects];
    combinations=nil;
    
    [lines removeAllObjects];
    lines=nil;
    
    [path removeAllObjects];
    path=nil;
    
    
    [lineTemp removeAllObjects];
    lineTemp=nil;
    
    typeOfAdding=@"";
    
    touch=false;
   
    
    if (allow==true)
    {
    //"Gravity"---
    if (touch==false)
    {
        bool remplace=true;
        
        while (remplace==true)
        {
            remplace=false;
            
            for (int i=0;i<4;i++)
            {
                for (int j=0;j<4;j++)
                {
                    if ([map[j+4*i] intValue]==0)
                    {
                        if (i>0)
                        {
                            if ([map[j+4*(i-1)] intValue]!=0)
                            {
                                [map replaceObjectAtIndex:j+4*i withObject:map[j+4*(i-1)]];
                                [map replaceObjectAtIndex:j+4*(i-1) withObject:[NSNumber numberWithInt:0]];
                                remplace=true;
                            }
                            
                        }
                    }
                    
                    
                }
                
                
                
            }
        }
        
        //Refill the map+++
        for (int i=0;i<4;i++)
            for (int j=0;j<4;j++)
                if ([map[j+4*i] intValue]==0)
                {
                    [map replaceObjectAtIndex:j+4*i withObject:[NSNumber numberWithInt:arc4random()%3+1]];
                }
        
        //Refill the map---
        
        [self checkForGameOver]; //Check if there's any possible combinations
    }
    //"Gravity"+++
    }
    
    
    [self setNeedsDisplay];

}



//GRAPHICS
- (void)drawRect:(CGRect)rect
{
    if (panel==nil)
        [self Initialization];
    
    
    if ([scene_mode isEqualToString:@"Main menu"])
    {
        [self MainMenuDraw];
    }
    else
        if ([scene_mode isEqualToString:@"Game over"])
        {
            
            if (GO_Animation==true)
            {
                [self GamePlayDraw];
                
                [GameOverSprite drawAtPoint:CGPointMake(0, 0) blendMode:normal alpha:alpha];
                [replay_go DrawWithAlpha:alpha];
                [main_menu_go DrawWithAlpha:alpha];
            }
            else
            {
                [GameOverSprite drawAtPoint:CGPointMake(0, 0)];
                [replay_go DrawWithClicked:Cur];
                [main_menu_go DrawWithClicked:Cur];
            }
            
            
            if (score!=best)
            {
                NSString* temp=[NSString stringWithFormat:@"%i",score];
                int w_=[self getTextWidth:temp FontName:@"Cooper Std" Size:50.0];
                [self DrawText:temp FontName:@"Cooper Std" Xpos:(self.frame.size.width-w_)/2 Ypos:120 Color:rgb(70,70,70) Size:50.0];
                
                temp=[NSString stringWithFormat:@"Best: %i",best];
                w_=[self getTextWidth:temp FontName:@"Cooper Std" Size:15.0];
                [self DrawText:temp FontName:@"Cooper Std" Xpos:(self.frame.size.width-w_)/2 Ypos:170 Color:rgb(70,70,70) Size:15.0];
            }
            else
                if (score==best)
                {
                    NSString* temp=@"New best";
                    int w_=[self getTextWidth:temp FontName:@"Cooper Std" Size:40.0];
                    [self DrawText:temp FontName:@"Cooper Std" Xpos:(self.frame.size.width-w_)/2 Ypos:120 Color:rgb(70,70,70) Size:40.0];
                    
                    temp=[NSString stringWithFormat:@"%i",best];
                    w_=[self getTextWidth:temp FontName:@"Cooper Std" Size:40.0];
                    [self DrawText:temp FontName:@"Cooper Std" Xpos:(self.frame.size.width-w_)/2 Ypos:160 Color:rgb(70,70,70) Size:40.0];
                    
                }
            
        }
        else
            if ([scene_mode isEqualToString:@"Pause"])
            {
                [pauseMenu drawAtPoint:CGPointMake(0, 0)];
                
                for (int i=0;i<[Buttons count];i++)
                    [Buttons[i] DrawWithClicked:Cur];
                
            }
            else
                if ([scene_mode isEqualToString:@"Play"])
                {
                    [self GamePlayDraw];
                }
                else
                    if ([scene_mode isEqualToString:@"Tutorial"])
                    {
                        [self TutorialDraw];
                    }
}


-(void)DrawText:(NSString*)text FontName:(NSString*)_font Xpos:(int)_Xpos Ypos:(int)_Ypos Color:(UIColor*)_Color Size:(float)_size
{
    if (_font==nil)
        _font=@"Arial";
    
    UIFont* font=[UIFont fontWithName:_font size:_size];
    
    NSDictionary* FontAttributes=[[NSDictionary alloc] initWithObjectsAndKeys:font, NSFontAttributeName,_Color,NSForegroundColorAttributeName, nil];
    
    [text drawAtPoint:CGPointMake(_Xpos, _Ypos) withAttributes:FontAttributes];
}

-(int)getTextWidth:(NSString*)text FontName:(NSString*)_font Size:(float)_size
{
    if (_font==nil)
        _font=@"Arial";
    
    UIFont* font=[UIFont fontWithName:_font size:_size];
    
    NSDictionary* FontAttributes=[[NSDictionary alloc] initWithObjectsAndKeys:font, NSFontAttributeName,rgb(0,0,0),NSForegroundColorAttributeName, nil];
    
    return [[[NSAttributedString alloc] initWithString:text attributes:FontAttributes] size].width;
}

-(void)DrawCircle:(CGRect)Rect Stroke:(int)_SWidth FillColor:(UIColor*)_FColor StrokeColor:(UIColor*)_SColor
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    if (_FColor!=nil)
    {
        const CGFloat* fill_color = CGColorGetComponents([_FColor CGColor]);
        
        CGContextSetRGBFillColor(contextRef,fill_color[0] , fill_color[1], fill_color[2], fill_color[3]);
        CGContextFillEllipseInRect(contextRef, Rect);
    }
    
    // Draw a circle (border only)
    if (_SColor!=nil)
    {
        const CGFloat* stroke_color = CGColorGetComponents([_SColor CGColor]);
        
        CGContextSetRGBStrokeColor(contextRef,stroke_color[0], stroke_color[1], stroke_color[2], stroke_color[3]);
        CGContextSetLineWidth(contextRef, _SWidth);
        
        
        int temp=(_SWidth/2);
        
        
        
        CGRect newr=CGRectMake(Rect.origin.x+temp, Rect.origin.y+temp, Rect.size.width-temp*2, Rect.size.height-temp*2);
        
        CGContextStrokeEllipseInRect(contextRef,newr);
    }
}

-(void)GamePlayDraw
{
    [Panel_Shadow drawAtPoint:CGPointMake(EntireX-9, EntireY-8)];
    [panel drawAtPoint:CGPointMake(15, scorePanelY)];
    [pause_button DrawWithClicked:Cur];
    
    
    //Connection lines+++
    if (lines!=nil)
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        //CGContextSetRGBStrokeColor(ctx, 34/(255.0), 126/(255.0), 165/(255.0), 0.63);
        CGContextSetRGBStrokeColor(ctx, 33/(255.0), 195/(255.0), 140/(255.0), 0.63);
        
        CGContextSetLineWidth(ctx, 10);
        
        for (int i=0; i<[lines count]; i++)
        {
            NSMutableArray* temp=lines[i];
            
            CGContextMoveToPoint(ctx, toInt(temp[0]), toInt(temp[1]));
            CGContextAddLineToPoint(ctx, toInt(temp[2]),toInt(temp[3]));
        }
        
        CGContextStrokePath(ctx);
    }
    //Connection lines---
    
    //Temporal line+++
    if (touch==true && lineTemp!=nil)
    {
        CGContextRef ctx1 = UIGraphicsGetCurrentContext();
        CGContextSetRGBStrokeColor(ctx1, 33/(255.0), 195/(255.0), 140/(255.0), 0.63);
        
        CGContextSetLineWidth(ctx1, 10);
        
        CGContextMoveToPoint(ctx1, toInt(lineTemp[0]) , toInt(lineTemp[1]));
        CGContextAddLineToPoint( ctx1, toInt(lineTemp[2]),toInt(lineTemp[3]));
        
        CGContextStrokePath(ctx1);
    }
    //Temporal line---
    
    //Circles+++
    bool draw;
    
    for (int j=0;j<4;j++)
        for (int k=0;k<4;k++)
        {
            draw=true;
            
            
            if(animation==true)
                for(int z=0;z<[path count]-1;z++)
                {
                    if (toInt(path[z])==k+4*j)
                    {
                        draw=false;
                        break;
                    }
                }
            
            
            if (draw==true)
            {
                UIColor* clr_init;
                
                if (toInt(map[k+4*j])>=0 && toInt(map[k+4*j])<4)
                    clr_init=[colors objectForKey:map[k+4*j]];
                else
                    clr_init=[colors objectForKey:num(4)];
                
                
                //Make the fill color lighter+++
                const CGFloat* c=CGColorGetComponents([clr_init CGColor]);
                
                int inc=35;
                
                UIColor* clr=[UIColor colorWithRed:c[0]+(inc)/255.0 green:c[1]+(inc)/255.0 blue:c[2]+(inc)/255.0 alpha:c[3]];
                //Make the fill color lighter---
                
                
                [self DrawCircle:CGRectMake(EntireX+k*(circle_width+distance_b_circles), EntireY+j*(circle_width+distance_b_circles), 59, 59) Stroke:7 FillColor:clr StrokeColor:clr_init];
                
                
                
                
                //Text+++
                if (toInt(map[k+4*j])!=0)
                {
                    NSString* temp=@"";
                    temp=[NSString stringWithFormat:@"%i",[map[k+4*j] intValue]];
                    UIColor* clr;
                    
                    
                    if([map[k+4*j] intValue]>0 && [map[k+4*j] intValue]<4)
                        clr=[colors objectForKey:map[k+4*j]]; //color assigned to each number
                    else
                        clr=[colors objectForKey:num(4)];
                    
                    int width=[[[NSAttributedString alloc] initWithString:temp attributes:TheFont] size].width;
                    
                    
                    [self DrawText:temp FontName:@"Charcoal" Xpos:EntireX+k*(circle_width+distance_b_circles)+(circle_width-width)/2 Ypos:EntireY+j*(circle_width+distance_b_circles)+17 Color:clr Size:22.0];
                }
                //Text---
            }
        }
    //Circles---
    
    
    
    //Score+++
    int w=[self getTextWidth:[NSString stringWithFormat:@"%i",score] FontName:@"Cooper Std" Size:15.0];
    //[self DrawText:[NSString stringWithFormat:@"%i",score] FontName:@"Cooper Std" Xpos:15+17+(80-w)/2 Ypos:48+1 Color:rgb(24,129,102) Size:15.0];
    [self DrawText:[NSString stringWithFormat:@"%i",score] FontName:@"Cooper Std" Xpos:15+(112-w)/2 Ypos:scorePanelY+35 Color:rgb(36,116,157) Size:15.0];
    
    w=[self getTextWidth:[NSString stringWithFormat:@"%i",best] FontName:@"Cooper Std" Size:15.0];
    //[self DrawText:[NSString stringWithFormat:@"%i",best] FontName:@"Cooper Std" Xpos:15+116+17+(80-w)/2 Ypos:48+1 Color:rgb(24,129,102) Size:15.0];
    [self DrawText:[NSString stringWithFormat:@"%i",best] FontName:@"Cooper Std" Xpos:15+116+17+(80-w)/2 Ypos:scorePanelY+35 Color:rgb(24,129,102) Size:15.0];
    //Score---
    
    
    
    //Animation+++
    if (animation==true)
    {
        for (int i=0;i<[path count]-1;i++)
        {
            int yi=[path[i] intValue]/4;
            int xj=[path[i] intValue]-yi*4;
            
            
            UIColor* clr_init;
            
            if (toInt(map[xj+4*yi])>=0 && toInt(map[xj+4*yi])<4)
                clr_init=[colors objectForKey:map[xj+4*yi]];
            else
                clr_init=[colors objectForKey:num(4)];
            
            
            //Make the fill color lighter+++
            const CGFloat* c=CGColorGetComponents([clr_init CGColor]);
            
            int inc=35;
            
            UIColor* clr=[UIColor colorWithRed:c[0]+(inc)/255.0 green:c[1]+(inc)/255.0 blue:c[2]+(inc)/255.0 alpha:c[3]];
            //Make the fill color lighter---
            
            int z=(circle_width-diameter_animation)/2;
            [self DrawCircle:CGRectMake(EntireX+xj*(circle_width+distance_b_circles)+z, EntireY+yi*(circle_width+distance_b_circles)+z, diameter_animation, diameter_animation) Stroke:7 FillColor:clr StrokeColor:clr_init];
            
            
        }
    }
    //Animation---
}

-(void)MainMenuDraw
{
    [MenuSprite drawAtPoint:CGPointMake(0, 0)];
 
    for (int i=0;i<[main_buttons count];i++)
            [main_buttons[i] DrawWithClicked:Cur];
   
}

-(void)TutorialDraw
{
    UIImage* temp=tutorial[0];
    
        if (DisplayX>0 && frame>0)
            [tutorial[frame-1] drawAtPoint:CGPointMake(DisplayX-temp.size.width, tutotialY)];
        else
            if (DisplayX<0 && frame<4)
                [tutorial[frame+1] drawAtPoint:CGPointMake(DisplayX+temp.size.width, tutotialY)];
  
    
    [tutorial[frame] drawAtPoint:CGPointMake(DisplayX, tutotialY)];
    
    
    
    
     int yh=self.frame.size.height-50;
    
    [indicators drawAtPoint:CGPointMake(116,yh)];
    
    switch (frame)
    {
        case 0:
            [selected drawAtPoint:CGPointMake(116, yh)]; //442
            break;
            
        case 1:
             [selected drawAtPoint:CGPointMake(136, yh)];
            break;
            
        case 2:
            [selected drawAtPoint:CGPointMake(156, yh)];
            break;
            
        case 3:
            [selected drawAtPoint:CGPointMake(176, yh)];
            break;
            
        case 4:
            [selected drawAtPoint:CGPointMake(196, yh)];
            break;
    }
    
    if (transition==false && frame==4 && DisplayX==0)
        [t_play DrawWithClicked:Cur];
}

-(void)checkForGameOver
{
    //Game over+++
    scene_mode=@"Game over";
    
    NSMutableArray* rectangle=[NSMutableArray new];
    
    for(int i=0;i<4;i++)
    {
        for(int j=0;j<4;j++)
        {
            if (i>0 && j>0)
                [rectangle addObject:map[j-1+4*(i-1)]];
            
            if (i>0 && j<3)
                [rectangle addObject:map[j+1+4*(i-1)]];
            
            
            if (i<3 && j>0)
                [rectangle addObject:map[j-1+4*(i+1)]];
            
            if (i<3 && j<3)
                [rectangle addObject:map[j+1+4*(i+1)]];
            
            
            if (i>0)
                [rectangle addObject:map[j+4*(i-1)]];
            
            if (i<3)
                [rectangle addObject:map[j+4*(i+1)]];
            
            
            if (j>0)
                [rectangle addObject:map[j-1+4*i]];
            
            if (j<3)
                [rectangle addObject:map[j+1+4*i]];
            
            
            
            for (int z=0;z<[rectangle count];z++)
            {
                if ([map[j+4*i] intValue]==[rectangle[z] intValue])
                {
                    scene_mode=@"Play";
                    break;
                }
            }
            
            [rectangle removeAllObjects];
            rectangle=[NSMutableArray new];
        }
    }
    
    
    //Check consequtive numbers
    if ([scene_mode isEqualToString:@"Game over"])
    {
        NSMutableArray* subrectangle=[NSMutableArray new];
        NSMutableArray* temp=[NSMutableArray new];
        
        NSMutableArray* temp1=[NSMutableArray new];
        NSMutableArray* temp2=[NSMutableArray new];
        NSMutableArray* temp3=[NSMutableArray new];
        NSMutableArray* temp4=[NSMutableArray new];
        NSMutableArray* temp5=[NSMutableArray new];
        NSMutableArray* temp6=[NSMutableArray new];
        NSMutableArray* temp7=[NSMutableArray new];
        NSMutableArray* temp8=[NSMutableArray new];
        
        int i1=0;
        int j1=0;
        
        for(int i=0;i<4;i++)
        {
            for(int j=0;j<4;j++)
            {
                j1=j;
                i1=i;
                
                if (i>0 && j>0)
                {
                    [rectangle addObject:map[j-1+4*(i-1)]];
                  
                    j1=j-1;
                    i1=i-1;
                    
                    if (i1>0 && j1>0)
                        [temp1 addObject:map[j1-1+4*(i1-1)]];
                    if (i1>0 && j1<3)
                        [temp1 addObject:map[j1+1+4*(i1-1)]];
                    if (i1<3 && j1>0)
                        [temp1 addObject:map[j1-1+4*(i1+1)]];
                    if (i1>0)
                        [temp1 addObject:map[j1+4*(i1-1)]];
                    if (i1<3)
                        [temp1 addObject:map[j1+4*(i1+1)]];
                    if (j1>0)
                        [temp1 addObject:map[j1-1+4*i1]];
                    if (j1<3)
                        [temp1 addObject:map[j1+1+4*i1]];
                    
                    if (temp1!=nil)
                    [subrectangle addObject:temp1];
                }
                
                if (i>0 && j<3)
                {
                    [rectangle addObject:map[j+1+4*(i-1)]];
                    
                    j1=j+1;
                    i1=i-1;
                    
                    if (i1>0 && j1>0)
                        [temp2 addObject:map[j1-1+4*(i1-1)]];
                    if (i1>0 && j1<3)
                        [temp2 addObject:map[j1+1+4*(i1-1)]];
                    if (i1<3 && j1<3)
                        [temp2 addObject:map[j1+1+4*(i1+1)]];
                    if (i1>0)
                        [temp addObject:map[j1+4*(i1-1)]];
                    if (i1<3)
                        [temp2 addObject:map[j1+4*(i1+1)]];
                    if (j1>0)
                        [temp2 addObject:map[j1-1+4*i1]];
                    if (j1<3)
                        [temp2 addObject:map[j1+1+4*i1]];
                    
                    if (temp2!=nil)
                    [subrectangle addObject:temp2];
                }
                
                
                if (i<3 && j>0)
                {
                    [rectangle addObject:map[j-1+4*(i+1)]];
                    
                    j1=j-1;
                    i1=i+1;
                    
                    if (i1>0 && j1>0)
                        [temp3 addObject:map[j1-1+4*(i1-1)]];
                    if (i1<3 && j1>0)
                        [temp3 addObject:map[j1-1+4*(i1+1)]];
                    if (i1<3 && j1<3)
                        [temp3 addObject:map[j1+1+4*(i1+1)]];
                    if (i1>0)
                        [temp3 addObject:map[j1+4*(i1-1)]];
                    if (i1<3)
                        [temp3 addObject:map[j1+4*(i1+1)]];
                    if (j1>0)
                        [temp3 addObject:map[j1-1+4*i1]];
                    if (j1<3)
                        [temp3 addObject:map[j1+1+4*i1]];
                    
                    if (temp3!=nil)
                    [subrectangle addObject:temp3];
               }
                
                if (i<3 && j<3)
                {
                    [rectangle addObject:map[j+1+4*(i+1)]];
                    
                    j1=j+1;
                    i1=i+1;
                    
                    if (i1>0 && j1<3)
                        [temp4 addObject:map[j1+1+4*(i1-1)]];
                    if (i1<3 && j1>0)
                        [temp4 addObject:map[j1-1+4*(i1+1)]];
                    if (i1<3 && j1<3)
                        [temp4 addObject:map[j1+1+4*(i1+1)]];
                    if (i1>0)
                        [temp4 addObject:map[j1+4*(i1-1)]];
                    if (i1<3)
                        [temp4 addObject:map[j1+4*(i1+1)]];
                    if (j1>0)
                        [temp4 addObject:map[j1-1+4*i1]];
                    if (j1<3)
                        [temp4 addObject:map[j1+1+4*i1]];
                    
                    if (temp4!=nil)
                    [subrectangle addObject:temp4];
                }
                
                
                if (i>0)
                {
                    [rectangle addObject:map[j+4*(i-1)]];
                    
                    j1=j;
                    i1=i-1;
                    
                    if (i1>0 && j1>0)
                        [temp5 addObject:map[j1-1+4*(i1-1)]];
                    if (i1>0 && j1<3)
                        [temp5 addObject:map[j1+1+4*(i1-1)]];
                    if (i1<3 && j1>0)
                        [temp5 addObject:map[j1-1+4*(i1+1)]];
                    if (i1<3 && j1<3)
                        [temp5 addObject:map[j1+1+4*(i1+1)]];
                    if (i1>0)
                        [temp5 addObject:map[j1+4*(i1-1)]];
                    if (j1>0)
                        [temp5 addObject:map[j1-1+4*i1]];
                    if (j1<3)
                        [temp5 addObject:map[j1+1+4*i1]];
                    
                    if (temp5!=nil)
                    [subrectangle addObject:temp5];
                }
                
                if (i<3)
                {
                    [rectangle addObject:map[j+4*(i+1)]];
                    
                    j1=j;
                    i1=i+1;
                    
                    if (i1>0 && j1>0)
                        [temp6 addObject:map[j1-1+4*(i1-1)]];
                    if (i1>0 && j1<3)
                        [temp6 addObject:map[j1+1+4*(i1-1)]];
                    if (i1<3 && j1>0)
                        [temp6 addObject:map[j1-1+4*(i1+1)]];
                    if (i1<3 && j1<3)
                        [temp6 addObject:map[j1+1+4*(i1+1)]];
                    if (i1<3)
                        [temp6 addObject:map[j1+4*(i1+1)]];
                    if (j1>0)
                        [temp6 addObject:map[j1-1+4*i1]];
                    if (j1<3)
                        [temp6 addObject:map[j1+1+4*i1]];
                    
                    if (temp6!=nil)
                    [subrectangle addObject:temp6];
                }
                
                
                if (j>0)
                {
                    [rectangle addObject:map[j-1+4*i]];
                    
                    j1=j-1;
                    i1=i;
                    
                    if (i1>0 && j1>0)
                        [temp7 addObject:map[j1-1+4*(i1-1)]];
                    if (i1>0 && j1<3)
                        [temp7 addObject:map[j1+1+4*(i1-1)]];
                    if (i1<3 && j1>0)
                        [temp7 addObject:map[j1-1+4*(i1+1)]];
                    if (i1<3 && j1<3)
                        [temp7 addObject:map[j1+1+4*(i1+1)]];
                    if (i1>0)
                        [temp7 addObject:map[j1+4*(i1-1)]];
                    if (i1<3)
                        [temp7 addObject:map[j1+4*(i1+1)]];
                    if (j1>0)
                        [temp7 addObject:map[j1-1+4*i1]];
                    
                    if (temp7!=nil)
                    [subrectangle addObject:temp7];
                }
                
                if (j<3)
                {
                    [rectangle addObject:map[j+1+4*i]];
                    
                    j1=j+1;
                    i1=i;
                    
                    if (i1>0 && j1>0)
                        [temp8 addObject:map[j1-1+4*(i1-1)]];
                    if (i1>0 && j1<3)
                        [temp8 addObject:map[j1+1+4*(i1-1)]];
                    if (i1<3 && j1>0)
                        [temp8 addObject:map[j1-1+4*(i1+1)]];
                    if (i1<3 && j1<3)
                        [temp8 addObject:map[j1+1+4*(i1+1)]];
                    if (i1>0)
                        [temp8 addObject:map[j1+4*(i1-1)]];
                    if (i1<3)
                        [temp8 addObject:map[j1+4*(i1+1)]];
                    if (j1<3)
                        [temp8 addObject:map[j1+1+4*i1]];
                    
                    if (temp8!=nil)
                    [subrectangle addObject:temp8];
                    
                }
                
                
                
                for (int z=0;z<[subrectangle count];z++)
                {
                    temp=subrectangle[z];
                    
                    for (int b=0;b<[temp count];b++)
                    {
                        if ([map[j+4*i] intValue]==[rectangle[z] intValue]-1 && [map[j+4*i] intValue]==[temp[b] intValue]-2)
                        {
                            scene_mode=@"Play";
                            break;
                        }
                    }
                }
                
                [rectangle removeAllObjects];
                rectangle=[NSMutableArray new];
                
                [subrectangle removeAllObjects];
                subrectangle=[NSMutableArray new];
                
                [temp removeAllObjects];
                temp=[NSMutableArray new];
                
                [temp1 removeAllObjects];
                temp1=[NSMutableArray new];
                
                [temp2 removeAllObjects];
                temp2=[NSMutableArray new];
                
                [temp3 removeAllObjects];
                temp3=[NSMutableArray new];
                
                [temp4 removeAllObjects];
                temp4=[NSMutableArray new];
                
                [temp5 removeAllObjects];
                temp5=[NSMutableArray new];
                
                [temp6 removeAllObjects];
                temp6=[NSMutableArray new];
                
                [temp7 removeAllObjects];
                temp7=[NSMutableArray new];
                
                [temp8 removeAllObjects];
                temp8=[NSMutableArray new];
            }
        }
        
        
    }
    //Game over--
    
    if ([scene_mode isEqualToString:@"Game over"])
    {
        GO_Animation=true;
    }
}


//RATE
-(void)rate
{
    [Appirater setAppId:@"111111111"];         //yourApp id
    [Appirater setDaysUntilPrompt:1];
    [Appirater setUsesUntilPrompt:5];
    [Appirater setTimeBeforeReminding:1];
    [Appirater setDebug:NO];             //please while you upload app please setDebug `YES` to `NO` becouse its only for developer testing .
    [Appirater appLaunched:YES];
}
@end
