//
//  ViewController.swift
//  Radio App
//
//  Created by Md Abdul Awal on 12/23/17.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var gifImage: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    //let urltest = URL(string: "http:www.kpftx.org:8000/wuvi_32.m3u")
  
    
    
    var avPlayer:AVPlayer?
    var avPlayerItem:AVPlayerItem?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Device Name: "+UIDevice.current.modelName);
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        let defaults = UserDefaults.standard
        if defaults.value(forKey: "volumeValue") == nil {
            UserDefaults.standard.set(0.5, forKey: "volumeValue")
        }
        
        //set uibutton scale aspect
        playButton.imageView?.contentMode = .scaleAspectFill
        
        //activityIndicator.startAnimating();
        self.activityIndicator.hidesWhenStopped = true;
        
        //Example URL
        //let urlstring = "http://www.noiseaddicts.com/samples_1w72b820/2514.mp3"
        let urlstring = "" //Here goes your audio streaming url
        let url = NSURL(string: urlstring)
        print("playing \(String(describing: url))")
        
        avPlayerItem = AVPlayerItem.init(url: url! as URL)
        avPlayer = AVPlayer.init(playerItem: avPlayerItem)
        avPlayer?.volume = UserDefaults.standard.float(forKey: "volumeValue")
        volumeSlider.value = UserDefaults.standard.float(forKey: "volumeValue")
        //avPlayer?.play()
        
        //playButton.addTarget(self, action: #selector(ViewController.playButtonTapped), for: .touchUpInside)
        
        
        
        self.observer = avPlayer?.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 600), queue: DispatchQueue.main) {
            [weak self] time in
            
            if self?.avPlayer?.currentItem?.status == AVPlayerItemStatus.readyToPlay {
                
               if(self?.activityIndicator.isAnimating)!
               {
                 self?.activityIndicator.stopAnimating();
                 self?.gifImage.isHidden = false;
                 self?.gifImage.loadGif(name: "live-logo")
               }
            }
        }
        
        
    
    }
    
    
    
    
   // @objc func playButtonTapped(sender: AnyObject) {
    //}
    
    
    var observer:Any!
    
    
    
    @IBAction func VolumeChanged(_ sender: UISlider) {
        
        let currentValue = Float(sender.value)
        avPlayer?.volume = Float(currentValue)
        UserDefaults.standard.set(currentValue, forKey: "volumeValue")
        print(currentValue)
    }
   
    
    
    @IBAction func PlayButtonTapped(_ sender: UIButton) {
        
        if avPlayer?.rate == 0
        {
            self.activityIndicator.startAnimating()
            avPlayer!.play()
            playButton.setImage(UIImage(named: "pause.png"), for: [])
            
        } else {
            
            self.activityIndicator.stopAnimating();
            gifImage.isHidden = true;
            avPlayer!.pause()
            playButton.setImage(UIImage(named: "play.png"), for: [])
        }
        
    }
    
    
    override var shouldAutorotate: Bool {
        return false
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }  


}

