//
//  QitaListViewController.swift
//  qiitaList
//
//  Created by 山崎友弘 on 2015/04/11.
//  Copyright (c) 2015年 basic. All rights reserved.
//

import UIKit
let CellId = "CellId"

class QitaListViewController: UIViewController,UITableViewDelegate ,UITableViewDataSource{
    private var qiitList: [AnyObject] = []
    private var table:UITableView!
    private var mRequestTask: NSURLSessionDataTask?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        table = UITableView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.size.height - 50), style: UITableViewStyle.Plain);
        let reloadBtn:UIButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton;
        
        reloadBtn.setTitle("更新", forState: UIControlState.Normal);
        reloadBtn.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal);
        reloadBtn.sizeToFit();
        reloadBtn.center = CGPointMake(self.view.frame.width / 2,self.view.frame.height - 20);
        
        
        self.view.addSubview(table);
        self.view.addSubview(reloadBtn);
        
        reloadBtn.addTarget(self, action: "tableUpdate:", forControlEvents: UIControlEvents.TouchUpInside)
        table.delegate   = self;
        table.dataSource = self;
    }
    
    func tableUpdate(sender:UIButton){
        qiitList = []
        var request = NSMutableURLRequest(URL: NSURL(string: "https://qiita.com/api/v2/items")!)
        request.HTTPMethod = "GET"
        mRequestTask?.cancel();
        mRequestTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { data, response, error in
            if (error == nil) {
                var error:NSErrorPointer = NSErrorPointer()
                var originList = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: error) as? [[String:AnyObject]]
                
                for origin in originList!{
                    self.qiitList.append(origin["title"] as! String)
                }
            } else {
                println(error)
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.table.reloadData()
            })
        })
        mRequestTask!.resume()
    }
    
    
    // MARK: - DataSourceメソッド
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellId);
        cell.textLabel?.text = qiitList[indexPath.row] as? String
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return qiitList.count ?? 0;
    }
}