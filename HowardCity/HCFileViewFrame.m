#import "HCFileViewFrame.h"

@implementation HCFileViewFrame

-(void)setFilerecord:(HCFilerecord *)Filerecord{
    
    _Filerecord = Filerecord;
    
    //开始计算frm
    //1.图片
    CGFloat profileX;
    CGFloat profileY;
    CGFloat profileW;
//    NSRange lastSymbol = [Filerecord.filename rangeOfString:@"." options:NSBackwardsSearch];
//    NSUInteger location = lastSymbol.location + 1;
    NSString *kind = Filerecord.filetype;
    CGFloat profileH;
    if ([kind isEqualToString:@"jpg"]||[kind isEqualToString:@"png"]||[kind isEqualToString:@"bmp"]||[kind isEqualToString:@"gif"]) {
        profileX = HCStatusCellInset + 10;
        profileY = 0 ;
        profileW = 40;
        profileH = 50;
    }else{
        profileX = HCStatusCellInset;
        profileY = 0 ;
        profileW = 60;
        profileH = 60;
    }
    
    self.profileFrm = CGRectMake(profileX, profileY, profileW, profileH);
    
    
    //2.项目名称(字体大小14)
    CGFloat snX = CGRectGetMaxX(self.profileFrm) + HCStatusCellInset + 20;
    CGFloat snY = HCStatusCellInset ;
    // 计算 "名称" 尺寸size
    NSDictionary *att;
    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
        att = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    }else{
        att = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    }
    CGSize snSize = [Filerecord.filename sizeWithAttributes:att];
    self.screenNameFrm = (CGRect){snX,snY,snSize};
    
    //2.创建时间(字体大小14)
    CGFloat ctY = CGRectGetMaxY(self.screenNameFrm);
    // 计算 "名称" 尺寸size
    NSDictionary *ctatt;
    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
        ctatt = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    }else{
        ctatt = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    }
    CGSize ctSize = [Filerecord.createTime sizeWithAttributes:ctatt];
    CGFloat ctX = UIScreenW- 40 -ctSize.width - HCStatusCellInset;
    self.CreateTimeFrm = (CGRect){ctX,ctY,ctSize};
    
    
    self.selfFrm = CGRectMake(20, 5, UIScreenW - 40, CGRectGetMaxY(self.profileFrm));
    
}

@end
