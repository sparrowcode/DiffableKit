import UIKit

public protocol DiffableCollectionViewDelegateFlowLayout: AnyObject {
 
    func diffableCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
}

public extension DiffableCollectionViewDelegateFlowLayout {
    
    func diffableCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { return .zero }
}
