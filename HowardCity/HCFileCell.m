#import "HCFileCell.h"
#import "HCFileView.h"

@interface HCFileCell()

@property(nonatomic,weak)HCFileView *FileView;

@end

@implementation HCFileCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //项目View
        HCFileView *FileView = [[HCFileView alloc]init];
        
        FileView.backgroundColor = [UIColor whiteColor];
        FileView.layer.cornerRadius = 10;
        //给bgView边框设置阴影
        FileView.layer.shadowOffset = CGSizeMake(1,1);
        FileView.layer.shadowOpacity = 0.3;
        FileView.layer.shadowColor = [UIColor blackColor].CGColor;
        
        [self addSubview:FileView];
        self.backgroundColor = HCColor(55, 106, 133, 1);
        self.FileView = FileView;
        
    }
    return self;
}

+(instancetype)cellWithTabbleView:(UITableView *)tableView{
    static NSString *ID = @"StatusCell";
    
    HCFileCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[HCFileCell alloc] initWithStyle:0 reuseIdentifier:ID];
    }
    
    return cell;
}

-(void)setFileCellFrm:(HCFileCellFrame *)FileCellFrm{
    _FileCellFrm = FileCellFrm;
    
    //设置detailView的Frm
    self.FileView.FileFrm = FileCellFrm.FileFrm;
    
}

@end
