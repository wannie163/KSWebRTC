//
//  KSVideoCallView.m
//  KSWebRTC
//
//  Created by saeipi on 2020/8/2.
//  Copyright © 2020 saeipi. All rights reserved.
//

#import "KSVideoCallView.h"
#import "KSVideoLayout.h"
#import "KSLocalView.h"

@interface KSVideoCallView()

@property(nonatomic,weak)UIScrollView *scrollView;
@property(nonatomic,weak)KSLocalView *localView;
@property(nonatomic,strong)NSMutableArray *remoteKits;
@property(nonatomic,strong)KSVideoLayout *layout;
@end

@implementation KSVideoCallView

- (instancetype)initWithFrame:(CGRect)frame layout:(KSVideoLayout *)layout {
    if (self = [super initWithFrame:frame]) {
        self.layout = layout;
        [self initKit];
    }
    return self;
}

- (void)initKit {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView = scrollView;
    [self addSubview:scrollView];
}

- (void)createLocalViewWithSize:(CGSize)size resizingMode:(KSResizingMode)resizingMode {
    CGRect rect = CGRectZero;
    switch (resizingMode) {
        case KSResizingModeTile:
            rect = CGRectMake(_layout.layout.hpadding, _layout.layout.vpadding, size.width, size.height);
            break;
        case KSResizingModeScreen:
            rect = self.bounds;
            break;
        default:
            break;
    }
    KSLocalView *localView = [[KSLocalView alloc] initWithFrame:rect];
    [self.scrollView addSubview:localView];
}

- (void)setLocalViewSession:(AVCaptureSession *)session {
    [_localView setLocalViewSession:session];
}

-(CGPoint)pointOfIndex:(NSInteger)index {
    int x = 0;
    int y = 0;
    if (index == 1) {
        x = _layout.layout.width + _layout.layout.hpadding;
        y = _layout.layout.vpadding;
    }
    else {
        if ((index % 2) != 0) {
            x = _layout.layout.width + _layout.layout.hpadding;
        }
        y = _layout.layout.vpadding + (index / 2) * _layout.layout.height + _layout.layout.vpadding * (index / 2);
    }
    return CGPointMake(x, y);
}

-(void)layoutRemoteViews {
    for (int index = 1; index <= _remoteKits.count; index++) {
        CGPoint point= [self pointOfIndex:(int)_remoteKits.count + 1];
        KSEAGLVideoView *remoteView = _remoteKits[index];
        remoteView.frame = CGRectMake(point.x, point.y, _layout.layout.width, _layout.layout.height);
    }
    if (_remoteKits.lastObject) {
        KSEAGLVideoView *remoteView = _remoteKits.lastObject;
        if (remoteView.frame.origin.y + _layout.layout.height > self.bounds.size.height) {
            _scrollView.contentSize = CGSizeMake(self.bounds.size.width, remoteView.frame.origin.y + _layout.layout.height);
        }
    }
}

- (void)leaveOfHandleId:(NSNumber *)handleId {
    for (KSRemoteView *videoView in _remoteKits) {
        if (videoView.handleId == handleId) {
            [_remoteKits removeObject:videoView];
            [videoView removeFromSuperview];
            break;
        }
    }
}

- (KSRemoteView *)createRemoteViewOfHandleId:(NSNumber *)handleId {
    CGPoint point = [self pointOfIndex:self.remoteKits.count];
    KSRemoteView *remoteView = [[KSRemoteView alloc] initWithFrame:CGRectMake(point.x, point.y, _layout.layout.width, _layout.layout.height)];
    remoteView.handleId = handleId;
    [self.scrollView addSubview:remoteView];
    [self.remoteKits addObject:remoteView];
    return remoteView;
}

- (RTCEAGLVideoView *)remoteViewOfHandleId:(NSNumber *)handleId {
    for (KSRemoteView *itemView in self.remoteKits) {
        if (itemView.handleId == handleId) {
            return itemView.remoteView;
        }
    }
    KSRemoteView *remoteView = [self createRemoteViewOfHandleId:handleId];
    return remoteView.remoteView;
}

-(NSMutableArray *)remoteKits {
    if (_remoteKits == nil) {
        _remoteKits = [NSMutableArray array];
    }
    return _remoteKits;
}

@end