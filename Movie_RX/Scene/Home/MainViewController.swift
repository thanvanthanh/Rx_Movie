//
//  MainViewController.swift
//  Movie_RX
//
//  Created by Thân Văn Thanh on 09/07/2021.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class MainViewController: UIViewController {

    private let apiCalling = APICalling()
    private let disposeBag = DisposeBag()
    let fullView : CGFloat = 50
    var partialView: CGFloat {
        return UIScreen.main.bounds.height - 50
    }
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(MainViewController.panGesture))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
        
        tableView.delegate = self
//        tableView.separatorStyle = .none
        
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        
        let request = APIRequest()
        let result : Observable<[MovieSearch]> = self.apiCalling.send(apiRequest: request)
        _ = result.bind(to: tableView.rx.items(cellIdentifier: "MovieTableViewCell", cellType: MovieTableViewCell.self)) {(row , model , cell)in
            let remoteImageURL = URL(string: model.poster ?? "")
            
            cell.posterImage.sd_setImage(with: remoteImageURL) { downloadeImage, downloadException, SDImageCache, downloadURL in
                if let downloadException = downloadException{
                    cell.posterImage.image = UIImage(named: "noimage")
                    print("Error downloading \(downloadException.localizedDescription)")
                }else {
                    print("Succsessfult download : \(String(describing: downloadURL?.absoluteString))")
                }
            }
            cell.textTitle.text = model.title
    
        }.disposed(by: disposeBag)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareBackgroundView()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            let frame = self?.view.frame
            let yComponent = self?.partialView
            self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: frame!.height - 0)
        })
    }
    @objc func panGesture(_ recognizer : UIPanGestureRecognizer){
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)

        let y = self.view.frame.minY
        if (y + translation.y >= fullView) && (y + translation.y <= partialView) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                }
                
                }, completion: { [weak self] _ in
                    if ( velocity.y < 0 ) {
                        self?.tableView.isScrollEnabled = true
                    }
            })
        }
    }
    
    func prepareBackgroundView(){
        let blurEffect = UIBlurEffect.init(style: .dark)
        let visuaEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visuaEffect)
        visuaEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds
        view.insertSubview(bluredView, at: 0)
        
    }

}
extension MainViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height * 0.6
    }
}

extension MainViewController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
        let direction = gesture.velocity(in: view).y

        let y = view.frame.minY
        if (y == fullView && tableView.contentOffset.y == 0 && direction > 0) || (y == partialView) {
            tableView.isScrollEnabled = false
        } else {
            tableView.isScrollEnabled = true
        }
        
        return false
    }
}
