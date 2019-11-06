//
//  ViewController.m
//  MyCoreDataDemo
//
//  Created by 陈帆 on 2019/11/6.
//  Copyright © 2019 陈帆. All rights reserved.
//

#import "ViewController.h"

#import "User+CoreDataClass.h"
#import "CoreDataStack.h"


@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) NSMutableArray *dataSource;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, weak) UIButton *addBtn;
@property(nonatomic, weak) UIButton *deleteBtn;
@property(nonatomic, weak) UIButton *modifyBtn;
@property(nonatomic, weak) UIButton *queryBtn;

@property(nonatomic, weak) UILabel *noDataTipLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setViewUI];
}

- (void)setViewUI {
    // 设置增加按钮
    UIButton *addBtn = [[UIButton alloc] init];
    self.addBtn = addBtn;
    [addBtn setTitle:@"增加" forState:UIControlStateNormal];
    addBtn.backgroundColor = [UIColor blueColor];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 设置删除按钮
    UIButton *deleteBtn = [[UIButton alloc] init];
    self.deleteBtn = deleteBtn;
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    deleteBtn.backgroundColor = [UIColor blueColor];
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 设置修改按钮
    UIButton *modifyBtn = [[UIButton alloc] init];
    self.modifyBtn = modifyBtn;
    [modifyBtn setTitle:@"修改" forState:UIControlStateNormal];
    modifyBtn.backgroundColor = [UIColor blueColor];
    [modifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    modifyBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [modifyBtn addTarget:self action:@selector(modifyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 设置查询按钮
    UIButton *queryBtn = [[UIButton alloc] init];
    self.queryBtn = queryBtn;
    [queryBtn setTitle:@"查询" forState:UIControlStateNormal];
    queryBtn.backgroundColor = [UIColor blueColor];
    [queryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    queryBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [queryBtn addTarget:self action:@selector(queryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 没有数据提醒
    UILabel *noDataTipLabel = [[UILabel alloc] init];
    self.noDataTipLabel = noDataTipLabel;
    noDataTipLabel.text = @"没有数据啦";
    noDataTipLabel.textColor = [UIColor lightGrayColor];
    noDataTipLabel.textAlignment = NSTextAlignmentCenter;
    noDataTipLabel.font = [UIFont systemFontOfSize:14.0];
    noDataTipLabel.numberOfLines = 0;
//    noDataTipLabel.hidden = YES;
    
    
    self.tableView.layer.masksToBounds = true;
    self.tableView.layer.cornerRadius = 10;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:addBtn];
    [self.view addSubview:modifyBtn];
    [self.view addSubview:deleteBtn];
    [self.view addSubview:queryBtn];
    self.tableView.backgroundView = self.noDataTipLabel;
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor darkGrayColor];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // 设置布局适配
    int btnWidth = 70, btnHeight = 30, gapXY = 20;
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(gapXY*2);
        make.right.equalTo(self.view.mas_centerX).with.offset(-gapXY/2);
        make.width.mas_equalTo(btnWidth);
        make.height.mas_equalTo(btnHeight);
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(gapXY*2);
        make.left.equalTo(self.view.mas_centerX).with.offset(gapXY/2);
        make.width.mas_equalTo(btnWidth);
        make.height.mas_equalTo(btnHeight);
    }];
    
    [self.modifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addBtn.mas_bottom).with.offset(gapXY);
        make.right.equalTo(self.view.mas_centerX).with.offset(-gapXY/2);
        make.width.mas_equalTo(btnWidth);
        make.height.mas_equalTo(btnHeight);
    }];
    
    [self.queryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.deleteBtn.mas_bottom).with.offset(gapXY);
        make.left.equalTo(self.view.mas_centerX).with.offset(gapXY/2);
        make.width.mas_equalTo(btnWidth);
        make.height.mas_equalTo(btnHeight);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.modifyBtn.mas_bottom).with.offset(gapXY);
        make.left.mas_equalTo(gapXY);
        make.right.mas_equalTo(-gapXY);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-gapXY);
    }];
    
    [self.noDataTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.tableView.mas_centerX);
        make.centerY.mas_equalTo(self.tableView.mas_centerY);
        make.width.mas_equalTo(self.tableView.mas_width);
        make.height.mas_equalTo(btnHeight);
    }];
}

