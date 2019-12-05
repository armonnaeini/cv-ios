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
    
        void touchDown(ofTouchEventArgs & touch);
        void touchMoved(ofTouchEventArgs & touch);
        void touchUp(ofTouchEventArgs & touch);
        void touchDoubleTap(ofTouchEventArgs & touch);
        void touchCancelled(ofTouchEventArgs & touch);

        void lostFocus();
        void gotFocus();
        void gotMemoryWarning();
        void deviceOrientationChanged(int newOrientation);
    
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
    
    ofxCv::ObjectFinder finder;
    ofImage cropped;



};


