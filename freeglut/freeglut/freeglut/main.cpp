//
//  main.m
//  freeglut
//
//  Created by NiiLove on 2020/7/10.
//  Copyright © 2020 zengfandi. All rights reserved.
//

#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#include "freeglut.h"
#include "GLTools.h"
#include "glew.h"

//#include <OpenGL/OpenGL.h>



void helloOpengl(void) {
    glClearColor(1.0, 1.0, 0.6, 1.0);  //改变默认背景有颜色为浅黄色，要写在glLoadIdentity()前
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glLoadIdentity();
    
 
    glBegin(GL_TRIANGLES);
    {
    //    glColor3f(0.0f, 1.0f, 0.0f);
        glVertex2f(0.0, 0.3);
    //    glColor3f(1.0f, 0.0f, 0.0f);
        glVertex2f(-0.3, -0.3);
    //    glColor3f(0.0f, 0.0f, 1.0f);
        glVertex2f(0.3, -0.3);
    }
    glEnd();
 
    glTranslated(0.3, 0.3, 0);
    glColor3f(1.0f, 0.0f, 1.0f);
    glBegin(GL_QUADS);
    {
        glVertex3f(-0.2f, 0.2f, 0.0f);
        glVertex3f(0.2f, 0.2f, 0.0f);
        glVertex3f(0.2f, -0.2f, 0.0f);
        glVertex3f(-0.2f, -0.2f, 0.0f);
    }
    glEnd();
 
    glutSwapBuffers();
}



int main(int argc,  char * argv[]) {

    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DEPTH | GLUT_DOUBLE | GLUT_RGBA);
    glutInitWindowPosition(100, 100);
    glutInitWindowSize(640, 640);
    glutCreateWindow("HelloTriangle");
    glutDisplayFunc(helloOpengl);
    
    glutMainLoop();
    
    
    return 0;
}
