//
//  DJDrawing.m
//  123_6
//
//  Created by Michel Balamou on 20/04/2014.
//  Copyright (c) 2014 Michel Balamou. All rights reserved.
//

#import "DJDrawing.h"
#define rgb(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0  blue:b/255.0 alpha:1.0]
#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0  blue:b/255.0 alpha:a/255.0]

@implementation DJDrawing

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)Initialization
{
    main_menu=true;
    pause_mode=false;
    
    font = [UIFont fontWithName:@"Charcoal" size: 22.0];
    TheFont = [[NSDictionary alloc] initWithObjectsAndKeys: font, NSFontAttributeName,nil,NSForegroundColorAttributeName, nil];
    
    
    NSArray* objects=[NSArray arrayWithObjects:rgb(15,87,55),rgb(192,87,10),rgb(18,66,100), nil];
    NSArray* keys=[NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3], nil];
    
    colors=[NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    background=[UIImage imageNamed:@"Background.png"];
    panel=[UIImage imageNamed:@"Panel.png"];
    pause=[UIImage imageNamed:@"Pause.png"];
    Panel_Shadow=[UIImage imageNamed:@"Panel_Shadow.png"];
    pauseMenu=[UIImage imageNamed:@"Pause_menu.png"];
    GameOverSprite=[UIImage imageNamed:@"Pause_menu.png"];
    MenuSprite=[UIImage imageNamed:@"Main_Menu.png"];
    
    circles=[NSMutableArray new];
    map=[NSMutableArray new];
    
    for(int k=0;k<5;k++)
        [circles addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Circle%i.png",k]]];
    
    for(int i=0;i<16;i++)
        [map addObject:[NSNumber numberWithInt:arc4random()%3+1]];
    
    
    touch=false;
    
    EntireX=25;
    //EntireY=220;
    EntireY=170;
    
    xMap=0;
    yMap=0;
    
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(countDownDuration) userInfo:nil repeats:YES];
    
    sum_num=0;
    
    score=0;
    
    typeOfAdding=@"";
    
    best=0;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    best=[prefs integerForKey:@"Best"];
    
    
    UIImage* temp=circles[0];
    distance_b_circles=9;
    circle_width=temp.size.width;
    radius=temp.size.width/2;
    
    animation=false;
    
    drawAnimation=[NSMutableArray new];
    
    for (int i=1;i<6;i++)
        [drawAnimation addObject:[UIImage imageNamed:[NSString stringWithFormat:@"CircleA%i.png",i]]];
    
}

