#import "HCStatuses.h"

@implementation HCStatuses

+ (instancetype)accountWithDict:(NSDictionary *)dict
{
    HCStatuses *Statuses = [[self alloc] init];
//    Statuses.projectid = dict[@"projectid"];
//    Statuses.projectname = dict[@"projectname"];
//    // 获得账号存储的时间
//    Statuses.information = dict[@"information"];
//    Statuses.projectImgPath = dict[@"projectImgPath"];
//    Statuses.cpi = dict[@"cpi"];
//    Statuses.spi = dict[@"spi"];
//    Statuses.cv = dict[@"cv"];
//    Statuses.sv = dict[@"sv"];
//    Statuses.username = dict[@"username"];
//    Statuses.buildtime = dict[@"buildtime"];
//    Statuses.peoplesum = dict[@"peoplesum"];
//    Statuses.space = dict[@"space"];
//    Statuses.occupation = dict[@"occupation"];
    [Statuses setValuesForKeysWithDictionary:dict];
    return Statuses;
}

/**
 *  当一个对象要归档进沙盒中时，就会调用这个方法
 *  目的：在这个方法中说明这个对象的哪些属性要存进沙盒
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.projectid forKey:@"projectid"];
    [encoder encodeObject:self.projectname forKey:@"projectname"];
    [encoder encodeObject:self.information forKey:@"information"];
    [encoder encodeObject:self.projectImgPath forKey:@"projectImgPath"];
    [encoder encodeDouble:self.cpi forKey:@"cpi"];
    [encoder encodeDouble:self.spi forKey:@"spi"];
    [encoder encodeDouble:self.cv forKey:@"cv"];
    [encoder encodeDouble:self.sv forKey:@"sv"];
    [encoder encodeObject:self.username forKey:@"username"];
    [encoder encodeObject:self.buildtime forKey:@"buildtime"];
    [encoder encodeDouble:self.peoplesum forKey:@"peoplesum"];
    [encoder encodeDouble:self.space forKey:@"space"];
    [encoder encodeDouble:self.occupation forKey:@"occupation"];
}

/**
 *  当从沙盒中解档一个对象时（从沙盒中加载一个对象时），就会调用这个方法
 *  目的：在这个方法中说明沙盒中的属性该怎么解析（需要取出哪些属性）
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.projectid = [decoder decodeObjectForKey:@"projectid"];
        self.projectname = [decoder decodeObjectForKey:@"projectname"];
        self.information = [decoder decodeObjectForKey:@"information"];
        self.projectImgPath = [decoder decodeObjectForKey:@"projectImgPath"];
        self.cpi = [decoder decodeDoubleForKey:@"cpi"];
        self.spi = [decoder decodeDoubleForKey:@"spi"];
        self.cv = [decoder decodeDoubleForKey:@"cv"];
        self.sv = [decoder decodeDoubleForKey:@"sv"];
        self.username = [decoder decodeObjectForKey:@"username"];
        self.buildtime = [decoder decodeObjectForKey:@"buildtime"];
        self.peoplesum = [decoder decodeDoubleForKey:@"peoplesum"];
        self.space = [decoder decodeDoubleForKey:@"space"];
        self.occupation = [decoder decodeDoubleForKey:@"occupation"];
    }
    return self;
}

@end
