class GameViewController < UIViewController

  def loadView
    bounds = UIScreen.mainScreen.bounds
    self.view = SKView.alloc.initWithFrame(bounds)
  end

  def dealloc
    NSNotificationCenter.defaultCenter.removeObserver(self)
  end

  def viewDidLoad
    super

    # Pause the view (and thus the game) when the app is interrupted or backgrounded
    NSNotificationCenter.defaultCenter.addObserver(self, selector: 'handleApplicationWillResignActive:', name: UIApplicationWillResignActiveNotification, object: nil)
    NSNotificationCenter.defaultCenter.addObserver(self, selector: 'handleApplicationDidBecomeActive:', name: UIApplicationDidBecomeActiveNotification, object: nil)

    # Configure the view.
    skView = self.view
    skView.showsFPS = true
    skView.showsNodeCount = true

    # Create and configure the scene.
    scene = GameScene.sceneWithSize(skView.bounds.size)
    scene.scaleMode = SKSceneScaleModeAspectFill

    # Present the scene.
    skView.presentScene(scene)
  end

  def shouldAutorotate
    true
  end

  def supportedInterfaceOrientations
    UIInterfaceOrientationMaskPortrait
  end

  def handleApplicationWillResignActive(note)
    self.view.paused = true
  end

  def handleApplicationDidBecomeActive(note)
    self.view.paused = false
  end

end
