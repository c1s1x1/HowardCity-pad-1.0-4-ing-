#import "HCNoticeViewFrame.h"

@implementation HCNoticeViewFrame

-(void)setNotice:(HCNotice *)Notice{
    
    _Notice = Notice;
    
    //通知标题frm
    // 计算 "通知标题" 尺寸size
    NSDictionary *NoticTitleAtt;
    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
        NoticTitleAtt = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    }else{
        NoticTitleAtt = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    }
    CGSize snSize = [Notice.title sizeWithAttributes:NoticTitleAtt];
    CGFloat snX = HCStatusCellInset;
    CGFloat snY = HCStatusCellInset;
    self.NoticTitleFrm = (CGRect){snX,snY,snSize};
    
    
    //2.通知发送者(字体大小14)
    // 计算 "通知发送者" 尺寸size
    NSDictionary *SenderAtt;
    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
        SenderAtt = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    }else{
        SenderAtt = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    }
    CGSize SenderSize = [Notice.sender sizeWithAttributes:SenderAtt];
    CGFloat SenderX = HCStatusCellInset;
    CGFloat SenderY = CGRectGetMaxY(self.NoticTitleFrm) + HCStatusCellInset;
    self.SenderFrm = (CGRect){SenderX,SenderY,SenderSize};
    
    //2.通知发送时间(字体大小14)
    // 计算 "通知发送时间" 尺寸size
    NSDictionary *SendTimeatt;
    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
        SendTimeatt = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    }else{
        SendTimeatt = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    }
    CGSize SendTimeSize = [Notice.sendTime sizeWithAttributes:SendTimeatt];
    CGFloat SendTimeX = UIScreenW- 40 -SendTimeSize.width - HCStatusCellInset;
    CGFloat SendTimeY = (CGRectGetMaxY(self.SenderFrm) + HCStatusCellInset)/2 + SendTimeSize.height/2;
    self.SendTimeFrm = (CGRect){SendTimeX,SendTimeY,SendTimeSize};
    
    //通知标题frm
    // 计算 "通知标题" 尺寸size
    NSDictionary *IsvisitAtt;
    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
        IsvisitAtt = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    }else{
        IsvisitAtt = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    }
    CGSize IsvisitSize = [@"测试" sizeWithAttributes:IsvisitAtt];
    CGFloat IsvisitX = UIScreenW - 120 - HCStatusCellInset;
    CGFloat IsvisitY = CGRectGetMinY(self.NoticTitleFrm);
    self.IsvisitLabelFrm = (CGRect){IsvisitX,IsvisitY,IsvisitSize};
    
    //通知标题frm
    // 计算 "通知标题" 尺寸size
    NSDictionary *InfoTypeAtt;
    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
        InfoTypeAtt = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    }else{
        InfoTypeAtt = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    }
    CGSize InfoTypeSize = [@"测试" sizeWithAttributes:InfoTypeAtt];
    CGFloat InfoTypeX = CGRectGetMaxX(self.IsvisitLabelFrm) + HCStatusCellInset;
    CGFloat InfoTypeY = CGRectGetMinY(self.NoticTitleFrm);
    self.InfoTypeLabelFrm = (CGRect){InfoTypeX,InfoTypeY,InfoTypeSize};
    
    
    self.selfFrm = CGRectMake(20, 5, UIScreenW - 40, CGRectGetMaxY(self.SenderFrm) + HCStatusCellInset);
    
}

@end
