//
//  QRScannerController.swift
//  QRCodeReader
//
//  Created by Simon Ng on 13/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet var messageLabel:UILabel!
    @IBOutlet var topbar: UIView!
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initailAVCaptureVideo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK: - initial capture device
    
    func initailAVCaptureVideo () {
        
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            let input =  try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = captureMetadataOutput.availableMetadataObjectTypes
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            captureSession?.startRunning()
            
            view.bringSubview(toFront: messageLabel)
            view.bringSubview(toFront: topbar)
            
            addQRCodeFrameView()
            
        } catch {
            print(error)
            return
        }

    }
    
    func addQRCodeFrameView() {
        qrCodeFrameView = UIView()
        
        if let quCodeFrameView = qrCodeFrameView {
            quCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView?.layer.borderWidth = 2
            
            view.addSubview(qrCodeFrameView!)
            view.bringSubview(toFront: qrCodeFrameView!)
        }
    }
    
    // MARK: AVCaptureMetadataOutputObjectsDelegate
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        //Get the metadata object.
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
        qrCodeFrameView?.frame = barCodeObject!.bounds

        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            openURLByQRCode(metadataObj: metadataObj)
        } else {
            messageLabel.text = metadataObj.stringValue
        }
    }
    
    func openURLByQRCode (metadataObj: AVMetadataMachineReadableCodeObject) {
        
        if metadataObj.stringValue != nil {
            messageLabel.text = metadataObj.stringValue
            
            let url = URL(string: metadataObj.stringValue)
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url!)
            }
        }
    }
}
