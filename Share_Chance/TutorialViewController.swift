//
//  UIPageViewController.swift
//  ShareChance
//
//  Created by Hiroyuki Tamae on 2018/02/12.
//  Copyright © 2018年 Univ of the Ryukyu. All rights reserved.
//

import UIKit

class TutorialViewController: UIPageViewController,UIPageViewControllerDataSource {
    
    let sboard: UIStoryboard? = UIStoryboard(name:"Tutorial", bundle:nil)
    
    var pageViewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //自分自身を指定
        dataSource = self
        //1ページ目をインスタンス化
        let firstViewController: TutorialViewControllerFirst
            = sboard!.instantiateViewController(withIdentifier: "TutorialViewControllerFirst") as! TutorialViewControllerFirst
        //2ページ目をインスタンス化
        let secondViewController: TutorialViewControllerSecond
            = sboard!.instantiateViewController(withIdentifier: "TutorialViewControllerSecond") as! TutorialViewControllerSecond
        //3ページ目をインスタンス化
        let thirdViewController: TutorialViewControllerThird
            = sboard!.instantiateViewController(withIdentifier: "TutorialViewControllerThird") as! TutorialViewControllerThird
        //全ページを配列に格納
        pageViewControllers = [firstViewController,secondViewController,thirdViewController]
        //UIPageViewControllerに表示対象を設定
        setViewControllers([pageViewControllers[0]], direction: .forward, animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func pageViewController(_ pageViewController:
        UIPageViewController, viewControllerBefore viewController:UIViewController) -> UIViewController? {
        //右にスワイプした場合に表示したいviewControllerを返す
        //ようはページを戻す
        //今表示しているページは何ページ目か取得する
        let index = pageViewControllers.index(of: viewController)
        if index == 0 {
            //1ページ目の場合は何もしない
            return nil
        } else {
            //1ページ目の意外場合は1ページ前に戻す
            return pageViewControllers[index!-1]
        }
    }
    
    //全ページ数を返すメソッド
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pageViewControllers.count
    }
    
    //ページコントロールの最初の位置を返すメソッド
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    
    func pageViewController(_ pageViewController:
        UIPageViewController, viewControllerAfter viewController: UIViewController) ->
        UIViewController? {
            //左にスワイプした場合に表示したいviewControllerを返す
            //ようはページを進める
            //今表示しているページは何ページ目か取得する
            let index = pageViewControllers.index(of: viewController)
            if index == pageViewControllers.count-1 {
                //最終ページの場合は何もしない
                return nil
            } else {
                //最終ページの意外場合は1ページ進める
                return pageViewControllers[index!+1]
            }
    }
}
