//
//  ViewController.swift
//  MotionTest
//
//  Created by Anna Shirokova on 05/08/2020.
//  Copyright © 2020 Anna Shirokova. All rights reserved.
//

import UIKit

private let url = Bundle.main.url(forResource: "waterfall", withExtension: "mov")
//"https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4")

class ViewController: UIViewController {
    private var controller: MagicVideoController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSomeMagic()
    }
    
    private func addSomeMagic() {
        guard let url = url else { return }
        controller = MagicVideoController(url: url)
        controller?.addPlayer(to: self.view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        controller?.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        controller?.pause()
    }
}
