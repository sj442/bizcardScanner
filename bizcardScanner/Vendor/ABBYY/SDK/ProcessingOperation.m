#import "ProcessingOperation.h"
#import "ABBYYTask.h"

@implementation ProcessingOperation

- (void)finishWithError:(NSError*)error
{		
	if (error == nil) {
		ABBYYTask* task = [[ABBYYTask alloc] initWithData:self.recievedData];
	
		if ([task isActive]) {
      
			NSLog(@"Waiting for image processing complete...");
			
			[self performSelector:@selector(start) withObject:nil afterDelay:1];
			
			return;
		}
	}
	
	[super finishWithError:error];
}

@end
