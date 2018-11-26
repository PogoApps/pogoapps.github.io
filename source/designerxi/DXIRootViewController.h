@interface Project : NSObject
@property (retain) NSString *name;
@property (assign) int type;
@end

@interface DXIRootViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@end