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
    
    private var player: AVPlayer?
    private var videoContainer: UIView!
    
    init(url: URL) {
        self.url = url
    }
    
    func addPlayer(to view: UIView) {
        let size = view.bounds.diagonalSize

        player = AVPlayer(url: url)
        player?.actionAtItemEnd = .none;

        videoContainer = UIView()
        view.addSubview(videoContainer)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x: 0, y: 0, width: size, height: size)

        playerLayer.videoGravity = .resizeAspectFill
        videoContainer.layer.insertSublayer(playerLayer, at: 0)

        updateConstraints(in: view)
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
        player?.seek(to: .zero)
        player?.play()
        
        guard motionManager.isDeviceMotionAvailable else { return }
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (data, error) in
            
            guard let `self` = self, let data = data, error == nil else { return }
            
            let rotation = atan2(data.gravity.x, data.gravity.y) - .pi
            self.videoContainer.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
        }
    }
    
    func pause() {
        player?.pause()
        
        guard motionManager.isDeviceMotionAvailable else { return }
        motionManager.stopDeviceMotionUpdates()
    }
}
