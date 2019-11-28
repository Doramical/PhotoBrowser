//
//  SDWebImageViewController.swift
//  Example
//
//  Created by JiongXing on 2019/11/28.
//  Copyright © 2019 JiongXing. All rights reserved.
//

import UIKit
import JXPhotoBrowser
import SDWebImage

class SDWebImageViewController: BaseCollectionViewController {
    
    override var name: String { "网络图片-SDWebImage" }
    
    override var remark: String { "示范如何用SDWebImage加载网络图片" }
    
    override func makeDataSource() -> [ResourceModel] {
        makeNetworkDataSource()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.jx.dequeueReusableCell(BaseCollectionViewCell.self, for: indexPath)
        if let firstLevel = self.dataSource[indexPath.item].firstLevelUrl {
            let url = URL(string: firstLevel)
            cell.imageView.kf.setImage(with: url)
        }
        return cell
    }
    
    override func openPhotoBrowser(with collectionView: UICollectionView, indexPath: IndexPath) {
        let browser = JXPhotoBrowser()
        browser.numberOfItems = {
            self.dataSource.count
        }
        browser.reloadCell = { cell, index in
            var url: URL?
            guard let urlString = self.dataSource[index].secondLevelUrl else {
                return
            }
            url = URL(string: urlString)
            let browserCell = cell as? JXPhotoBrowserImageCell
            let collectionPath = IndexPath(item: index, section: indexPath.section)
            let collectionCell = collectionView.cellForItem(at: collectionPath) as? BaseCollectionViewCell
            let placeholder = collectionCell?.imageView.image
            // 用SDWebImage加载
            let options: SDWebImageOptions = [.queryDiskDataSync, .scaleDownLargeImages]
            browserCell?.imageView.sd_setImage(with: url, placeholderImage: placeholder, options: options, completed: { (_, _, _, _) in
                browserCell?.setNeedsLayout()
            })
        }
        browser.transitionAnimator = JXPhotoBrowserZoomAnimator(previousView: { index -> UIView? in
            let path = IndexPath(item: index, section: indexPath.section)
            let cell = collectionView.cellForItem(at: path) as? BaseCollectionViewCell
            return cell?.imageView
        })
        browser.pageIndex = indexPath.item
        browser.show()
    }
}
