#import "HCStatuseOriginalCellFrame.h"
#import "TLTiltHighlightView.h"

@implementation HCStatuseOriginalCellFrame

-(void)setStatuse:(HCStatuses *)statuse{
    
    _statuse = statuse;
    
    if (!UI_IS_IPHONE) {
//        //开始计算frm
//        //1.图片
//        CGFloat profileX = HCStatusCellInset + 50;
//        CGFloat profileY = HCStatusCellInset;
//        CGFloat profileW = 100;
//        CGFloat profileH = 100;
//        self.profileFrm = CGRectMake(profileX, profileY, profileW, profileH);
//        
//        
//        //2.项目名称(字体大小14)
//        CGFloat snY = CGRectGetMaxY(self.profileFrm) + HCStatusCellInset;
//        // 计算 "名称" 尺寸size
//        NSDictionary *att = @{NSFontAttributeName:HCStatusOriginalSNFont};
//        CGSize snSize = [statuse.projectname sizeWithAttributes:att];
//        CGFloat snX = (UIScreenW - CGRectGetWidth(self.profileFrm))/2 + CGRectGetWidth(self.profileFrm)/2 - snSize.width/2;
//        self.screenNameFrm = (CGRect){snX,snY,snSize};
//        
//        //2.项目详情(字体大小14)
//        CGFloat InY = HCStatusCellInset;
//        // 计算 "详情" 尺寸size
//        NSDictionary *Inatt = @{NSFontAttributeName:HCStatusOriginalSNFont};
//        CGSize InSize = [@"asdkjfhakjdfhaklhfajlfhaljksdhfljkasfhljkshjksfhlkjdhfhdfakj" sizeWithAttributes:Inatt];
//        CGFloat InX = (UIScreenW /2) - InSize.width/2;
//        self.screenNameFrm = (CGRect){InX,InY,InSize};
//        
//        //2.项目SPI CPI(字体大小14)
//        self.SPILableFrm = CGRectMake(UIScreenW - 270, 10, 120, 40);
//        
//        self.SPIFrm = CGRectMake(UIScreenW - 240, 27, 120, 20);
//        
//        self.CPILableFrm = CGRectMake(UIScreenW - 270, 50 + HCStatusCellInset, 120, 40);
//        
//        self.CPIFrm = CGRectMake(UIScreenW - 240, 65 + HCStatusCellInset, 120.f, 20);
//        
//        self.SVLableFrm = CGRectMake(UIScreenW - 270, 50 + HCStatusCellInset, 120, 40);
//        
//        self.SVFrm = CGRectMake(UIScreenW - 240, 50 + HCStatusCellInset, 120.f, 20);
//        
//        self.CVLableFrm = CGRectMake(UIScreenW - 270, 50 + HCStatusCellInset, 120, 40);
//        
//        self.CVFrm = CGRectMake(UIScreenW - 240, 75 + HCStatusCellInset, 120.f, 20);
//        
////        self.moreFrm = CGRectMake(UIScreenW - 80, 30, 60, 60);
//        
//        self.selfFrm = CGRectMake(20, 5, UIScreenW - 40 , CGRectGetMaxY(self.profileFrm) + HCStatusCellInset);
        //开始计算frm
        //1.图片
        
        CGFloat profileY = 0;
        CGFloat profileW = 500;
        CGFloat profileH = 500;
        CGFloat profileX = 0;
        self.profileFrm = CGRectMake(profileX, profileY, profileW, profileH);
        
        
        //2.项目名称(字体大小14)
        CGFloat snY = CGRectGetMaxY(self.profileFrm) + HCStatusCellInset;
        // 计算 "名称" 尺寸size
        NSDictionary *att = @{NSFontAttributeName:HCStatusOriginalSNFont};
        CGSize snSize = [statuse.projectname sizeWithAttributes:att];
        CGFloat snX = CGRectGetWidth(self.profileFrm)/2 - snSize.width/2;
        self.screenNameFrm = (CGRect){snX,snY,snSize};
        
        //2.项目人数和剩余空间(字体大小10)
        CGFloat PSY = CGRectGetMaxY(self.screenNameFrm) + HCStatusCellInset;
        // 计算 "名称" 尺寸size
        NSDictionary *PSatt = @{NSFontAttributeName:[UIFont systemFontOfSize:10]};
        int space = 100;
        space = 100;
        if (statuse.occupation != 0) {
            space = (statuse.occupation/statuse.space)*100;
        }
        NSString *PersonAndSpace = [[NSString alloc]initWithFormat:@"项目现有%ld人  剩余%d%%空间",(long)statuse.peoplesum,space];
        CGSize PSSize = [PersonAndSpace sizeWithAttributes:PSatt];
        CGFloat PSX = CGRectGetWidth(self.profileFrm)/2 - PSSize.width/2;
        self.PersonAndSpaceLabelFrm = (CGRect){PSX,PSY,PSSize};
        
        self.HighLightFrm = CGRectMake(CGRectGetWidth(self.profileFrm)/2 - (CGRectGetWidth(self.profileFrm) - 80)/2, CGRectGetMaxY(self.PersonAndSpaceLabelFrm) + HCStatusCellInset, CGRectGetWidth(self.profileFrm) - 80, 2);
        
        //2.项目详情(字体大小14)
        CGFloat InY =  CGRectGetMaxY(self.HighLightFrm) ;
        // 计算 "详情" 尺寸size
        //        NSDictionary *Inatt = @{NSFontAttributeName:HCStatusOriginalSNFont};
        //        CGSize InSize = [@"阿萨德可代发画的回复案件回访啊肯定会碍事阿萨德傲娇哈安徽的时刻就恢复嗷嗷叫爱睡懒觉萨达哈阿克苏积分换爱上了咖啡姐安徽分路口见哈卡斯加上健康的华看时间花开圣诞节好" sizeWithAttributes:Inatt];
        CGFloat InX = CGRectGetMinX(self.HighLightFrm) + 10;
        self.InformationFrm = CGRectMake(InX,InY,CGRectGetWidth(self.HighLightFrm) - 20,60);
        
        //2.项目SPI CPI(字体大小14)
        self.SPILableFrm = CGRectMake((CGRectGetWidth(self.profileFrm) - 180)/3,CGRectGetMaxY(self.InformationFrm) +HCStatusCellInset, 60, 20);
        
        self.SPIFrm = CGRectMake(CGRectGetMinX(self.SPILableFrm) + 25, CGRectGetMinY(self.SPILableFrm) + 7 , 60, 20);
        
        self.CPILableFrm = CGRectMake(CGRectGetMaxX(self.SPIFrm) + (CGRectGetWidth(self.profileFrm)-130)/3, CGRectGetMaxY(self.InformationFrm) +HCStatusCellInset, 60, 20);
        
        self.CPIFrm = CGRectMake(CGRectGetMinX(self.CPILableFrm) + 25, CGRectGetMinY(self.SPILableFrm) + 7, 60, 20);
        
        // 计算 "创建者" 尺寸size
        NSDictionary *Uatt = @{NSFontAttributeName:[UIFont systemFontOfSize:10]};
        CGSize UserSize = [statuse.username sizeWithAttributes:Uatt];
        self.UserNameFrm = (CGRect){CGRectGetWidth(self.profileFrm)/3-(UserSize.width/2),CGRectGetMaxY(self.CPIFrm) +HCStatusCellInset,UserSize};
        
        // 计算 "创建时间" 尺寸size
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDictionary *Batt = @{NSFontAttributeName:[UIFont systemFontOfSize:10]};
        CGSize BuildSize = [statuse.buildtime sizeWithAttributes:Batt];
        self.BuildTimeFrm = (CGRect){CGRectGetWidth(self.profileFrm)*2/3-(BuildSize.width/2),CGRectGetMaxY(self.CPIFrm) +HCStatusCellInset,BuildSize};
        
        //        self.moreFrm = CGRectMake(UIScreenW - 40, 15, 30, 30);
        
        self.selfFrm = CGRectMake((UIScreenW - CGRectGetWidth(self.profileFrm))/2, 2.5, CGRectGetWidth(self.profileFrm), CGRectGetMaxY(self.UserNameFrm) + HCStatusCellInset);
    }else{
        //开始计算frm
        //1.图片
        
        CGFloat profileY = 0;
        CGFloat profileW = 300;
        CGFloat profileH = 300;
        CGFloat profileX = 0;
        self.profileFrm = CGRectMake(profileX, profileY, profileW, profileH);
        
        
        //2.项目名称(字体大小14)
        CGFloat snY = CGRectGetMaxY(self.profileFrm) + HCStatusCellInset;
        // 计算 "名称" 尺寸size
        NSDictionary *att = @{NSFontAttributeName:HCStatusOriginalSNFont};
        CGSize snSize = [statuse.projectname sizeWithAttributes:att];
        CGFloat snX = CGRectGetWidth(self.profileFrm)/2 - snSize.width/2;
        self.screenNameFrm = (CGRect){snX,snY,snSize};
        
        //2.项目人数和剩余空间(字体大小10)
        CGFloat PSY = CGRectGetMaxY(self.screenNameFrm) + HCStatusCellInset;
        // 计算 "名称" 尺寸size
        NSDictionary *PSatt = @{NSFontAttributeName:[UIFont systemFontOfSize:10]};
        int space;
        space = 100;
        if (statuse.occupation != 0) {
            space = (statuse.occupation/statuse.space)*100;
        }
        NSString *PersonAndSpace = [[NSString alloc]initWithFormat:@"项目现有%ld人  剩余%d%%空间",(long)statuse.peoplesum,space];
        CGSize PSSize = [PersonAndSpace sizeWithAttributes:PSatt];
        CGFloat PSX = CGRectGetWidth(self.profileFrm)/2 - PSSize.width/2;
        self.PersonAndSpaceLabelFrm = (CGRect){PSX,PSY,PSSize};
        
        //分割线
        self.HighLightFrm = CGRectMake(CGRectGetWidth(self.profileFrm)/2 - (CGRectGetWidth(self.profileFrm) - 80)/2, CGRectGetMaxY(self.PersonAndSpaceLabelFrm) + HCStatusCellInset, CGRectGetWidth(self.profileFrm) - 80, 2);
        
        //2.项目详情(字体大小14)
        CGFloat InY =  CGRectGetMaxY(self.HighLightFrm) ;
        // 计算 "详情" 尺寸size
//        NSDictionary *Inatt = @{NSFontAttributeName:HCStatusOriginalSNFont};
//        CGSize InSize = [@"阿萨德可代发画的回复案件回访啊肯定会碍事阿萨德傲娇哈安徽的时刻就恢复嗷嗷叫爱睡懒觉萨达哈阿克苏积分换爱上了咖啡姐安徽分路口见哈卡斯加上健康的华看时间花开圣诞节好" sizeWithAttributes:Inatt];
        CGFloat InX = CGRectGetMinX(self.HighLightFrm) + 10;
        self.InformationFrm = CGRectMake(InX,InY,CGRectGetWidth(self.HighLightFrm) - 20,60);
        
        //2.项目SPI CPI(字体大小14)
        self.SPILableFrm = CGRectMake((CGRectGetWidth(self.profileFrm) - 180)/3,CGRectGetMaxY(self.InformationFrm) +HCStatusCellInset, 60, 20);
        
        self.SPIFrm = CGRectMake(CGRectGetMinX(self.SPILableFrm) + 25, CGRectGetMinY(self.SPILableFrm) + 7 , 60, 20);
        
        self.CPILableFrm = CGRectMake(CGRectGetMaxX(self.SPIFrm) + (CGRectGetWidth(self.profileFrm)-130)/3, CGRectGetMaxY(self.InformationFrm) +HCStatusCellInset, 60, 20);
        
        self.CPIFrm = CGRectMake(CGRectGetMinX(self.CPILableFrm) + 25, CGRectGetMinY(self.SPILableFrm) + 7, 60, 20);
        
//        self.SVLableFrm = CGRectMake(180, HCStatusCellInset * 2 + 95, 60, 20);
//        
//        self.SVFrm = CGRectMake(205,HCStatusCellInset * 2 + 100, 60, 20);
//        
//        self.CVLableFrm = CGRectMake(265, HCStatusCellInset * 2 + 95, 60, 20);
//        
//        self.CVFrm = CGRectMake(290, HCStatusCellInset * 2 + 100, 60, 20);
        
        // 计算 "创建者" 尺寸size
        NSDictionary *Uatt = @{NSFontAttributeName:[UIFont systemFontOfSize:10]};
        CGSize UserSize = [statuse.username sizeWithAttributes:Uatt];
        self.UserNameFrm = (CGRect){CGRectGetWidth(self.profileFrm)/3-(UserSize.width/2),CGRectGetMaxY(self.CPIFrm) +HCStatusCellInset,UserSize};
        
        // 计算 "创建时间" 尺寸size
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDictionary *Batt = @{NSFontAttributeName:[UIFont systemFontOfSize:10]};
        CGSize BuildSize = [statuse.buildtime sizeWithAttributes:Batt];
        self.BuildTimeFrm = (CGRect){CGRectGetWidth(self.profileFrm)*2/3-(BuildSize.width/2),CGRectGetMaxY(self.CPIFrm) +HCStatusCellInset,BuildSize};
        
//        self.moreFrm = CGRectMake(UIScreenW - 40, 15, 30, 30);
        
        self.selfFrm = CGRectMake((UIScreenW - CGRectGetWidth(self.profileFrm))/2, 2.5, CGRectGetWidth(self.profileFrm), CGRectGetMaxY(self.UserNameFrm) + HCStatusCellInset);
    }
    
    
}


@end
