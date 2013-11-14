class GameScene < SKScene

  def didMoveToView(view)
    unless @contentCreated
      self.createContent
      @contentCreated = true
    end
  end

  def createContent
    # invader = SKSpriteNode.spriteNodeWithImageNamed("InvaderA_00.png")
    invader = SKSpriteNode.spriteNodeWithImageNamed("images/InvaderA_00")
    invader.position = CGPointMake(self.size.width / 2, self.size.height / 2);
    self.addChild(invader)
  end

  def update(currentTime)
  end

end
