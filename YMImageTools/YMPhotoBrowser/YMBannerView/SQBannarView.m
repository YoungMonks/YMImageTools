//
//  SQBannarView.m
//  pushImage
//
//  Created by 张江威 on 2017/11/10.
//  Copyright © 2017年 YoungMonk. All rights reserved.
//

#import "SQBannarView.h"
#import "SQBannerCollectionViewCell.h"
#define MaxSections 100


@interface SQBannarView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) NSMutableArray *imageViews;
@property (strong, nonatomic) UICollectionView *myCollectionView;
@property (strong, nonatomic) UIPageControl *mypageControl;
@property (assign, nonatomic) CGSize viewSize;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation SQBannarView

- (void)dealloc{
    _imageViews = nil;
    [self removeNSTimer];
}

- (NSMutableArray *)imageViews{
    if (!_imageViews) {
        _imageViews = @[].mutableCopy;
    }
    
    return _imageViews;
}


- (id)initWithFrame:(CGRect)frame viewSize:(CGSize)viewSize{
    self = [super initWithFrame:frame];
    if (self) {
        self.viewSize = viewSize;
//        if (_isTimer) {
//            [self addNSTimer];
//        }
    }
    
    return self;
}


- (UICollectionView *)myCollectionView{
    
    if (!_myCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(self.viewSize.width, self.viewSize.height);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.viewSize.width, self.viewSize.height) collectionViewLayout:flowLayout];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.showsHorizontalScrollIndicator = NO;
        _myCollectionView.pagingEnabled = YES;
        _myCollectionView.backgroundColor = [UIColor clearColor];
        [_myCollectionView registerNib:[UINib nibWithNibName:@"SQBannerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SQBannerCollectionViewCell"];
        [_myCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:MaxSections / 2] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        [self addSubview:_myCollectionView];
        _mypageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((self.viewSize.width-100)/2, self.viewSize.height-20-5, 100, 20)];
        _mypageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _mypageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
        [self addSubview:_mypageControl];
          
    }
    return _myCollectionView;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return MaxSections;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SQBannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SQBannerCollectionViewCell" forIndexPath:indexPath];
    if (_items.count<1||_items == nil) {
        cell.imageView.image = [UIImage imageNamed:@"img_none_list_small.png"];
    }else{
        cell.imageView.image = _items[indexPath.row];
    }
    return cell;
    
}

- (void)setItems:(NSArray *)items{
    [self removeNSTimer];
    _items = items;
    if (_items.count<1||_items == nil) {
        self.myCollectionView.scrollEnabled = NO;
        [self.mypageControl setHidden:YES];
    }else if (_items.count<2) {
        self.myCollectionView.scrollEnabled = NO;
        [self.mypageControl setHidden:YES];
    }else{
        self.myCollectionView.scrollEnabled = YES;
        [self.mypageControl setHidden:NO];
        
    }
    [self.myCollectionView reloadData];
    self.mypageControl.numberOfPages = _items.count;
    
    if (_isTimer) {
        [self addNSTimer];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int page = (int)(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5) % _items.count;
    self.mypageControl.currentPage = page;
    
}



#pragma mark -添加定时器


-(void)addNSTimer{
    
    _timer =[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}


- (void)nextPage{
    
    if (_items.count<2) {
        return;
    }
    
    NSIndexPath *currentIndexPath = [[self.myCollectionView indexPathsForVisibleItems] lastObject];
    NSIndexPath *currentIndexPathSet = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:MaxSections / 2];
    [self.myCollectionView scrollToItemAtIndexPath:currentIndexPathSet atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    NSInteger nextItem = currentIndexPathSet.item + 1;
    NSInteger nextSection = currentIndexPathSet.section;
    if (nextItem == _items.count) {
        nextItem = 0;
        nextSection ++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    [self.myCollectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.imageViewClick) {
        self.imageViewClick(self,indexPath.row);
    }
}


#pragma mark -删除定时器

-(void)removeNSTimer{
    [_timer invalidate];
    _timer =nil;
}


#pragma mark -当用户开始拖拽的时候就调用移除计时器
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeNSTimer];
}
#pragma mark -当用户停止拖拽的时候调用添加定时器
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_isTimer) {
        [self addNSTimer];
    }
}



- (void)imageViewClick:(void (^)(SQBannarView *, NSInteger))block{
    self.imageViewClick = block;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
