//
//  DetailViewController.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Huebner, Rob on 3/17/16.
//  Copyright © 2016 Vimeo. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import VimeoNetworking
import VimeoUpload
import BMPlayer
import YTVimeoExtractor

func log(_ str: String?) {
    print("-------- \(str)")
}

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!
    var player: BMPlayer!

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
        if let video = self.detailItem as? VIMVideo {
            display(video: video)

//            player?.removeFromSuperview()
//            player = BMPlayer()
//            view.addSubview(player)
//            player.frame = UIScreen.main.bounds

            YTVimeoExtractor.shared().fetchVideo(withVimeoURL: video.link ?? "", withReferer: nil, completionHandler: { (ytVideo, error) in
                if let ytVideo = ytVideo {
                    let asset = BMPlayerResource(url: ytVideo.highestQualityStreamURL())
                    log("link \(ytVideo.lowestQualityStreamURL().absoluteString)")
                    self.player.setVideo(resource: asset)
                }
                log("error \(error)")
            })

            let videoRequest = Request<VIMVideo>(path: video.uri ?? "")
            VimeoClient.sharedClient.request(videoRequest, completion: { result in
                switch result {
                case .success(let result):
                    print(result.json)
                    print(result.model.files?.first)
                case .failure(let error):
                    print(error)
                }
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    func display(video: VIMVideo) {
        webView?.loadHTMLString(video.embed?.html ?? "", baseURL: nil)
    }
}

