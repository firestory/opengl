//
//  ZFDView.h
//  OpenGL_GLSL
//
//  Created by NiiLove on 2020/9/24.
//  Copyright © 2020 zengfandi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES3/gl.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZFDView : UIView

@property (nonatomic, strong) CAEAGLLayer *myEagLayer;
@property (nonatomic, strong) EAGLContext *myContext;

@property (nonatomic ,assign) GLuint myColorRenderBuffer;
@property (nonatomic ,assign) GLuint myColorFrameBuffer;

@property (nonatomic ,assign) GLuint myPrograme;

@end

NS_ASSUME_NONNULL_END
