#import "HCStatuseDetailView.h"
#import "HCStatuseOriginalView.h"

@interface HCStatuseDetailView()

@property(nonatomic,weak)HCStatuseOriginalView *originalView;

@end

@implementation HCStatuseDetailView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        //项目View
        HCStatuseOriginalView *OriginalView = [[HCStatuseOriginalView alloc]init];
        OriginalView.backgroundColor = [UIColor whiteColor];
        //给bgView边框设置阴影
        OriginalView .layer.shadowOffset = CGSizeMake(1,1);
        OriginalView .layer.shadowOpacity = 0.3;
        OriginalView .layer.shadowColor = [UIColor blackColor].CGColor;
        [self addSubview:OriginalView];
        self.originalView = OriginalView;
        
        
//        self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.2];
        
    }
    return self;
}

-(void)setDetailFrm:(HCStatuseDetailCellFrame *)detailFrm{
    _detailFrm = detailFrm;
    
    // 设置自身frm
    self.frame = detailFrm.selfFrm;
    
    // 设置originalView的frm
    self.originalView.originalFrm = detailFrm.originalFrm;
    
}

@end
