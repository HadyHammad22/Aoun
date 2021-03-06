//
//  HomeVC.swift
//  Volunteer
//
//  Created by Hady Hammad on 8/28/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UIViewController {
    
    @IBOutlet weak var postsTable: UITableView!
    
    var posts = [Post]()
    let transition = PopAnimator()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPosts()
        transition.dismissCompletion = { [weak self] in
            guard
                let selectedIndexPathCell = self?.postsTable.indexPathForSelectedRow,
                let selectedCell = self?.postsTable.cellForRow(at: selectedIndexPathCell)
                    as? HomeCell
                else {
                    return
            }
            selectedCell.shadowView.isHidden = false
        }
    }
    
    func loadPosts() {
        DataService.db.getPosts(onSuccess: { (arrayOfPosts) in
            if let posts = arrayOfPosts {
                self.posts = posts
                self.postsTable.reloadData()
            }
        })
    }
    
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postsTable.dequeueReusableCell(withIdentifier: "PostCell") as! HomeCell
        cell.configureCell(post: self.posts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let moreDetailsVC = MoreDetailsVC.instance()
        moreDetailsVC.post = self.posts[indexPath.row]
        moreDetailsVC.transitioningDelegate = self
        present(moreDetailsVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0.5
        UIView.animate(withDuration: 0.75){
            cell.alpha = 1.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
}

extension HomeVC: UIViewControllerTransitioningDelegate {
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController, source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            guard
                let selectedIndexPathCell = postsTable.indexPathForSelectedRow,
                let selectedCell = postsTable.cellForRow(at: selectedIndexPathCell)
                    as? HomeCell,
                let selectedCellSuperview = selectedCell.superview
                else {
                    return nil
            }
            
            transition.originFrame = selectedCellSuperview.convert(selectedCell.frame, to: nil)
            transition.originFrame = CGRect(
                x: transition.originFrame.origin.x + 20,
                y: transition.originFrame.origin.y + 20,
                width: transition.originFrame.size.width - 40,
                height: transition.originFrame.size.height - 40
            )
            
            transition.presenting = true
            selectedCell.shadowView.isHidden = true
            
            return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            transition.presenting = false
            return transition
    }
}
