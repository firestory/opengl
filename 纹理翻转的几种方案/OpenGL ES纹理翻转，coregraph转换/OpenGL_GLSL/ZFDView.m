//
//  ZFDView.m
//  OpenGL_GLSL
//
//  Created by NiiLove on 2020/9/24.
//  Copyright © 2020 zengfandi. All rights reserved.
//

#import "ZFDView.h"



@implementation ZFDView


- (void)layoutSubviews
{
    [self setupLayer];

    [self setupContext];

    [self deleteRenderAndFrameBuffer];

    [self setupRenderBuffer];

    [self setupFrameBuffer];

    [self renderLayer];
    
}


+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

#pragma mark - 绘制
- (void)renderLayer
{
    glClearColor(1, 1, 1, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    
    CGFloat scale = [[UIScreen mainScreen]scale];
    glViewport(self.frame.origin.x * scale, self.frame.origin.y * scale, self.frame.size.width * scale, self.frame.size.height * scale);
    
    NSString *vertFile = [[NSBundle mainBundle]pathForResource:@"shaderv" ofType:@"vsh"];
    NSString *fragFile = [[NSBundle mainBundle]pathForResource:@"shaderf" ofType:@"fsh"];
    
    NSLog(@"vertFile:%@",vertFile);
    NSLog(@"fragFile:%@",fragFile);
    
    self.myPrograme = [self loadShaders:vertFile Withfrag:fragFile];
    
    glLinkProgram(self.myPrograme);
    GLint linkStatus;
    glGetProgramiv(self.myPrograme, GL_LINK_STATUS, &linkStatus);
    
    if (linkStatus == GL_FALSE) {
        
        GLchar message[512];
        glGetProgramInfoLog(self.myPrograme, sizeof(message), 0, message);
        NSString *mst = [NSString stringWithUTF8String:message];
        NSLog(@"program link error :%@",mst);
        return;;
    }
    
    glUseProgram(self.myPrograme);
    
    
    GLfloat attrArr[] =
    {
        0.5f, -0.5f, -1.0f,     1.0f, 0.0f,
        -0.5f, 0.5f, -1.0f,     0.0f, 1.0f,
        -0.5f, -0.5f, -1.0f,    0.0f, 0.0f,
        
        0.5f, 0.5f, -1.0f,      1.0f, 1.0f,
        -0.5f, 0.5f, -1.0f,     0.0f, 1.0f,
        0.5f, -0.5f, -1.0f,     1.0f, 0.0f,
    };

    GLuint attrBuffer;
    glGenBuffers(1, &attrBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, attrBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(attrArr), attrArr, GL_DYNAMIC_DRAW);
    
    GLuint position = glGetAttribLocation(self.myPrograme, "position");
    glEnableVertexAttribArray(position);
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (float *)NULL);
    
    GLuint texCoord = glGetAttribLocation(self.myPrograme, "textCoordinate");
    glEnableVertexAttribArray(texCoord);
    glVertexAttribPointer(texCoord, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (float *)NULL + 3);

    [self setupTexture:@"bg"];
    
    glDrawArrays(GL_TRIANGLES, 0, 6);
    [self.myContext presentRenderbuffer:GL_RENDERBUFFER];
}


- (GLuint)setupTexture:(NSString *)fileName
{
    CGImageRef simage = [UIImage imageNamed:fileName].CGImage;
    if (!simage) NSLog(@"error laod image");
    
    size_t width = CGImageGetWidth(simage);
    size_t height = CGImageGetHeight(simage);
    
    GLubyte *sdata = (GLubyte *)calloc(width * height * 4, sizeof(GLubyte));
    
    CGContextRef scontext = CGBitmapContextCreate(sdata, width, height, 8, width * 4, CGImageGetColorSpace(simage), kCGImageAlphaPremultipliedLast);
    
    CGRect rect = CGRectMake(0, 0, width, height);
    CGContextDrawImage(scontext, rect, simage);
    
//    CGContextTranslateCTM(scontext, rect.origin.x, rect.origin.y);
    CGContextTranslateCTM(scontext, 0, rect.size.height);
    CGContextScaleCTM(scontext, 1.0, -1.0);
//    CGContextTranslateCTM(scontext, -rect.origin.x, -rect.origin.y);
    
    CGContextDrawImage(scontext, rect, simage);

    
    CGContextRelease(scontext);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE, 0);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    float fw = width, fh = height;
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, fw, fh, 0, GL_RGBA, GL_UNSIGNED_BYTE, sdata);
    
    glUniform1i(glGetUniformLocation(self.myPrograme, "colorMap"), 0);
    free(sdata);
    
    return 0;
}

#pragma mark - 设置 & 初始化
- (void)setupLayer
{
    self.myEagLayer = (CAEAGLLayer *)self.layer;
    [self setContentScaleFactor:[UIScreen mainScreen].scale];
    self.myEagLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:@false,kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8,kEAGLDrawablePropertyColorFormat,nil];
}

- (void)setupContext
{
    EAGLContext *context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!context) {
        NSLog(@"error");
        return;;
    }
    
    [EAGLContext setCurrentContext:context];
    self.myContext = context;
}

- (void)setupRenderBuffer
{
    GLuint buffer;
    glGenRenderbuffers(1, &buffer);
    self.myColorRenderBuffer = buffer;
    glBindRenderbuffer(GL_RENDERBUFFER, self.myColorRenderBuffer);
    [self.myContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:self.myEagLayer];
}

- (void)setupFrameBuffer
{
    GLuint buffer;
    glGenFramebuffers(1, &buffer);
    self.myColorFrameBuffer = buffer;
    glBindFramebuffer(GL_FRAMEBUFFER, self.myColorFrameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, self.myColorRenderBuffer);
}

- (void)deleteRenderAndFrameBuffer
{
    glDeleteRenderbuffers(1, &_myColorRenderBuffer);
    self.myColorRenderBuffer = 0;
    
    glDeleteFramebuffers(1, &_myColorFrameBuffer);
    self.myColorFrameBuffer = 0;
}

#pragma mark - shader

- (GLuint)loadShaders:(NSString *)vert Withfrag:(NSString *)frag
{
    GLuint verShader, fragShader;
    GLuint program = glCreateProgram();
    [self compileShader:&verShader type:GL_VERTEX_SHADER file:vert];
    [self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:frag];
     
    glAttachShader(program, verShader);
    glAttachShader(program, fragShader);
    
    glDeleteShader(verShader);
    glDeleteShader(fragShader);
    
    return  program;
}


- (void)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)filePath
{
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    const GLchar* source = (GLchar *)[content UTF8String];
    
    *shader = glCreateShader(type);
    
    glShaderSource(*shader, 1, &source, NULL);
    
    glCompileShader(*shader);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
