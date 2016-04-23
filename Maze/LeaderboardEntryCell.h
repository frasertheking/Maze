//
//  LeaderboardEntryCell.h
//  Maze
//
//  Created by Fraser King on 2016-04-22.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaderboardEntryCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *profilePicture;
@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *score;
@property (nonatomic, weak) IBOutlet UILabel *rankLabel;
@property (nonatomic, weak) IBOutlet UIView *imageCover;

@end
