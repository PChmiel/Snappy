//
//  CameraManagerTests.swift
//  Snappy
//
//  Created by Pawel Chmiel on 18.10.2016.
//  Copyright © 2016 Droids On Roids. All rights reserved.
//

import XCTest
import AVFoundation
@testable import Snappy

class CameraManagerTests: XCTestCase {
    
    var previewSize = CGSize(width: 200, height: 300)
   
    func testScaleImage() {
        let image = UIImage().scaledToSize(previewSize)
        XCTAssertTrue(image.size.width == 200 && image.size.height == 300)
    }
    
    func testSetCamera() {
        CameraManager.generateCameraPreview(previewSize: previewSize) { view in
            XCTAssertTrue(view == CameraManager.previewView)
        }
    }
    
    func testWorkingOutput() {
        CameraManager.generateCameraPreview(previewSize: previewSize) { view in
            XCTAssertNotNil(view)
        }
    }

    func testATakePhoto() {
        let expectationTakePhoto = expectation(description: "take photo")
        CameraManager.takePhoto { image in
            if let image = image {
                XCTAssertTrue(image.size.width > 1000)
                expectationTakePhoto.fulfill()
            } else {
                XCTAssert(false)
            }
        }
        
        waitForExpectations(timeout: 6.0, handler: nil)
    }
    
    func testAToggleFlashMode() {
        if let device = (CameraManager.session?.inputs.first as? AVCaptureDeviceInput)?.device {
            if device.position == .back {
                CameraManager.toggleFlashMode(true)
                XCTAssertTrue(device.flashMode == .on)
            }
        }
    }
    
    func testSwitchCameraToFront() {
        let expectationFrontCamera = expectation(description: "front camera")
        if let camera = CameraManager.session?.inputs.first as? AVCaptureDeviceInput {
            if camera.device.position == .back {
                CameraManager.switchCamera({ _ in
                   XCTAssertTrue((CameraManager.session!.inputs.first as! AVCaptureDeviceInput ).device.position == .front)
                    expectationFrontCamera.fulfill()
                })
            } else {
                CameraManager.switchCamera({ _ in
                    XCTAssertTrue((CameraManager.session!.inputs.first as! AVCaptureDeviceInput ).device.position == .back)
                    expectationFrontCamera.fulfill()
                })
            }
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
}