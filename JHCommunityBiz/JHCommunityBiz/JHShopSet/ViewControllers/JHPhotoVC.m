//
//  JHAlbumVC.m
//  JHCommunityBiz
//
//  Created by jianghu1 on 16/8/29.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHPhotoVC.h"
#import "JHPhotoCollectionCell.h"
#import "DisplayImageInView.h"
#import "JHPhotoCollectionCellAdd.h"
#import "XHChoosePhoto.h"
#import "JHPhotoCollectionCellModel.h"
@interface JHPhotoVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,retain)NSMutableArray *dataArr;
@end
@implementation JHPhotoVC
{
    UIButton *rightBtn;
    UIButton *deleteBtn;
    NSInteger type;
    NSMutableArray *deleteIDArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self addRightBtn];
    [self addBottomBtn];
    [self.view addSubview:self.collectionView];
    //获取数据
    [self loadNewData];
}
- (void)initData
{
    self.navigationItem.title = _titleStr;
    _dataArr = @[].mutableCopy;
    deleteIDArr  = @[].mutableCopy;
    if ([_titleStr isEqualToString:NSLocalizedString(@"环境相册", nil)]) type=1;
    if ([_titleStr isEqualToString:NSLocalizedString(@"商品相册", nil)]) type=2;
}
//添加右上角编辑按钮
- (void)addRightBtn
{
    //未选中时为未完成订单,选中时为已完成订单
    rightBtn = [[UIButton alloc] initWithFrame:FRAME(0, 0, 55, 80)];
    [rightBtn setTitle:NSLocalizedString(@"编辑", nil) forState:(UIControlStateNormal)];
    rightBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [rightBtn setTitleColor:HEX(@"ffffff", 1.0f) forState:(UIControlStateNormal)];
    rightBtn.titleLabel.font = FONT(16);
    [rightBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}
#pragma mark - 添加底部按钮
- (void)addBottomBtn
{
    deleteBtn =  [UIButton new];
    [self.view addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).with.offset(-50);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    deleteBtn.layer.cornerRadius = 3;
    deleteBtn.layer.masksToBounds = YES;
    deleteBtn.backgroundColor = HEX(@"ffffff", 1.0);
    CALayer *line = [CALayer layer];
    line.backgroundColor = LINE_COLOR.CGColor;
    line.frame = FRAME(0, 0, WIDTH, 0.5);
    [deleteBtn.layer addSublayer:line];
    [deleteBtn setTitle:NSLocalizedString(@"确认删除", nil) forState:(UIControlStateNormal)];
    [deleteBtn setTitleColor:HEX(@"666666", 1.0) forState:(UIControlStateNormal)];
    [deleteBtn addTarget:self action:@selector(clickToDelete:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)loadNewData
{
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/shop/album/items"
               withParams:@{@"type":@(type)}
                  success:^(id json) {
                      NSLog(@"biz/shop/album/items----%@",json);
                      if (ERROR_0) {
                          [_dataArr removeAllObjects];
                           rightBtn.selected = NO;
                          [deleteIDArr removeAllObjects];
                          deleteBtn.backgroundColor = HEX(@"ffffff", 1.0);
                          [deleteBtn setTitleColor:HEX(@"333333", 1.0) forState:(UIControlStateNormal)];
                          [deleteBtn removeTarget:self action:@selector(clickToDelete:) forControlEvents:UIControlEventTouchUpInside];
                          //-------
                          for (NSDictionary *dataDic in json[@"data"][@"items"]) {
                              JHPhotoCollectionCellModel *model = [[JHPhotoCollectionCellModel alloc] init];
                              model.url = dataDic[@"photo"];
                              model.status = 0;
                              model.photo_id = dataDic[@"photo_id"];
                              [_dataArr addObject:model];
                          }
                          [_collectionView reloadData];
   
                      }else{
                        [JHShowAlert showAlertWithMsg:ERROR_MESSAGE];
                      }
                      HIDE_HUD
                  } failure:^(NSError *error) {
                      HIDE_HUD
                  }];
}

- (UICollectionView *)collectionView
{
    _collectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((WIDTH - 15)/2,(WIDTH - 15)/2/29*22 );
        //设置上下左右的留白
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        UICollectionView *collection = [[UICollectionView alloc] initWithFrame:FRAME(5, 5, WIDTH-10, HEIGHT - 64 -50-5) collectionViewLayout:layout];
        collection.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
        //注册
        [collection registerClass:[JHPhotoCollectionCell class] forCellWithReuseIdentifier:@"JHPhotoCollectionCellID"];
        [collection registerClass:[JHPhotoCollectionCellAdd class] forCellWithReuseIdentifier:@"JHPhotoCollectionCellAddID"];
        collection.delegate = self;
        collection.dataSource = self;
        collection;
    });
    return _collectionView;
}
#pragma mark - 返回多少单元格
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count+1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _dataArr.count) {
        JHPhotoCollectionCellAdd *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"JHPhotoCollectionCellAddID" forIndexPath:indexPath];
        [cell.addBtn addTarget:self action:@selector(clickAddBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        return cell;
        
    }else{
        JHPhotoCollectionCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"JHPhotoCollectionCellID" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        cell.dataModel = _dataArr[indexPath.row];
        [cell.indicateIV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(clickIndicateIV:)]];
        return cell;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    NSMutableArray *urlArr = @[].mutableCopy;
    for (JHPhotoCollectionCellModel *model in _dataArr) {
        [urlArr addObject:[IMAGEADDRESS stringByAppendingString:model.url]];
    }
    __block DisplayImageInView *imgView = [DisplayImageInView new];
    [imgView showInViewWithImageUrlArray:urlArr withIndex:index+1 withBlock:^{
        
        [imgView removeFromSuperview];
        imgView = nil;
    }];
}
- (void)clickAddBtn:(UIButton *)sender
{
   //选择照片
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil)
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:NSLocalizedString(@"相册", nil)
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        
                                                        XHChoosePhoto *xhchooseP = [[XHChoosePhoto alloc] init];
                                                        xhchooseP.scaleSize = CGSizeMake(400, 400);
                                                        [self addChildViewController:xhchooseP];
                                                        [xhchooseP startChoosePhoto];
                                                        __weak typeof(self)weakSelf = self;
                                                        [xhchooseP setGetImageBlock:^(UIImage *selectedImage,NSData *imageData){
                                                            [weakSelf uploadPic:imageData];
                                                            
                                                        }];
                                                    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:NSLocalizedString(@"拍照", nil)
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        
                                                        XHChoosePhoto *xhchooseP = [[XHChoosePhoto alloc] init];
                                                        xhchooseP.scaleSize = CGSizeMake(400, 400);
                                                        [self addChildViewController:xhchooseP];
                                                        [xhchooseP startTakePhoto];
                                                        __weak typeof(self)weakSelf = self;
                                                        [xhchooseP setGetImageBlock:^(UIImage *selectedImage,NSData *imageData){
                                                            [weakSelf uploadPic:imageData];
                                                            
                                                        }];
                                                    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [self presentViewController:alert animated:YES completion:nil];
    
}
#pragma mark - 上传新图片
- (void)uploadPic:(NSData *)data
{
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/shop/album/upload"
                   params:@{@"type":@(type)}
                  dataDic:@{@"photo":data}
                  success:^(id json) {
                      NSLog(@"biz/shop/album/upload--%@",json);
                      HIDE_HUD
                      if (ERROR_0) {
                          //刷新界面
                          __weak typeof(self)weakSelf = self;
                          [weakSelf loadNewData];
                      }else{
                          [JHShowAlert showAlertWithMsg:ERROR_MESSAGE];
                      }
                  } failure:^(NSError *error) {
                      [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器异常", nil)];
                      HIDE_HUD
                  }];
}
#pragma mark - 点击编辑和全选
- (void)clickRightBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
    BOOL isSelected = sender.selected;
    if (isSelected) {//点击编辑 变为全选
        [rightBtn setTitle:NSLocalizedString(@"全选", nil) forState:(UIControlStateNormal)];
        if (_dataArr.count == 0) {
            return;
        }else{
            //将模型中的状态改为1
            for (JHPhotoCollectionCellModel *model in _dataArr) {
                model.status = 1;
                if ([deleteIDArr containsObject:model.photo_id]) {
                    [deleteIDArr removeObject:model.photo_id];
                }
            }
            [_collectionView reloadData];
        }
    }else{//全选
        [rightBtn setTitle:NSLocalizedString(@"取消全选", nil) forState:(UIControlStateNormal)];
        if (_dataArr.count == 0) {
            return;
        }else{
            //将模型中的状态改为1
            for (JHPhotoCollectionCellModel *model in _dataArr) {
                model.status = 2;
                if (![deleteIDArr containsObject:model.photo_id]) {
                    [deleteIDArr addObject:model.photo_id];
                }
            }
            
            [_collectionView reloadData];
            
        }
    }
    if (deleteIDArr.count == 0) {
        deleteBtn.backgroundColor = HEX(@"ffffff", 1.0);
        [deleteBtn setTitleColor:HEX(@"333333", 1.0) forState:(UIControlStateNormal)];
        [deleteBtn removeTarget:self action:@selector(clickToDelete:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        deleteBtn.backgroundColor = HEX(@"faaf19", 1.0);
        [deleteBtn setTitleColor:HEX(@"ffffff", 1.0) forState:(UIControlStateNormal)];
        [deleteBtn addTarget:self action:@selector(clickToDelete:) forControlEvents:UIControlEventTouchUpInside];
    }
}
#pragma mark - 点击指示图
- (void)clickIndicateIV:(UITapGestureRecognizer *)gesture
{
    UIImageView *indicateIV = (UIImageView *)gesture.view;
    indicateIV.highlighted = !indicateIV.highlighted;
    JHPhotoCollectionCell *cell = (JHPhotoCollectionCell *)[indicateIV superview];
    NSIndexPath *indexPath = [_collectionView indexPathForCell:cell];
    JHPhotoCollectionCellModel *model = _dataArr[indexPath.row];
    model.status = indicateIV.highlighted ? 2 : 1;
    NSString *photo_id = model.photo_id;
    if(indicateIV.highlighted){
        if (![deleteIDArr containsObject:photo_id]) {
            [deleteIDArr addObject:photo_id];
        }
    }else{
        if ([deleteIDArr containsObject:photo_id]) {
            [deleteIDArr removeObject:photo_id];
        }
    }
    if (deleteIDArr.count == 0) {
        deleteBtn.backgroundColor = HEX(@"ffffff", 1.0);
        [deleteBtn setTitleColor:HEX(@"333333", 1.0) forState:(UIControlStateNormal)];
        [deleteBtn removeTarget:self action:@selector(clickToDelete:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        deleteBtn.backgroundColor = HEX(@"faaf19", 1.0);
        [deleteBtn setTitleColor:HEX(@"ffffff", 1.0) forState:(UIControlStateNormal)];
        [deleteBtn addTarget:self action:@selector(clickToDelete:) forControlEvents:UIControlEventTouchUpInside];
    }
}
#pragma mark - 点击删除按钮
- (void)clickToDelete:(UIButton *)sender
{
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/shop/album/delete"
               withParams:@{@"photo_id":deleteIDArr}
                  success:^(id json) {
                      NSLog(@"biz/shop/album/delete--%@",json);
                      HIDE_HUD
                      if (ERROR_0) {
                          //刷新界面
                          __weak typeof(self)weakSelf = self;
                          [weakSelf loadNewData];
                      }else{
                          [JHShowAlert showAlertWithMsg:ERROR_MESSAGE];
                      }
                  } failure:^(NSError *error) {
                      [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器异常", nil)];
                      HIDE_HUD
                  }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
