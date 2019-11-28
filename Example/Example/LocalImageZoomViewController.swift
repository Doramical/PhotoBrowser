//
//  LocalImageZoomViewController.swift
//  Example
//
//  Created by JiongXing on 2019/11/28.
//  Copyright © 2019 JiongXing. All rights reserved.
//

import UIKit
import JXPhotoBrowser

class LocalImageZoomViewController: BaseCollectionViewController {
    
    override var name: String { "Zoom转场动画" }
    
    override var remark: String { "简单易用的缩放式转场动画，兼容缩略图与放大图存在差异" }
    
    override func makeDataSource() -> [ResourceModel] {
        makeLocalDataSource()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.jx.dequeueReusableCell(BaseCollectionViewCell.self, for: indexPath)
        cell.imageView.image = self.dataSource[indexPath.item].localName.flatMap({ name -> UIImage? in
            UIImage(named: name)
        })
        return cell
    }
    
    override func openPhotoBrowser(with collectionView: UICollectionView, indexPath: IndexPath) {
        let browser = JXPhotoBrowser()
        browser.numberOfItems = {
            self.dataSource.count
        }
        browser.reloadCell = { cell, index in
            let browserCell = cell as? JXPhotoBrowserImageCell
            let collectionPath = IndexPath(item: index, section: indexPath.section)
            let collectionCell = collectionView.cellForItem(at: collectionPath) as? BaseCollectionViewCell
            browserCell?.imageView.image = collectionCell?.imageView.image
        }
        // 使用Zoom动画
        browser.transitionAnimator = JXPhotoBrowserZoomAnimator(previousView: { index -> UIView? in
            let path = IndexPath(item: index, section: indexPath.section)
            let cell = collectionView.cellForItem(at: path) as? BaseCollectionViewCell
            return cell?.imageView
        })
        browser.pageIndex = indexPath.item
        browser.show()
    }
}
