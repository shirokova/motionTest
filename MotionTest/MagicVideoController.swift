//
//  MagicVideoController.swift
//  MotionTest
//
//  Created by Anna Shirokova on 05/08/2020.
//  Copyright © 2020 Anna Shirokova. All rights reserved.
//

import UIKit
import AVKit
import CoreMotion

final class MagicVideoController {
    let url: URL
    
    private lazy var motionManager: CMMotionManager = {
        let manager = CMMotionManager()
        manager.deviceMotionUpdateInterval = 0.01
        return manager
    }()
    
    private var playerLayer: AVPlayerLayer?
    private var videoContainer: UIView!
    private var looper: AVPlayerLooper?
    
    init(url: URL) {
        self.url = url
    }
    
    func addPlayer(to view: UIView) {
        videoContainer = UIView()
        view.addSubview(videoContainer)
        
        createPLayerLayer(with: view.bounds.diagonalSize)
        updateConstraints(in: view)
    }
    
    private func createPLayerLayer(with size: CGFloat) {
        let player = AVPlayer(url: url)
        player.actionAtItemEnd = .none;
        
        if let item = player.currentItem {
            let queuePlayer = AVQueuePlayer()
            looper = AVPlayerLooper(player: queuePlayer, templateItem: item)
            playerLayer = AVPlayerLayer(player: queuePlayer)
        } else {
            playerLayer = AVPlayerLayer(player: player)
        }
        
        playerLayer?.frame = CGRect(x: 0, y: 0, width: size, height: size)
        playerLayer?.videoGravity = .resizeAspectFill
        videoContainer.layer.insertSublayer(playerLayer!, at: 0)
    }
    
    private func updateConstraints(in view: UIView) {
        videoContainer.translatesAutoresizingMaskIntoConstraints = false
        let size = view.bounds.diagonalSize

        NSLayoutConstraint.activate([
            videoContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            videoContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            videoContainer.heightAnchor.constraint(equalToConstant: size),
            videoContainer.widthAnchor.constraint(equalToConstant: size)
        ])
    }
    
    func start() {
        playerLayer?.player?.play()
        
        guard motionManager.isDeviceMotionAvailable else { return }
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (data, error) in
            
            guard let `self` = self, let data = data, error == nil else { return }
            
            let rotation = atan2(data.gravity.x, data.gravity.y) - .pi
            self.videoContainer.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
        }
    }
    
    func pause() {
        playerLayer?.player?.pause()
        
        guard motionManager.isDeviceMotionAvailable else { return }
        motionManager.stopDeviceMotionUpdates()
    }
}
