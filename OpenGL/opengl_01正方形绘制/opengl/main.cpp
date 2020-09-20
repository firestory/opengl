//
//  main.m
//  opengl
//
//  Created by NiiLove on 2020/9/19.
//  Copyright © 2020 zengfandi. All rights reserved.
//



#include "GLShaderManager.h"
#include "GLTools.h"
#include <GLUT/GLUT.h>

GLShaderManager shaderManager;
GLBatch triangleBatch;
GLfloat blockSize = 0.1f;

//正方形的4个点坐标
GLfloat vVerts[] = {
        -blockSize,-blockSize,0.0f,
        blockSize,-blockSize,0.0f,
        blockSize,blockSize,0.0f,
        -blockSize,blockSize,0.0f
};

void changeSize(int w,int h)
{
    glViewport(0, 0, w, h);
}

void RenderScene(void)
{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT|GL_STENCIL_BUFFER_BIT);
    GLfloat vRed[] = {1.0,0.0,0.0,1.0f};
    //传递到存储着色器，即GLT_SHADER_IDENTITY着色器，这个着色器只是使用指定颜色以默认笛卡尔坐标第在屏幕上渲染几何图形
    shaderManager.UseStockShader(GLT_SHADER_IDENTITY,vRed);
    triangleBatch.Draw();
    glutSwapBuffers();
}

void setupRC()
{
    //设置清屏颜色（背景颜色）
    glClearColor(0.98f, 0.40f, 0.7f, 1);
    shaderManager.InitializeStockShaders();
    //GL_TRIANGLE_FAN ，4个顶点 如果使用三角形 则需要6个顶点。
    triangleBatch.Begin(GL_TRIANGLE_FAN, 4);
    triangleBatch.CopyVertexData3f(vVerts);
    triangleBatch.End();
}

void SpecialKeys(int key, int x, int y){
    
    GLfloat stepSize = 0.025f;
    GLfloat blockX = vVerts[0];
    GLfloat blockY = vVerts[10];
    if (key == GLUT_KEY_UP) {
        blockY += stepSize;
    }
    
    if (key == GLUT_KEY_DOWN) {
        
        blockY -= stepSize;
    }
    
    if (key == GLUT_KEY_LEFT) {
        blockX -= stepSize;
    }
    
    if (key == GLUT_KEY_RIGHT) {
        blockX += stepSize;
    }
    if (blockX < -1.0f) {
        blockX = -1.0f;
    }
    
    //当正方形移动到最右边时
    //1.0 - blockSize * 2 = 总边长 - 正方形的边长 = 最左边点的位置
    if (blockX > (1.0 - blockSize * 2)) {
        blockX = 1.0f - blockSize * 2;
    }
    
    //当正方形移动到最下面时
    //-1.0 - blockSize * 2 = Y（负轴边界） - 正方形边长 = 最下面点的位置
    if (blockY < -1.0f + blockSize * 2 ) {
        
        blockY = -1.0f + blockSize * 2;
    }
    
    //当正方形移动到最上面时
    if (blockY > 1.0f) {
        
        blockY = 1.0f;
        
    }
    // Recalculate vertex positions
    vVerts[0] = blockX;
    vVerts[1] = blockY - blockSize*2;
    printf("(%f,%f)\n",vVerts[0],vVerts[1]);
    
    vVerts[3] = blockX + blockSize*2;
    vVerts[4] = blockY - blockSize*2;
    printf("(%f,%f)\n",vVerts[3],vVerts[4]);
    
    vVerts[6] = blockX + blockSize*2;
    vVerts[7] = blockY;
    printf("(%f,%f)\n",vVerts[6],vVerts[7]);
    
    vVerts[9] = blockX;
    vVerts[10] = blockY;
    printf("(%f,%f)\n",vVerts[9],vVerts[10]);
    triangleBatch.CopyVertexData3f(vVerts);
    glutPostRedisplay();
}

int main(int argc,char *argv[])
{
    gltSetWorkingDirectory(argv[0]);
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE|GLUT_RGBA|GLUT_DEPTH|GLUT_STENCIL);
    glutInitWindowSize(500, 500);
    glutCreateWindow("正方形");
    glutReshapeFunc(changeSize);
    glutDisplayFunc(RenderScene);
    glutSpecialFunc(SpecialKeys);
    GLenum status = glewInit();
    if (GLEW_OK != status) {
        printf("GLEW Error:%s\n",glewGetErrorString(status));
        return 1;
    }
    //设置我们的渲染环境
    setupRC();
    glutMainLoop();
    return  0;
}
