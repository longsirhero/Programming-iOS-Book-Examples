

#import "RootViewController.h"
#import "Cell.h"

@interface RootViewController () <UITableViewDataSource>
@property (nonatomic, copy) NSArray* trivia;
@property (nonatomic, copy) NSArray* heights;
@end

@implementation RootViewController

#define which 2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Trivia";
    
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"trivia" withExtension:@"txt"];
    NSString* s = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray* arr = [[s componentsSeparatedByString:@"\n"] mutableCopy];
    [arr removeLastObject];
    self.trivia = arr;
        
    NSMutableArray* heights = [NSMutableArray arrayWithCapacity:[arr count]];
    [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString* s = obj;
        CGFloat h;
        switch (which) {
            case 1: {
                // hard-coded dimensions, simple but hard-coded
                UIFont* font = [UIFont fontWithName:@"Helvetica" size:14];
                h = [s sizeWithFont:font
                  constrainedToSize:CGSizeMake(300,30000)
                      lineBreakMode:NSLineBreakByWordWrapping].height;
                h += 13*2;
                break;
            }
            case 2: {
                h = [self cellHeightForLabelString:s];
                break;
            }
        }
        [heights insertObject:@(h) atIndex:idx];
    }];
    self.heights = heights;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"Cell" bundle:nil] forCellReuseIdentifier:@"Cell"];
}

- (CGFloat) cellHeightForLabelString:(NSString*)s {
    // use the autolayout mechanism to generate the cell height
    NSArray* objs = [[UINib nibWithNibName:@"Cell" bundle:nil]
                     instantiateWithOwner:nil options:nil];
    Cell* cell = objs[0];
    UILabel* lab = cell.lab;
    lab.text = s; // and we don't need to know the font or anything else about the label
    [lab sizeToFit];
    return [cell systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.trivia count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Cell* cell = (Cell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                            forIndexPath:indexPath];
    cell.lab.text = self.trivia[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor whiteColor];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.heights[indexPath.row] floatValue];
}


@end
