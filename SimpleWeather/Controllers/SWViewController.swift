//
//  SWViewController.swift
//  SimpleWeather
//
//  Created by Kevin Xu on 12/7/14.
//  Copyright (c) 2014 Kevin Xu. All rights reserved.
//

import UIKit

class SWViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    // MARK: Properties
    
    private var screenHeight: CGFloat = 0
    private var backgroundImageView: UIImageView?
    private var blurredImageView: UIImageView?
    private var tableView: UITableView?
    
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenHeight = UIScreen.mainScreen().bounds.size.height
        self.layoutViews()
        self.addViewElements()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.backgroundImageView!.frame = self.view.bounds
        self.blurredImageView!.frame = self.view.bounds
        self.tableView!.frame = self.view.bounds
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func layoutViews() {
        let background = UIImage(named: "Background")
        self.backgroundImageView = UIImageView(image: background)
        self.backgroundImageView?.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.blurredImageView = UIImageView()
        self.blurredImageView?.contentMode = UIViewContentMode.ScaleAspectFill
        self.blurredImageView?.alpha = 0
        self.blurredImageView?.setImageToBlur(background, blurRadius: 10, completionBlock: nil)

        self.tableView = UITableView()
        self.tableView?.backgroundColor = UIColor.clearColor()
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.separatorColor = UIColor(white: 1, alpha: 0.2)
        self.tableView?.pagingEnabled = true
        
        self.view.addSubview(self.backgroundImageView!)
        self.view.addSubview(self.blurredImageView!)
        self.view.addSubview(self.tableView!)
    }
    
    func addViewElements() {
        // Height variables
        let headerFrame = UIScreen.mainScreen().bounds
        let inset: CGFloat = 20
        let hiloHeight: CGFloat = 40
        let temperatureHeight: CGFloat = 110
        let iconHeight: CGFloat = 30
        
        // CGRect Frames for sizes and positions
        let hiloFrame = CGRectMake(inset,
            headerFrame.size.height - hiloHeight,
            headerFrame.size.width - (2 * inset),
            hiloHeight)
        let temperatureFrame = CGRectMake(inset,
            headerFrame.size.height - (temperatureHeight + hiloHeight),
            headerFrame.size.width - (2 * inset),
            temperatureHeight)
        let iconFrame = CGRectMake(inset,
            temperatureFrame.origin.y - iconHeight,
            iconHeight,
            iconHeight)
        var conditionsFrame = iconFrame
        conditionsFrame.size.width = self.view.bounds.size.width - (((2 * inset) + iconHeight) + 10)
        conditionsFrame.origin.x = iconFrame.origin.x + (iconHeight + 10)
        
        // UIView elements
        let header = UIView(frame: headerFrame)
        header.backgroundColor = UIColor.clearColor()
        self.tableView?.tableHeaderView = header
        
        let cityLabel = UILabel(frame: CGRectMake(0, 20, self.view.bounds.size.width, 30))
        cityLabel.backgroundColor = UIColor.clearColor()
        cityLabel.textColor = UIColor.whiteColor()
        cityLabel.text = "Loading..."
        cityLabel.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        cityLabel.textAlignment = NSTextAlignment.Center
        
        let iconView = UIImageView(frame: iconFrame)
        iconView.contentMode = UIViewContentMode.ScaleAspectFit
        iconView.backgroundColor = UIColor.clearColor()
        iconView.image = UIImage(named: "weather-clear")
        
        let conditionsLabel = UILabel(frame: conditionsFrame)
        conditionsLabel.backgroundColor = UIColor.clearColor()
        conditionsLabel.textColor = UIColor.whiteColor()
        conditionsLabel.text = "Clear"
        conditionsLabel.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        
        let temperatureLabel = UILabel(frame: temperatureFrame)
        temperatureLabel.backgroundColor = UIColor.clearColor()
        temperatureLabel.textColor = UIColor.whiteColor()
        temperatureLabel.text = "0°"
        temperatureLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 120)
        
        let hiloLabel = UILabel(frame: hiloFrame)
        hiloLabel.backgroundColor = UIColor.clearColor()
        hiloLabel.textColor = UIColor.whiteColor()
        hiloLabel.text = "0° / 0°"
        hiloLabel.font = UIFont(name: "HelveticaNeue-Light", size: 28)
        
        header.addSubview(cityLabel)
        header.addSubview(iconView)
        header.addSubview(conditionsLabel)
        header.addSubview(temperatureLabel)
        header.addSubview(hiloLabel)
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier = "CellIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: CellIdentifier)
        }
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        cell?.backgroundColor = UIColor(white: 0, alpha: 0.2)
        cell?.textLabel.textColor = UIColor.whiteColor()
        cell?.detailTextLabel?.textColor = UIColor.whiteColor()
        
        return cell!
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
}