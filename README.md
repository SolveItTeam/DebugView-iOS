# DebugView

This is implementation of our debug view for iOS application. 


# How to use:
1. add this files to your existing projects
2. add *__ic_debug__* to your asset catalog or simply store in folder
3. in your AppDelegate add this snippet:

``` 
private var debugWindow: UIWindow?

func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:[UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        debugWindow = DebugFactory.showDebugWindow()
        
        let doubleTapGestureRecognizer = UITapGestureRecognizer()
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        doubleTapGestureRecognizer.numberOfTouchesRequired = 1
        doubleTapGestureRecognizer.addTarget(self, action: #selector(tap))
        
        window?.addGestureRecognizer(doubleTapGestureRecognizer)

        return true
	}
    
    @objc func tap() {
        guard let dWindow = debugWindow else { return }
        debugWindow?.isHidden = !dWindow.isHidden
    }
```
