
#import "CCViewController.h"
#import "CCView.h"
@interface CCViewController ()

@property(nonatomic,strong)CCView *cView;


@end

@implementation CCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cView = (CCView *)self.view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
