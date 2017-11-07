//
//  KMHomeViewController.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/2.
//  Copyright © 2017年 KM. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import Closures
import AttributedLib
import Action
class KMHomeViewController: UIViewController {

    
    var navBackground : UIView?
    
    @IBOutlet var bannerView: KMBannerView!
    
    @IBOutlet var pageControl: UIPageControl!
    
    @IBOutlet var tableView: UITableView!
    
    var statusBarView : UIView?
    
    var navAlpha = Variable<CGFloat>(0.0)
    
    var titleSectionNum = Variable(0)
    
    
    var titleView : KMRefreshTitleView?
    
    
    var vm : KMHomeViewModel!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
}
extension KMHomeViewController {
    func setup() {
        avoidAutomaticDown64()
    
        bannerView.bannerDelegate = self
        
        bindNavigation()
        bindViewModel()
        bindTableView()
        bindOffsetY()
    }
    func bindNavigation() {
        let text = "今日热闻".at.attributed {
            return $0
                .font(Font.bold(size: 15))
                .foreground(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
                .alignment(.center)
        }
        titleView = KMRefreshTitleView(with: text)
        navigationItem.titleView = titleView
        
        setNavigationBackgroundColor(with: Color.themeBlue)
        
        
        statusBarView = UIView().then({ (v) in
            v.frame = UIApplication.shared.statusBarFrame
        })
        navigationController?.view.insertSubview(statusBarView!, at: 1)
        
        navBackground = navigationController?.navigationBar.subviews.first
       _ = navBackground?
            .rx.observe(CGFloat.self, "alpha")
            .observeOn(MainScheduler.asyncInstance)
            .filter({ $0 != self.navAlpha.value })
            .subscribe(onNext: { [unowned self] (alpha) in
                self.navBackground?.alpha = self.navAlpha.value
            })
            .disposed(by: rx.disposeBag)
        
        navAlpha
            .asObservable()
            .subscribe(onNext: { [unowned self] (alpha) in
               self.navBackground?.alpha = alpha
            })
            .disposed(by: rx.disposeBag)
        
        titleSectionNum
            .asObservable()
            .distinctUntilChanged()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self] (section) in
                if section == 0 {
                    self.titleView?.text = text
                }else{
                    if let date = self.vm.stories.value.item(at: section)?.date {
                        let dateText = Tool.homeSectionHeaderString(with: date)
                        self.titleView?.text = dateText.at.attributed({
                            return $0
                                .font(Font.size(size: 15))
                                .foreground(color: .white)
                                .alignment(.center)
                        })
                    }
                }
            })
            .disposed(by: rx.disposeBag)
        
    }
    
    func bindViewModel() {
        vm = KMHomeViewModel()
        vm
            .top_stories
            .asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .filter({ $0.count != 0 })
            .subscribe(onNext: { [unowned self] (top_stories) in
                //轮播图
                    var arr = top_stories
                    arr.insert(arr.last!, at: 0)
                    arr.append(arr[1])
                    self.bannerView.top_stories.value = arr
                    self.pageControl.numberOfPages = top_stories.count
                    self.titleView?.endRefresh()
            })
            .disposed(by: rx.disposeBag)

        vm
            .stories
            .asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { (_) in
                self.tableView.reloadData()
            })
            .disposed(by: rx.disposeBag)
        
        let draggingRefresh = tableView
            .rx
            .didEndDragging
            .filter { _ in self.tableView.contentOffset.y <= -64 }
            .flatMapLatest { _ in Observable.just(()) }
        let initRefresh = Observable.just(())
        
        Observable
            .of(initRefresh, draggingRefresh)
            .merge()
            .share(replay: 1, scope: .whileConnected)
            .subscribe(onNext: { _ in
                self.titleView?.beginRefresh {
                    self.vm.loadNewDataCommand.onNext(())
                }
            }).disposed(by: rx.disposeBag)
    }
    
    func bindTableView() {
        
        tableView.rowHeight = Config.homeRowHeight
        tableView.separatorColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
        tableView.layoutMargins = UIEdgeInsetsMake(0, 15, 0, 15)
        
        tableView.register(headerFooterViewClassWith: KMHomeSectionHeaderView.self)
    
        tableView
            .heightForHeaderInSection { (section) -> CGFloat in
                return section == 0 ? 0 : Config.homeSectionHeight
            }
            .heightForFooterInSection { (_) -> CGFloat in
                return 0.01
            }
            .numberOfSectionsIn { [unowned self] () -> Int in
                return self.vm.stories.value.count
            }
            .numberOfRows { [unowned self] (section) -> Int in
                return self.vm.stories.value.item(at: section)?.stories?.count ?? 0
            }
            .cellForRow { [unowned self] (index) -> UITableViewCell in
                let cell = self.tableView.dequeueReusableCell(withClass: KMStoryListCell.self)!
                let story = self.vm.stories.value.item(at: index.section)?.stories?.item(at: index.row)
                cell.bindStoryModel(with: story!)
                return cell
            }
            .didSelectRowAt { [unowned self] (index) in
                self.tableView.deselectRow(at: index, animated: true)
            }
            .viewForHeaderInSection(handler: { [unowned self] (section) -> UIView? in
                let header = self.tableView.dequeueReusableHeaderFooterView(withClass: KMHomeSectionHeaderView.self)
                if let date = self.vm.stories.value.item(at: section)?.date {
                    header?.sectionTitle = Tool.homeSectionHeaderString(with: date)
                }
                return header
            })
            .willDisplay(handler: { [unowned self] (_, index) in
                if index.section == self.vm.stories.value.count - 1 && index.row == 0 {
                    self.vm.loadMoreDaraCommand.onNext(())
                }
            })
            .didEndDecelerating { [unowned self] (scrollView) in
                self.titleView?.reset()
        }
    }
    
    func bindOffsetY() {
        let offsetY = tableView
            .rx
            .contentOffset
            .asDriver()
            .map({ $0.y })
            .distinctUntilChanged()
        
        offsetY
            .asObservable()
            .bind(to: self.bannerView.offsetY)
            .disposed(by: rx.disposeBag)
        
        offsetY
            .map { (y) -> CGFloat in
                var alpha = y / Config.topStoryViewHeight
                alpha > 1.0 ? alpha = 1.0 : nil
                alpha < 0.0 ? alpha = 0.0 : nil
                return alpha
            }
            .asObservable()
            .bind(to: self.navAlpha)
            .disposed(by: rx.disposeBag)
        
        let tableViewY = offsetY.map { (self.tableView, $0) }.asDriver(onErrorJustReturn: (self.tableView!, 0))
        
        tableViewY.drive(onNext: { (tv, y) in
            if y < Config.minOffsetY {
                tv.contentOffset = CGPoint(x: 0, y: Config.minOffsetY)
                return
            }
            self.titleView?.pullToRefresh(progress: -y/Config.pullToRefreshHeight)
            
   
            let topStoryViewHeight = Config.topStoryViewHeight
            let rowHeight = Config.homeRowHeight
            let fristSectionHeight : CGFloat = topStoryViewHeight + tv.numberOfRows(inSection: 0).cgFloat * rowHeight - KStatusBarHeight
            
            if y > fristSectionHeight && self.navBackground?.isHidden == false {
               self.navBackground?.isHidden = true
                self.statusBarView?.backgroundColor = Color.themeBlue
                tv.contentInset = UIEdgeInsetsMake(KStatusBarHeight, 0, 0, 0)
            }
            if y < fristSectionHeight && self.navBackground?.isHidden == true {
                 self.navBackground?.isHidden = false
                self.statusBarView?.backgroundColor = UIColor.clear
                tv.contentInset = UIEdgeInsets.zero
            }
            self.titleView?.isHidden = (self.navBackground?.isHidden)!
        })
            .disposed(by: rx.disposeBag)
    }
}

extension KMHomeViewController : BannerDelegate {
    func selectedItem(model: Story) {
        log.debug("\(model)")
    }
    func scrollTo(index: Int) {
        pageControl.currentPage = index
    }
}
