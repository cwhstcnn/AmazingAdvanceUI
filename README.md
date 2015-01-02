AmazingAdvanceUI
=======
AmazingAdvanceUI is a component for view controllers interactive transition based on some popular library : POP and Masonry. You can easily transition between any view of one controller and any view of another controller.  Get more details within the AmazingAdvanceUITest project.
there provides a all time Interactive Animation Controller within the project ! You can interact with the view all the time just like the Paper! Check out it for the amazing interactive animated controller.
## POPContextAnimationController
This is the abstract Class for controller transtition.The subclasses should implement three function:
####do all non-interactive transition here
```
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext containerView:(UIView *)containerView masterView:(UIView *)masterView modalView:(UIView *)modalView;
```
####prepare for interactive transition,you can get any needed transition elements here
```
- (void)interactTransition:(id<UIViewControllerContextTransitioning>)transitionContext containerView:(UIView *)containerView masterView:(UIView *)masterView modalView:(UIView *)modalView;
```
####add gesture to control the transition
```
- (void)wireToView:(UIView *)view viewController:(UIViewController *)viewController;
```
####POPContextAnimationControllerDataSource
provide rect to handle later in transition.
####POPContextAnimationControllerDelegate
can be used to make view controller respond to transition.
##Example For Subclass
###POPRectToRectContextAnimationController
####IMPLEMENTS
#####- animateTransition:containerView:masterView: modalView
When transition from master to modal, it snapshot masterView in the source rect provided by POPContextAnimationControllerDataSource. Then with the help of POPSpringAnimation, it transition to the destination rect provided by the same POPContextAnimationControllerDataSource.
In the reverse transition, it does similar thing.
####IMPLEMENTS
#####- interactTransition:containerView:masterView:modalView:
In this place, you prepare for the view you need later the transitioning. And you should focus the implements of handling gesture. Remember remove extra views you add in the transitioning when you cancel and finish the interactive transition.
####IMPLEMENTS
#####- wireToView:viewController: implements
Normally, you can assign a gesture to one view in one of view controller for the transitioning.
###POPInteractiveAnimatedContextAnimationController
This class implements the UIViewControllerInteractiveTransitioning delegate and control the whole transition. You can wire the modal controller's view to interrupt at any time you want. 
####IMPLEMENTS
Technically, this class add a gesture to the top view in transtion (container view). It makes the response properly via judging whether the gesture location hits the snapshot view or not. When it hits, trigger the gesture handling and add end animation after all.
You should call finishTransition/cancelTransition properlly, and remove the unneeded views such as modalview/masterview/snapshotview
##Recap 
Subclass the context animation controller, you can make any custom fabulous transition that you want !