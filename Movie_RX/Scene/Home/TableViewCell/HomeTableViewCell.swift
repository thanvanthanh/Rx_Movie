//
//  HomeTableViewCell.swift
//  Movie_RX
//
//  Created by Thân Văn Thanh on 12/07/2021.
//

import UIKit
import RxCocoa
import RxSwift
import SDWebImage


class HomeTableViewCell: UITableViewCell {
    private let apiCalling = XmenAPICalling()
    private let disposeBag = DisposeBag()
    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
        
        let request = XmenAPIRequest()
        let result : Observable<[XMovieSearch]> = self.apiCalling.send(apiRequest: request)
        _ = result.bind(to: collectionView.rx.items(cellIdentifier: "HomeCollectionViewCell", cellType: HomeCollectionViewCell.self)) {(row , model , cell)in
            let remoteImageURL = URL(string: model.poster ?? "")
            
            cell.posterImageView.sd_setImage(with: remoteImageURL) { downloadeImage, downloadException, SDImageCache, downloadURL in
                if let downloadException = downloadException{
                    cell.posterImageView.image = UIImage(named: "noimage")
                    print("Error downloading \(downloadException.localizedDescription)")
                }else {
                    print("Succsessfult download : \(String(describing: downloadURL?.absoluteString))")
                }
            }
            cell.titleLBL.text = model.title
    
        }.disposed(by: disposeBag)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension HomeTableViewCell : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2.5
        let heigth = collectionView.bounds.height * 0.8
        return CGSize(width: width, height: heigth)
    }
    
}
extension HomeTableViewCell : UICollectionViewDelegateFlowLayout {
    
}

