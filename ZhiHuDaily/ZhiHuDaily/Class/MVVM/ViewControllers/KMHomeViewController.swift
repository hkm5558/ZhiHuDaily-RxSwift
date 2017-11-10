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

class KMHomeViewController: UIViewController {
    
    @IBOutlet var bannerView: KMBannerView!
    
    @IBOutlet var pageControl: UIPageControl!
    
    @IBOutlet var tableView: UITableView!
    
    var titleSectionNum = Variable(0)
    
    var titleView : KMRefreshTitleView?
    
    var vm : KMHomeViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
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
        
        km_setNavigationBarAlpha(0)
        km_setNavigationBarBackgroundColor(Color.themeBlue)
        
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
                    self.bannerView.startScroll()
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
                let story = self.vm.stories.value.item(at: index.section)?.stories?.item(at: index.row)
                self.pushNewsDetailVC(with: story)
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
            .map({ (y) -> CGFloat in
            var alpha = y / Config.topStoryViewHeight
            alpha > 1.0 ? alpha = 1.0 : nil
            alpha < 0.0 ? alpha = 0.0 : nil
            return alpha
        })
            .asDriver(onErrorJustReturn: 0)
            .drive(onNext: { (alpha) in
                self.km_setNavigationBarAlpha(alpha)
            })
            .disposed(by: rx.disposeBag)
        
        let tableViewY = offsetY
            .map { (self.tableView, $0) }
            .asDriver(onErrorJustReturn: (self.tableView!, 0))
        
        tableViewY.drive(onNext: { (tv, y) in
            if y < Config.minOffsetY {
                tv.contentOffset = CGPoint(x: 0, y: Config.minOffsetY)
                return
            }
            self.titleView?.pullToRefresh(progress: -y/Config.pullToRefreshHeight)

            if tv.numberOfSections > 1 {
                let headerY = tv.rectForHeader(inSection: 1).origin.y
            
//                let bar = self.navigationController?.navigationBar
                
                if (y + KStatusBarHeight) > headerY && self.km_navigationBarTranslationY == 0 {
                    self.km_setNavigationBarTranslationY(-Config.homeSectionHeight)
                    self.navigationItem.titleView?.isHidden = true
                    tv.contentInset = UIEdgeInsetsMake(KStatusBarHeight, 0, 0, 0)
                }

                if (y + KStatusBarHeight) < headerY && self.km_navigationBarTranslationY == -Config.homeSectionHeight {
                    self.km_setNavigationBarTranslationY(0)
                    self.navigationItem.titleView?.isHidden = false
                    tv.contentInset = UIEdgeInsets.zero
                }
            }
        })
            .disposed(by: rx.disposeBag)
    }
}
//MARK: - Push
fileprivate extension KMHomeViewController {
    func pushNewsDetailVC(with story : Story?) {
        if let story = story {
            let vc = KMDetailViewController()
            vm.stories.value.forEach({ (stories) in
                stories.stories?.forEach({ (story) in
                    vc.idArr.append(story.id!)
                })
            })
            vc.id = story.id!
            self.navigationController?.pushViewController(vc, completion: {
                self.slideMenuController()?.removeLeftGestures()
            })
        }
    }
}

extension KMHomeViewController : BannerDelegate {
    func selectedItem(model: Story) {
        pushNewsDetailVC(with: model)
    }
    func scrollTo(index: Int) {
        pageControl.currentPage = index
    }
}
