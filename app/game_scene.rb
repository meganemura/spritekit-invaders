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

  def didMoveToView(view)
    unless @contentCreated
      self.createContent
      @contentCreated = true
    end
  end

  def createContent
    setup_invaders
    setup_ship
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

  def update(currentTime)
  end

end
