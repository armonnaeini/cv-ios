#include "ofApp.h"
using namespace ofxCv;
//--------------------------------------------------------------
void ofApp::setup(){
    ofBackground(0);
    ofSetFrameRate(60);
    cam.setDeviceID(1); // front camera
    cam.setup(1000, 1000);
    ready = true;
           
    tracker.setup();
    

    nearThreshold = 120; //the higher the better
    farThreshold = 90; //the lower the better
    
    colorImg.allocate(cam.getWidth(), cam.getHeight(), OF_IMAGE_COLOR);
    grayImage.allocate(cam.getWidth(), cam.getHeight(), OF_IMAGE_GRAYSCALE);
    grayThreshNear.allocate(cam.getWidth(), cam.getHeight(), OF_IMAGE_GRAYSCALE);
    grayThreshFar.allocate(cam.getWidth(), cam.getHeight(), OF_IMAGE_GRAYSCALE);
    grayPreprocImage.allocate(cam.getWidth(), cam.getHeight(), OF_IMAGE_GRAYSCALE);
    contourFinder.setFindHoles(true);
    contourFinder.setMinAreaRadius(25); //75
    contourFinder.setMaxAreaRadius(300);
    contourFinder.getTracker().setPersistence(15);
    finder.setup("haarcascade_frontalface_default.xml");
    finder.setPreset(ObjectFinder::Fast);
    
    cropped.allocate(ofGetWidth(), ofGetHeight(), OF_IMAGE_COLOR);


}

//--------------------------------------------------------------
void ofApp::update(){
    if(!ready) return;
    
    cam.update();
    if(cam.isFrameNew()) {
        tracker.update(ofxCv::toCv(cam));
//        finder.update(ofxCv::toCv(cam));
        finder.update(cam);
        grayImage.setFromPixels(cam.getPixels());
        threshold(grayImage, grayThreshNear, nearThreshold, true);
        threshold(grayImage, grayThreshFar, farThreshold);
        cv::Mat grayThreshNearMat = toCv(grayThreshNear);
        cv::Mat grayThreshFarMat = toCv(grayThreshFar);
                cv::Mat grayImageMat = toCv(grayImage);
        bitwise_and(grayThreshNearMat, grayThreshFarMat, grayImageMat);
        grayPreprocImage = grayImage;
                dilate(grayImage);
        dilate(grayImage);
        erode(grayImage);
        grayImage.update();
        contourFinder.findContours(grayImage);
      
//        contourFinder.findContours(cam);
        pp = contourFinder.getPolylines();

        
    }

}

//--------------------------------------------------------------
void ofApp::draw(){
    if(!ready) return;
    ofTranslate(ofGetWidth(), 0);
    ofScale(-1, 1);
    
    float scale = ofGetWidth() / cam.getWidth();
    ofScale(scale, scale);
    
//    cam.draw(0, 0);
//    tracker.draw();
    ofSetLineWidth(10);

    ofTranslate(0,100,0);
    for (int i = 0; i < contourFinder.size(); i++){
        ofPolyline temp = contourFinder.getPolyline(i);
        temp = temp.getSmoothed(10);
        temp.draw();
    }
    

}

//--------------------------------------------------------------
void ofApp::exit(){

}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){

}

//--------------------------------------------------------------
void ofApp::gotFocus(){

}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){

}
