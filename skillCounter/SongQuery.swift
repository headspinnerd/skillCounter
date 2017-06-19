//
//  SongQuery.swift
//  skillCounter
//
//  Created by 田中江樹 on 2017-04-20.
//  Copyright © 2017 Koki. All rights reserved.
//

import Foundation
import MediaPlayer

struct SongInfo {
    
    var albumTitle: String
    var artistName: String
    var songTitle:  String
    
    var songId   :  NSNumber
}

struct AlbumInfo {
    
    var albumTitle: String
    var songs: [SongInfo]
}

class SongQuery {
    
    func get(songCategory: String) -> [AlbumInfo] {
        print("test9")
        var albums: [AlbumInfo] = []
        let albumsQuery: MPMediaQuery
        if songCategory == "Artist" {
            albumsQuery = MPMediaQuery.artists()
            
        } else if songCategory == "Album" {
            albumsQuery = MPMediaQuery.albums()
            
        /*} else if songCategory == "PlayLists" {
            albumsQuery = MPMediaQuery.playlists()*/
            
        } else {
            albumsQuery = MPMediaQuery.albums()
        }
        
        
        // let albumsQuery: MPMediaQuery = MPMediaQuery.albums()
        let albumItems: [MPMediaItemCollection] = albumsQuery.collections! as [MPMediaItemCollection]
        //  var album: MPMediaItemCollection
        
        for album in albumItems {
            
            let albumItems: [MPMediaItem] = album.items as [MPMediaItem]
            // var song: MPMediaItem
            
            var songs: [SongInfo] = []
            
            var albumTitle: String = ""
            
            for song in albumItems {
                if songCategory == "Artist" {
                    albumTitle = song.value( forProperty: MPMediaItemPropertyArtist ) as! String
                    
                } else if songCategory == "Album" {
                    albumTitle = song.value( forProperty: MPMediaItemPropertyAlbumTitle ) as! String
                    
                /*} else if songCategory == "PlayLists" {
                    albumTitle = song.value( forProperty: MPMediaItemPropertyTitle ) as! String*/
                    
                } else {
                    albumTitle = song.value( forProperty: MPMediaItemPropertyAlbumTitle ) as! String
                }
                
                let songInfo: SongInfo = SongInfo(
                    albumTitle: song.value( forProperty: MPMediaItemPropertyAlbumTitle ) as! String,
                    artistName: song.value( forProperty: MPMediaItemPropertyArtist ) as! String,
                    songTitle:  song.value( forProperty: MPMediaItemPropertyTitle ) as! String,
                    songId:     song.value( forProperty: MPMediaItemPropertyPersistentID ) as! NSNumber
                )
                songs.append( songInfo )
            }
            
            let albumInfo: AlbumInfo = AlbumInfo(
                
                albumTitle: albumTitle,
                songs: songs
            )
            
            albums.append( albumInfo )
        }
        
        return albums
        
    }
    
    func getItem( songId: NSNumber ) -> MPMediaItem {
        
        let property: MPMediaPropertyPredicate = MPMediaPropertyPredicate( value: songId, forProperty: MPMediaItemPropertyPersistentID )
        
        let query: MPMediaQuery = MPMediaQuery()
        query.addFilterPredicate( property )
        
        var items: [MPMediaItem] = query.items! as [MPMediaItem]
        
        return items[items.count - 1]
        
    }
    
}