// MARK: - selector action funcation
// MARK: 增加按钮响应
- (void)addBtnClick:(UIButton *)sender {
    if (@available(iOS 13.0, *)) {
        User *user = [[CoreDataStack shareInstance] newUserEntity];
        user.userId = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
        user.username = [NSString stringWithFormat:@"张三%ld", random()];
        user.age = 18;
        user.createTime = [NSDate date];
        user.income = [[NSDecimalNumber alloc] initWithFloat:1233.04338];
        user.isMan = YES;
        user.userIcon = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1573042496310&di=d6b4363fe0bb7455d97672b4d5d0e316&imgtype=jpg&src=http%3A%2F%2Fimg1.imgtn.bdimg.com%2Fit%2Fu%3D4232323981%2C903032036%26fm%3D214%26gp%3D0.jpg";
        
        [[CoreDataStack shareInstance] addUser:user];
        
        // 查询
        [self queryBtnClick:nil];
    } else {
        // Fallback on earlier versions
    }
}

// MARK: 删除按钮响应
- (void)deleteBtnClick:(UIButton *)sender {
    if (@available(iOS 13.0, *)) {
        [[CoreDataStack shareInstance] deleteUser:0];
        
        [self queryBtnClick:nil];
    } else {
        // Fallback on earlier versions
    }
    
    NSLog(@"删除成功");
}

// MARK: 需改按钮响应
- (void)modifyBtnClick:(UIButton *)sender {
    if (self.dataSource.count > 0) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:true scrollPosition:UITableViewScrollPositionTop];
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
}

// MARK: 查询按钮响应
- (void)queryBtnClick:(UIButton *)sender {
    [self.dataSource removeAllObjects];
    if (@available(iOS 13.0, *)) {
        NSArray *userList = [[CoreDataStack shareInstance] getUserList];
        if (userList.count > 0) {
            [self.dataSource addObjectsFromArray:userList];
        }
    } else {
        // Fallback on earlier versions
    }
    
    [self.tableView reloadData];
}


// MARK: - UITableView Delegate
// MARK: section Count
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// MARK: row count in section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.noDataTipLabel.hidden = self.dataSource.count > 0;
    return self.dataSource.count;
}

// MARK: cell content
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.detailTextLabel.numberOfLines = 0;
    }
    
    // 填充数据
    User *user = self.dataSource[indexPath.row];
    cell.textLabel.text = user.username;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"age:%d\ncreateTime:%@\nincome:%@\nisMan:%@\nuserId:%@", user.age, user.createTime, user.income, user.isMan ? @"YES":@"NO", user.userId];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:user.userIcon] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            // 调整图片大小
            CGSize imageSize = CGSizeMake(70, 70);
            UIGraphicsBeginImageContextWithOptions(imageSize, NO, UIScreen.mainScreen.scale);
            [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }];
    
    return cell;
}

// MARK: cell height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

// MARK: did selected
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入个人信息" preferredStyle:UIAlertControllerStyleAlert];
    
    // selected user
    User *user = self.dataSource[indexPath.row];
    
     //增加确定按钮；
     [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         //获取第1个输入框；
         UITextField *userNameTextField = alertController.textFields.firstObject;
         if (![userNameTextField.text isEqual:@""] && ![userNameTextField.text isEqual:user.username]) {
             user.username = userNameTextField.text;
         }
         
         //获取第2个输入框；
         UITextField *ageTextField = [alertController.textFields objectAtIndex:1];
         if (![ageTextField.text isEqual:@""] && ![ageTextField.text isEqual:[NSString stringWithFormat:@"%d", user.age]]) {
             user.age = [ageTextField.text intValue];
         }
         
         //获取第3个输入框；
         UITextField *sexField = alertController.textFields.lastObject;
         if (![sexField.text isEqual:@""]) {
             user.isMan = ![sexField.text isEqual:@"0"];
         }
         if (@available(iOS 13.0, *)) {
             [[CoreDataStack shareInstance] updateUser:user];
         } else {
             // Fallback on earlier versions
         }
         
         [self.tableView reloadData];
     }]];
    // 增加取消按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
        [self.tableView deselectRowAtIndexPath:indexPath animated:true];
    }]];
    
    //定义第一个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
      textField.placeholder = @"请输入用户名";
    }];
    //定义第二个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
      textField.placeholder = @"请输入年龄";
    }];
    //定义第三个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
      textField.placeholder = @"性别";
    }];
    [self presentViewController:alertController animated:true completion:nil];
    
}

// MARK: - get / set 方法

/// get dataSource
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

/// get tableview
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    }
    
    return _tableView;
}

@end
