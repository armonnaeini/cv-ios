#pragma once

#include "ofxiOS.h"
#include "ofxCv.h"
#include "ofxFaceTracker.h"


class ofApp : public ofxiOSApp {
    
    public:
        void setup();
        void update();
        void draw();
        void exit();
    ofColor newColor;
    ofColor newColor2;


        void touchDown(ofTouchEventArgs & touch);
        void touchMoved(ofTouchEventArgs & touch);
        void touchUp(ofTouchEventArgs & touch);
        void touchDoubleTap(ofTouchEventArgs & touch);
        void touchCancelled(ofTouchEventArgs & touch);
    void getPolylines();
    void updateColor2();
    
        void lostFocus();
        void gotFocus();
        void gotMemoryWarning();
        void deviceOrientationChanged(int newOrientation);
    void updateColor();
    void polyToPath();
        ofVideoGrabber cam;
        ofxFaceTracker tracker;
        bool ready;
        ofxCv::ContourFinder contourFinder;
      
        ofImage colorImg;
        ofImage grayImage;         // grayscale depth image
        ofImage grayThreshNear;    // the near thresholded image
        ofImage grayThreshFar;     // the far thresholded image
        ofImage grayPreprocImage;  // grayscale pre-processed image
        
        int nearThreshold;
        int farThreshold;
        std::vector<ofPolyline> pp;
        int nextIndexToWrite;

    ofxCv::ObjectFinder finder;
    ofImage cropped;
    int counter;
    int counter2;

    float last;
    float last2;
    bool bCam;
    ofMesh asdfMesh;


    
    std::vector<ofMesh> meshVector;




};


