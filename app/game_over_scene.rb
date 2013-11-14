class GameOverScene < SKScene

  def didMoveToView(view)
    unless self.contentCreated
      self.createContent
      self.contentCreated = true
    end
  end

  def createContent
    game_over_label = SKLabelNode.label("Courier")
    gameOverLabel.fontSize = 50
    gameOverLabel.fontColor = SKColor.whiteColor
    gameOverLabel.text = "Game Over!"
    gameOverLabel.position = CGPointMake(self.size.width / 2, 2.0 / 3.0 * self.size.height)
    self.addChild(gameOverLabel)

    tapLabel = SKLabelNode.labelNodeWithFontNamed("Courier")
    tapLabel.fontSize = 25;
    tapLabel.fontColor = SKColor.whiteColor
    tapLabel.text = "(Tap to Play Again)"
    tapLabel.position = CGPointMake(self.size.width / 2, gameOverLabel.frame.origin.y - gameOverLabel.frame.size.height - 40)
    self.addChild(tapLabel)
  end

  def touchesBegan(touches, withEvent: event)
    # Intentional no-op
  end

  def touchesMoved(touches, withEvent: event)
    # Intentional no-op
  end

  def touchesCancelled(touches, withEvent: event)
    # Intentional no-op
  end

  def touchesEnded(touches, withEvent: event)
    gameScene = GameScene.alloc.initWithSize(self.size)
    gameScene.scaleMode = SKSceneScaleModeAspectFill
    self.view.presentScene(gameScene, transition: SKTransition.doorsCloseHorizontalWithDuration(1.0))
  end

end
