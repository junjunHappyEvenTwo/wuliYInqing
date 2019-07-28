//
//  ViewController.m
//  物理引擎
//
//  Created by wyx on 2019/7/28.
//  Copyright © 2019年 wyx. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,strong) UIDynamicAnimator *animator;
@property (weak, nonatomic) IBOutlet UIImageView *redView;
@property (nonatomic,strong) UIAttachmentBehavior *attachementBehavior;//吸附行为
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //容器
    _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    //自由落体
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc]initWithItems:@[_redView]];
    [_animator addBehavior:gravity];
    //碰撞
    UICollisionBehavior *coll = [[UICollisionBehavior alloc]initWithItems:@[_redView]];
    [_animator addBehavior:coll];
    coll.translatesReferenceBoundsIntoBoundary = YES;
    
    //反弹效果
    UIDynamicItemBehavior *itemBeha = [[UIDynamicItemBehavior alloc]initWithItems:@[_redView]];
    //弹性系数
    itemBeha.elasticity = .2;
    [_animator addBehavior:itemBeha];
    UIPanGestureRecognizer *tap = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    _redView.userInteractionEnabled = YES;
    [_redView addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)panAction:(UIPanGestureRecognizer *)ges{
    if (ges.state == UIGestureRecognizerStateBegan) {
        UIOffset offset = UIOffsetMake(-60, -60);
        _attachementBehavior = [[UIAttachmentBehavior alloc]initWithItem:_redView offsetFromCenter:offset attachedToAnchor:[ges locationInView:self.view]];
        [_animator addBehavior:_attachementBehavior];
    }else if (ges.state == UIGestureRecognizerStateChanged){
        [_attachementBehavior setAnchorPoint:[ges locationInView:self.view]];
    }else if (ges.state == UIGestureRecognizerStateEnded || ges.state == UIGestureRecognizerStateFailed || ges.state == UIGestureRecognizerStateCancelled){
        [_animator removeBehavior:_attachementBehavior];
    }
}

@end
