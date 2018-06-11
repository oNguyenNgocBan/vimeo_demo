//
//  ViewController.swift
//  Vimeo
//
//  Created by Ban Nguyen Ngoc on 4/16/18.
//  Copyright © 2018 ban9ban3. All rights reserved.
//

import UIKit
import VimeoNetworking
import VimeoUpload

class VideoDescriptorImplement: NSObject, VideoDescriptor {
    var type: VideoDescriptorType
    var videoUri: VideoUri?
    var progressDescriptor: ProgressDescriptor

    init(type: VideoDescriptorType, videoUri: VideoUri?, progressDescriptor: ProgressDescriptor) {
        self.type = type
        self.videoUri = videoUri
        self.progressDescriptor = progressDescriptor
        super.init()
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let uploader = VimeoUploader<VideoDescriptorImplement>(backgroundSessionIdentifier: "", accessToken: "")
        uploader.uploadVideo(descriptor: VideoDescriptorImplement(type: VideoDescriptorType.upload, videoUri: "", progressDescriptor: ProgressDescriptor()))
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: DescriptorManagerDelegate {

}