-(void)DrawText:(NSString*)text FontName:(NSString*)_font Xpos:(int)_Xpos Ypos:(int)_Ypos Color:(UIColor*)_Color Size:(float)_size
{
    if (_font==nil)
        _font=@"Arial";
    
    UIFont* font=[UIFont fontWithName:_font size:_size];
    
    NSDictionary* FontAttributes=[[NSDictionary alloc] initWithObjectsAndKeys:font, NSFontAttributeName,_Color,NSForegroundColorAttributeName, nil];
    
    [text drawAtPoint:CGPointMake(_Xpos, _Ypos) withAttributes:FontAttributes];
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

- (void)drawRect:(CGRect)rect
{
    if (background==nil)
        [self Initialization];
    
    
    
    if (main_menu==true)
    {
        [MenuSprite drawAtPoint:CGPointMake(0, 0)];
    }
    else
    if (game_over==true)
    {
    [GameOverSprite drawAtPoint:CGPointMake(0, 0)];
    }
    else
    if (pause_mode==true)
    {
    [pauseMenu drawAtPoint:CGPointMake(0, 0)];
    }
    else
    {
        
    [Panel_Shadow drawAtPoint:CGPointMake(EntireX-9, EntireY-8)];
    [panel drawAtPoint:CGPointMake(15, 65)];
    [pause drawAtPoint:CGPointMake(255, 75)];
    
    
    //Connection lines+++
    if (lines!=nil)
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetRGBStrokeColor(ctx, 34/(255.0), 126/(255.0), 165/(255.0), 0.63);
        
        CGContextSetLineWidth(ctx, 10);
        
        for (int i=0; i<[lines count]; i++)
        {
            NSMutableArray* temp=lines[i];
            
            CGContextMoveToPoint(ctx, [temp[0] intValue], [temp[1] intValue]);
            CGContextAddLineToPoint(ctx, [temp[2] intValue],[temp[3]intValue]);
        }
        
        CGContextStrokePath(ctx);
    }
    //Connection lines---
    
    //Temporal line+++
    if (touch==true && lineTemp!=nil)
    {
        CGContextRef ctx1 = UIGraphicsGetCurrentContext();
        CGContextSetRGBStrokeColor(ctx1, 34/(255.0), 126/(255.0), 165/(255.0), 0.63);
        
        CGContextSetLineWidth(ctx1, 10);
        
        CGContextMoveToPoint(ctx1, [lineTemp[0] intValue], [lineTemp[1] intValue]);
        CGContextAddLineToPoint( ctx1, [lineTemp[2] intValue],[lineTemp[3]intValue]);
        
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
            if ([path[z] intValue]==k+4*j)
            {
                draw=false;
                break;
            }
        }
    
        
        if (draw==true)
        {
        
            if ([map[k+4*j] intValue]>=0 && [map[k+4*j] intValue]<4)
            {
                //Make the fill color lighter+++
                UIColor* clr_init=[colors objectForKey:map[k+4*j]];
                const CGFloat* c=CGColorGetComponents([clr_init CGColor]);
                
                int inc=35;
                
                UIColor* clr=[UIColor colorWithRed:c[0]+(inc)/255.0 green:c[1]+(inc)/255.0 blue:c[2]+(inc)/255.0 alpha:c[3]];
                //Make the fill color lighter---
                
                
                [self DrawCircle:CGRectMake(EntireX+k*(circle_width+distance_b_circles), EntireY+j*(circle_width+distance_b_circles), 59, 59) Stroke:7 FillColor:clr StrokeColor:clr_init];
            }
            else
                [circles[4] drawAtPoint:CGPointMake(EntireX+k*(circle_width+distance_b_circles), EntireY+j*(circle_width+distance_b_circles))];
        
        
        //Text+++
        if ([map[k+4*j] intValue]!=0)
        {
            NSString* temp=@"";
            temp=[NSString stringWithFormat:@"%i",[map[k+4*j] intValue]];
            UIColor* clr;
            
            
            if([map[k+4*j] intValue]>0 && [map[k+4*j] intValue]<4)
                clr=[colors objectForKey:map[k+4*j]]; //color assigned to each number
                else
                    clr=[UIColor colorWithRed:147/255.0 green:44/255.0 blue:88/255.0 alpha:1.0];
            
            
            int width=[[[NSAttributedString alloc] initWithString:temp attributes:TheFont] size].width;
            
            
            [self DrawText:temp FontName:@"Charcoal" Xpos:EntireX+k*(circle_width+distance_b_circles)+(circle_width-width)/2 Ypos:EntireY+j*(circle_width+distance_b_circles)+17 Color:clr Size:22.0];
            
         
        }
        //Text---
        }
    }
        
        //[self DrawCircle:CGRectMake(EntireX+4, EntireY+3, 52, 52) Stroke:8 FillColor:rgba(255,255,255,255) StrokeColor:rgba(0,0,0,255)];
        
    //Circles---
   
    
    

    
    //Score+++
    UIFont *font1 = [UIFont fontWithName:@"Charcoal" size:15.0];
    NSDictionary* TheFont1 = [[NSDictionary alloc] initWithObjectsAndKeys: font1, NSFontAttributeName,rgb(31,10,10),NSForegroundColorAttributeName, nil];
    
    
    int w=[[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%i",score] attributes:TheFont1]size].width;
    [[NSString stringWithFormat:@"%i",score] drawAtPoint:CGPointMake(15+17+(80-w)/2,98)  withAttributes:TheFont1];
    
    w=[[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%i",best] attributes:TheFont1]size].width;
    [[NSString stringWithFormat:@"%i",best] drawAtPoint:CGPointMake(15+116+17+(80-w)/2,98)  withAttributes:TheFont1];
     //Score---
    
    
    
    //Animation+++
    if (animation==true)
    {
        for (int i=0;i<[frames count];i++)
        {
            int yi=[path[i] intValue]/4;
            int xj=[path[i] intValue]-yi*4;
            
            UIImage* temp=drawAnimation[[frames[i] intValue]-1];
            
            [temp drawAtPoint:CGPointMake(EntireX+xj*(circle_width+distance_b_circles)+(circle_width-temp.size.width)/2, EntireY+yi*(circle_width+distance_b_circles)+(circle_width-temp.size.width)/2)];
        }
    }
    //Animation---
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *myTouch = [[touches allObjects] objectAtIndex: 0];
    CGPoint currentPos = [myTouch locationInView: self];
    
    currentX=currentPos.x;
    currentY=currentPos.y;
    
    if (main_menu==true)
    {
    //
    }
    else
    if (pause_mode==true)
    {
        if (currentX>95/2 && currentX<590/2 && currentY>(250-55)/2 && currentY<(360-55)/2)
        {
            pause_mode=false;
         }
        
        if (currentX>95/2 && currentX<590/2 && currentY>(410-55)/2 && currentY<(520-55)/2)
        {
            score=0;
            
            [map removeAllObjects];
            map=nil;
            
            for(int i=0;i<16;i++)
            {
                if (map==nil)
                {
                    map=[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:arc4random()%3+1], nil];
                }
                else
                    [map addObject:[NSNumber numberWithInt:arc4random()%3+1]];
            }
            
            
            pause_mode=false;

        }
        
            [self setNeedsDisplay];
    }
    else
    {
    if (currentX>EntireX && currentX<EntireX+4*(circle_width+distance_b_circles)+circle_width)
    {
        if (currentY>EntireY && currentY<EntireY+4*(circle_width+distance_b_circles)+circle_width)
        {
             xMap=(currentX-EntireX)/(circle_width+distance_b_circles);
             yMap=(currentY-EntireY)/(circle_width+distance_b_circles);
            
            if (xMap>=0 && xMap<4 && yMap>=0 && yMap<4)
            {
            //[circles replaceObjectAtIndex:xMap+4*yMap withObject:[UIImage imageNamed:@"Circle2.png"]];
        
            sum_num=[map[xMap+4*yMap] intValue];
            touch=true;
            }
            
            [self setNeedsDisplay];
        }
    }
    
    
    //Pause Button+++
    if (currentX>255 && currentX<255+pause.size.width)
    {
        if (currentY>75 && currentY<75+pause.size.height)
        {
            pause_mode=true;
            [self setNeedsDisplay];
        }
    }
    //Pause Button---
    }
}


-(void)countDownDuration
{
if(pause_mode==false)
{
bool clear=false;
    
 if (animation==true)
 {
     [map replaceObjectAtIndex:[[path lastObject] intValue] withObject:[NSNumber numberWithInt:sum_num]];
     
     if (frames==nil)
    {
        for (int i=0;i<[path count]-1;i++)
        {
            if (frames==nil)
                frames=[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:5],nil];
            else
                [frames addObject:[NSNumber numberWithInt:5]];
        }
    }
     else
     {
         for (int i=0;i<[frames count];i++)
         {
             if ([frames[i] intValue]>1)
             {
             [frames replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:[frames[i] intValue]-1]];
             animation=true;
                 clear=false;
             }
             else
             {
                 animation=false;
                 clear=true;
             }
         }
     
     }
     
     
     
     [self setNeedsDisplay];
 }

    if (clear==true)
    {
    [self Reload];
    [frames removeAllObjects];
    frames=nil;
    }
}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (pause_mode==false)
    {
    bool allow=false;
    
    if ([typeOfAdding isEqualToString:@"Increasing"])
    {
        if ([path count]>2)
        {
            allow=true;
        }
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
        
        [self setNeedsDisplay];
        
        //"Gravity"+++
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
            //"Gravity"---
            
            //Refill the map+++
            for (int i=0;i<4;i++)
                for (int j=0;j<4;j++)
                    if ([map[j+4*i] intValue]==0)
                    {
                        [map replaceObjectAtIndex:j+4*i withObject:[NSNumber numberWithInt:arc4random()%3+1]];
                    }
            
            //Refill the map---
        }

        
        
        
    }
  
    //Score+++
    if (score>best)
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setInteger:score forKey:@"Best"];
        
        best=score;
    }
    //Score---
    
    
        
    //Game over+++
        game_over=true;
        pause_mode=true;
        
        NSMutableArray* rectangle=[NSMutableArray new];
        
       for(int i=0;i<4;i++)
        {
            for(int j=0;j<4;j++)
            {
                if (i>0 && j>0)
                {
                    [rectangle addObject:map[j-1+4*(i-1)]];
                }
                
                if (i>0 && j<3)
                {
                    [rectangle addObject:map[j+1+4*(i-1)]];
                }
                
                if (i<3 && j>0)
                {
                    [rectangle addObject:map[j-1+4*(i+1)]];
                }
                
                if (i<3 && j<3)
                {
                    [rectangle addObject:map[j+1+4*(i+1)]];
                }
                
                if (i>0)
                {
                    [rectangle addObject:map[j+4*(i-1)]];
                }
            
                if (i<3)
                {
                    [rectangle addObject:map[j+4*(i+1)]];
                }
                
                
                if (j>0)
                {
                    [rectangle addObject:map[j-1+4*i]];
                }
                
                if (j<3)
                {
                [rectangle addObject:map[j+1+4*i]];
                }
                
                
                
                for (int z=0;z<[rectangle count];z++)
                {
                 if ([map[j+4*i] intValue]==[rectangle[z] intValue])
                 {
                     game_over=false;
                     pause_mode=false;
                     break;
                 }
                }
                
                [rectangle removeAllObjects];
                rectangle=[NSMutableArray new];
            }
        }
    //Game over--
        
    
    [self setNeedsDisplay];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (pause_mode==false)
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
}

-(void)Reload
{
    for(int i=0;i<[path count];i++)
        [map replaceObjectAtIndex:[path[i] intValue] withObject:[NSNumber numberWithInt:0]];
    
    if(path!=nil)
        [map replaceObjectAtIndex:[[path lastObject] intValue] withObject:[NSNumber numberWithInt:sum_num]];
    
    
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
    
    [self setNeedsDisplay];
    
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
    }
    //"Gravity"+++
    
    

}
@end
