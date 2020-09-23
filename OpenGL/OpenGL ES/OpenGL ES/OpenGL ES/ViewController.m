//
//  ViewController.m
//  OpenGL ES
//
//  Created by NiiLove on 2020/9/21.
//  Copyright © 2020 zengfandi. All rights reserved.
//

#import "ViewController.h"
#import <OpenGLES/ES3/glext.h>
#import <OpenGLES/ES3/gl.h>

@interface ViewController ()
{
    EAGLContext *context;
    GLKBaseEffect *effect;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setup];
    
    [self setupVertexData];
    
    [self setupTexture];
}

- (void)setupTexture{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"kunkun" ofType:@"jpg"];
    NSDictionary *opt = [NSDictionary dictionaryWithObjectsAndKeys:@(1),GLKTextureLoaderOriginBottomLeft, nil];
    GLKTextureInfo *info = [GLKTextureLoader textureWithContentsOfFile:path options:opt error:nil];
    
    effect = [[GLKBaseEffect alloc]init];
    effect.texture2d0.enabled = GL_TRUE;
    effect.texture2d0.name = info.name;
}

- (void)setup
{
    context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if(!context) NSLog(@"context error");
    [EAGLContext setCurrentContext:context];
    GLKView *view = (GLKView *)self.view;
    view.context = context;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    glClearColor(1, 0, 0, 1);
}

- (void)setupVertexData
{
    GLfloat vertextData[] = {
        1.0, -0.5, 0.0f,    1.0f, 0.0f, //右下
        0.5, 0.5,  0.0f,    1.0f, 1.0f, //右上
        -0.5, 0.5, 0.0f,    0.0f, 1.0f, //左上
        
        0.5, -0.5, 0.0f,    1.0f, 0.0f, //右下
        -0.5, 0.5, 0.0f,    0.0f, 1.0f, //左上
        -0.5, -0.5, 0.0f,   0.0f, 0.0f, //左下
    };
    
    GLuint bufferID;
    glGenBuffers(1, &bufferID);
    glBindBuffer(GL_ARRAY_BUFFER, bufferID);
    
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertextData), vertextData, GL_STATIC_DRAW);
    //ios默认关闭属性 需要手动开启
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, (GLfloat *)NULL+0);
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, (GLfloat *)NULL + 3);
    
    
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT);
    [effect prepareToDraw];
    glDrawArrays(GL_TRIANGLES, 0, 6);
}


@end
