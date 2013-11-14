class GameScene < SKScene

  module InvaderType
    INVADER_TYPE_A = 1
    INVADER_TYPE_B = 2
    INVADER_TYPE_C = 3
  end

  INVADER_SIZE          = CGSizeMake(24, 16)
  INVADER_GRID_SPACING  = CGSizeMake(12, 12)
  INVADER_ROW_COUNT     = 6
  INVADER_COLUMN_COUNT  = 6

  INVADER_NAME = "invader".freeze

  SHIP_SIZE = CGSizeMake(30, 16)
  SHIP_NAME = "ship".freeze

  SCORE_HUD_NAME  = "score_hud".freeze
  HEALTH_HUD_NAME = "health_hud".freeze

  def didMoveToView(view)
    unless @contentCreated
      self.createContent
      @contentCreated = true
    end
  end

  def createContent
    setup_invaders
    setup_ship
    setup_hud
  end

  def make_invader_of_type(invader_type)
    case invader_type
    when InvaderType::INVADER_TYPE_A
      invader_color = SKColor.redColor
    when InvaderType::INVADER_TYPE_B
      invader_color = SKColor.greenColor
    when InvaderType::INVADER_TYPE_C
      invader_color = SKColor.blueColor
    else
      invader_color = SKColor.blueColor
    end

    invader = SKSpriteNode.spriteNodeWithColor(invader_color, size: INVADER_SIZE)
    invader.name = INVADER_NAME

    return invader
  end

  def setup_invaders
    base_origin = CGPointMake(INVADER_SIZE.width / 2, 180)
    (0...INVADER_ROW_COUNT).each do |row|
      case row % 3
      when 0 then invader_type = InvaderType::INVADER_TYPE_A
      when 1 then invader_type = InvaderType::INVADER_TYPE_B
      else invader_type = InvaderType::INVADER_TYPE_C
      end

      invader_position = CGPointMake(
        base_origin.x,
        row * (INVADER_GRID_SPACING.height + INVADER_SIZE.height) + base_origin.y
      )

      (0...INVADER_COLUMN_COUNT).each do |column|
        invader = self.make_invader_of_type(invader_type)
        invader.position = invader_position
        self.addChild(invader)

        invader_position.x += INVADER_SIZE.width + INVADER_GRID_SPACING.width
      end
    end
  end

  def setup_ship
    ship = self.make_ship
    ship.position = CGPointMake(self.size.width / 2.0, SHIP_SIZE.height / 2.0)
    self.addChild(ship)
  end

  def make_ship
    ship = SKSpriteNode.spriteNodeWithColor(SKColor.greenColor, size: SHIP_SIZE)
    ship.name = SHIP_NAME
    ship
  end

  def setup_hud
    score_label = SKLabelNode.labelNodeWithFontNamed("Courier")
    score_label.name = SCORE_HUD_NAME
    score_label.fontSize = 15
    score_label.fontColor = SKColor.greenColor
    score_label.text = "Score: %4d" % 0
    score_label.position = CGPointMake(20 + score_label.frame.size.width / 2, self.size.height - (20 + score_label.frame.size.height / 2))
    self.addChild(score_label)

    health_label = SKLabelNode.labelNodeWithFontNamed("Courier")
    health_label.name = HEALTH_HUD_NAME
    health_label.fontSize = 15
    health_label.fontColor = SKColor.redColor
    health_label.text = "Health: %.1f%%" % 100.0
    health_label.position = CGPointMake(self.size.width - health_label.frame.size.width / 2 - 20, self.size.height - (20 + health_label.frame.size.height / 2))
    self.addChild(health_label)
  end

  def update(currentTime)
  end

end
