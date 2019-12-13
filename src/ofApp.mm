#include "ofApp.h"
using namespace ofxCv;
//--------------------------------------------------------------
void ofApp::setup(){
    ofBackground(10);
    ofClear(255, 255, 255, 0); // 0 is important

    ofSetFrameRate(60);
     ofEnableAlphaBlending();
        ofEnableAntiAliasing();
        ofEnableSmoothing();
        ofSetCircleResolution(100);
    glEnable(GL_POINT_SMOOTH);
    glPointSize(30);
    
    cam.setDeviceID(1); // front camera
    cam.setup(1000, 0);
    ready = true;
           
    tracker.setup();
    

    nearThreshold = 120; //the higher the better 120, 40
    farThreshold = 90; //the lower the better 90, 20
    
    colorImg.allocate(cam.getWidth(), cam.getHeight(), OF_IMAGE_COLOR);
    grayImage.allocate(cam.getWidth(), cam.getHeight(), OF_IMAGE_GRAYSCALE);
    grayThreshNear.allocate(cam.getWidth(), cam.getHeight(), OF_IMAGE_GRAYSCALE);
    grayThreshFar.allocate(cam.getWidth(), cam.getHeight(), OF_IMAGE_GRAYSCALE);
    grayPreprocImage.allocate(cam.getWidth(), cam.getHeight(), OF_IMAGE_GRAYSCALE);
    contourFinder.setFindHoles(true);
    contourFinder.setMinAreaRadius(25); //75
    contourFinder.setMaxAreaRadius(300);
    contourFinder.getTracker().setPersistence(15);
    
    
//    finder.setup("haarcascade_frontalface_default.xml");
//    finder.setPreset(ObjectFinder::Fast);
    
    cropped.allocate(ofGetWidth(), ofGetHeight(), OF_IMAGE_COLOR);
    last = ofGetElapsedTimeMillis();
    last2 = ofGetElapsedTimeMillis();
    counter = 0;
    counter2 = 0;

    newColor.setHsb(0,255,255);
    
    newColor2.setHsb(255,255,0);



}

void ofApp::updateColor2(){
    if(ofGetElapsedTimeMillis() - last2 > 15){
        newColor2.setHue(counter % 100);
        counter2 ++;
        last2 = ofGetElapsedTimeMillis();
    }
}

void ofApp::updateColor(){
    if(ofGetElapsedTimeMillis() - last > 5){
        newColor.setHue(counter % 256);
        counter ++;
        last = ofGetElapsedTimeMillis();
    }
}


//--------------------------------------------------------------
void ofApp::update(){
    ofBackground(newColor2);
    if (!ready) return;

   
    cam.update();
    
    if(cam.isFrameNew()) {
        
        tracker.update(ofxCv::toCv(cam));
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
        
    }
    
    pp = contourFinder.getPolylines();

    updateColor();
    updateColor2();
}

void ofApp::getPolylines(){
    
}

//--------------------------------------------------------------
void ofApp::draw(){
    
    if(!ready) return;
    ofTranslate(ofGetWidth(), 0);
    ofScale(-1.5, 1.5);
    
    float scale = ofGetWidth() / cam.getWidth();
    ofScale(scale, scale);
    ofTranslate(0,25,0);
    
    if (bCam)
        cam.draw(0, 0);

    
    ofMesh tempMesh;
    tempMesh.setMode(OF_PRIMITIVE_POINTS);
    
    for (int i = 0; i < contourFinder.size(); i++){
        ofMesh tempMesh;
        
        ofPolyline tempPoly = contourFinder.getPolyline(i);
        tempPoly.simplify(.75f);
//        tempPoly = tempPoly.getSmoothed(10);
        for (int x = 0; x < tempPoly.size(); x++){
            tempMesh.addColor(newColor);
//            tempMesh.addColor(newColor);
            tempMesh.addVertex(tempPoly[x]);
        }
        
    //            tempMesh.draw();
                
        const std::size_t MAX_BUFFER_SIZE = 75;
                
        if (meshVector.size() < MAX_BUFFER_SIZE){
            meshVector.push_back(tempMesh);
            nextIndexToWrite = meshVector.size();
        }else{
            meshVector[nextIndexToWrite] = tempMesh;
        }
            nextIndexToWrite = (nextIndexToWrite + 1) % MAX_BUFFER_SIZE;
        }
            
        for (int z = 0; z < meshVector.size(); z++){
            ofMesh asdfMesh = meshVector[z];
    //      shader.begin();
            asdfMesh.draw();
    //      shader.end();
        }

}

void ofApp::polyToPath(){
    
    ofPath newPath;
    for (int j = 0; j = contourFinder.size(); j++){
       
        ofPolyline temp = contourFinder.getPolyline(j);
    
        for (int x = 0; x < temp.size(); x++){

        }
    }
}

//--------------------------------------------------------------
void ofApp::exit(){

}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
    bCam = !bCam;
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
