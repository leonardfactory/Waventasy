//
//  SoundBoardCollectionLayout.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 17/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Cocoa

/**
 Protocollo per l'accesso dimensionale ai Nodi
 */
@objc protocol SoundBoardCollectionLayoutDelegate : NSCollectionViewDelegateFlowLayout {
    // Ottengo le dimensioni di un nodo
    @objc optional func collectionView(_ collectionView:NSCollectionView, layout collectionViewLayout:SoundBoardCollectionLayout, frameForItemAt indexPath:IndexPath) -> NSRect
}

/**
 Layout personalizzato per mostrare i Nodi nella SoundBoard
 */
class SoundBoardCollectionLayout: NSCollectionViewFlowLayout {
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func prepare() {
        super.prepare()
        self.scrollDirection = NSCollectionView.ScrollDirection.horizontal
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
//        let item = self.collectionView?.item(at: indexPath)
//        guard let nodeItem = item as? SoundNodeCollectionViewItem else { return nil }
//        let item = self.collectionView
        print("ip", indexPath)
        guard let delegate = self.collectionView?.delegate as? SoundBoardCollectionLayoutDelegate else { return nil }
        let itemFrame = delegate.collectionView!(self.collectionView!, layout: self, frameForItemAt: indexPath)
        let layoutAttributes = NSCollectionViewLayoutAttributes.init(forItemWith: indexPath)
        layoutAttributes.frame = itemFrame
        print(layoutAttributes.frame)

        return layoutAttributes
    }

    override func layoutAttributesForElements(in rect: NSRect) -> [NSCollectionViewLayoutAttributes] {
//        let count = self.collectionView?.numberOfItems(inSection: 0)
        let range = 0...(self.collectionView!.numberOfItems(inSection: 0))
        var attributes:[NSCollectionViewLayoutAttributes] = []
        for i in range {
            attributes.append(layoutAttributesForItem(at: IndexPath(item: i, section: 0))!)
        }
        return attributes
    }
//
    func setup() {
//        self.itemSize = NSSize(width: 120.0, height: 80.0)
    }
}
