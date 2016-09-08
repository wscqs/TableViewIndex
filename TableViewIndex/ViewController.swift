//
//  ViewController.swift
//  TableViewIndex
//
//  Created by mba on 16/9/7.
//  Copyright © 2016年 mbalib. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var userArray: NSMutableArray = NSMutableArray()
    var sectionsArray: NSMutableArray = NSMutableArray()
    
    
    var indexArray: [String] = [String]()
    
    // uitableView 索引搜索工具类
    var collation: UILocalizedIndexedCollation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.configureSection()
    }
  
    func configureSection() {
        for i in 0...3 {
            userArray.addObject(User(name: "合理\(i)"))
            userArray.addObject(User(name: "a合理\(i)"))
            userArray.addObject(User(name: "你合理\(i)"))
            userArray.addObject(User(name: "咯合理\(i)"))
            userArray.addObject(User(name: "g合理\(i)"))
        }
        userArray.addObject(User(name: "咯理"))
        
        //获得当前UILocalizedIndexedCollation对象并且引用赋给collation,A-Z的数据
        collation = UILocalizedIndexedCollation.currentCollation()
        //获得索引数和section标题数
        let sectionTitlesCount:NSInteger = collation!.sectionTitles.count

        //临时数据，存放section对应的userObjs数组数据
        let newSectionsArray = NSMutableArray(capacity: sectionTitlesCount)

        //设置sections数组初始化：元素包含userObjs数据的空数据
        for _ in 0..<sectionTitlesCount {
            let array = NSMutableArray()
            newSectionsArray.addObject(array)
        }
        
        //将用户数据进行分类，存储到对应的sesion数组中
        for bean in userArray {
            //根据timezone的localename，获得对应的的section number
            let sectionNumber = collation?.sectionForObject(bean, collationStringSelector: Selector("name"))
            
            //获得section的数组
            let sectionBeans = newSectionsArray.objectAtIndex(sectionNumber!)
            
            //添加内容到section中
            sectionBeans.addObject(bean)
        }
        
         //排序，对每个已经分类的数组中的数据进行排序，如果仅仅只是分类的话可以不用这步
        for i in 0..<sectionTitlesCount {
            let beansArrayForSection = newSectionsArray.objectAtIndex(i)
             //获得排序结果
            let sortedBeansArrayForSection = collation?.sortedArrayFromArray(beansArrayForSection as! [AnyObject], collationStringSelector:  Selector("name"))
            //替换原来数组
            newSectionsArray.replaceObjectAtIndex(i, withObject: sortedBeansArrayForSection!)
        }
        
        sectionsArray = newSectionsArray
        
    }
}

// MARK: - tableviewDelegate
extension ViewController{
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (collation?.sectionTitles.count)!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let beanInSection = sectionsArray.objectAtIndex(section)
        return beanInSection.count!
    }
    
    //设置每行的cell的内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let id = "id"
        var cell = tableView.dequeueReusableCellWithIdentifier(id)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: id)
        }
        let userNameInSection = sectionsArray.objectAtIndex(indexPath.section)
         let bean = userNameInSection.objectAtIndex(indexPath.row)
        cell?.textLabel?.text = bean.name
        return cell!
    }
    
    /*
     * 跟section有关的设定
     */
    //设置section的Header
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let beansInSection = sectionsArray.objectAtIndex(section)
        if beansInSection.count <= 0 {
            return nil
        }
        if let headserString = collation?.sectionTitles[section] {
            if !indexArray.contains(headserString) {
                indexArray.append(headserString)
            }
            return headserString
        }
        return nil
    }
    
    //设置索引标题
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
//        return collation?.sectionTitles
        return indexArray
    }
    
    //关联搜索
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return (collation?.sectionForSectionIndexTitleAtIndex(index))!
    }
}


class User: NSObject{
    var name: String?
    init(name: String){
        self.name = name
    }
}

