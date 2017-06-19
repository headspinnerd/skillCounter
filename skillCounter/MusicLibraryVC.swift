//
//  MusicLibraryVC.swift
//  skillCounter
//
//  Created by 田中江樹 on 2017-04-20.
//  Copyright © 2017 Koki. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation
import GoogleMobileAds

class MusicLibraryVC: UIViewController, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let myTableView: UITableView = UITableView( frame: CGRect.zero, style: .grouped )
    
    var albums: [AlbumInfo] = []
    var songQuery: SongQuery = SongQuery()
    var audio: AVAudioPlayer?
    var backgroundImage = UIImageView()
    
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func stopBtn(_ sender: UIBarButtonItem) {
        MyVar.player.stop()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView
        statusBar?.backgroundColor = uiColor(230, 230, 230, 1.0)
        BannerManager.shared.setBanner(point: CGPoint(x: (device.viewWidth-320)/2, y: 20), viewController: self, centerMove: .fromBottom, isRemove: false)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        backgroundImage.removeFromSuperview()
        backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        if let imageData = CoreDataManager.fetchPhotoObj() {
            backgroundImage.image = UIImage(data: imageData as Data)
            self.view.insertSubview(backgroundImage, at: 0)
        } else {
            backgroundImage.image = UIImage(named: "background_4.png")
            self.view.insertSubview(backgroundImage, at: 0)
        }
        self.title = "Songs"
        MPMediaLibrary.requestAuthorization { (status) in
            if status == .authorized {
                self.albums = self.songQuery.get(songCategory: "")
                DispatchQueue.main.async {
                    self.tableView?.rowHeight = UITableViewAutomaticDimension;
                    self.tableView?.estimatedRowHeight = 60.0;
//self.tableView?.backgroundColor = uiColor(200, 200, 200, 0.2)
                    self.tableView?.reloadData()
                }
            } else {
                self.displayMediaLibraryError()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item: MPMediaItem = songQuery.getItem( songId: albums[indexPath.section].songs[indexPath.row].songId )
        MyVar.player = MPMusicPlayerController.systemMusicPlayer()
        MyVar.player.setQueue(with: MPMediaItemCollection(items: [item]))
        MyVar.player.play()
    }
    
    func displayMediaLibraryError() {
        
        var error: String
        switch MPMediaLibrary.authorizationStatus() {
        case .restricted:
            error = "Media library access restricted by corporate or parental settings"
        case .denied:
            error = "Media library access denied by user"
        default:
            error = "Unknown error"
        }
        print("test3")
        let controller = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        controller.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { (action) in
            if #available(iOS 10.0, *) {
                print("test4")
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
            } else {
                print("test5")
                // Fallback on earlier versions
            }
        }))
        present(controller, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return albums.count
    }
    
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int ) -> Int  {
        
        return albums[section].songs.count
    }
    
    func tableView( _ tableView: UITableView, cellForRowAt indexPath:IndexPath ) -> UITableViewCell {
        print("test6")
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "MusicPlayerCell",
            for: indexPath) as! MusicPlayerCell
        cell.labelMusicTitle?.text = albums[indexPath.section].songs[indexPath.row].songTitle
        cell.labelMusicDescription?.text = albums[indexPath.section].songs[indexPath.row].artistName
        print("test7")
        let songId: NSNumber = albums[indexPath.section].songs[indexPath.row].songId
        let item: MPMediaItem = songQuery.getItem(songId: songId)
        cell.imageMusic?.image = UIImage()
        //cell.backgroundColor = uiColor(200, 200, 200, 0.2)
        if  let imageSound: MPMediaItemArtwork = item.value( forProperty: MPMediaItemPropertyArtwork ) as? MPMediaItemArtwork {
            cell.imageMusic?.image = imageSound.image(at: CGSize(width: cell.imageMusic.frame.size.width, height: cell.imageMusic.frame.size.height))
            print("songId=\(songId) item=\(item) imageSound=\(imageSound)")
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        print("test8")
        return albums[section].albumTitle
    }
}

class MusicPlayerCell: UITableViewCell {
    @IBOutlet weak var labelMusicTitle: UILabel!
    @IBOutlet weak var labelMusicDescription: UILabel!
    @IBOutlet weak var imageMusic: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
