class GameScene < SKScene

  module InvaderType
    INVADER_TYPE_A = 1
    INVADER_TYPE_B = 2
    INVADER_TYPE_C = 3
  end

  module InvaderMovementDirection
    RIGHT           = 1
    LEFT            = 2
    DOWN_THEN_RIGHT = 3
    DOWN_THEN_LEFT  = 4
    NONE            = 5
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

      @moiton_manager = CMMotionManager.alloc.init
      @moiton_manager.startAccelerometerUpdates
    end
  end

  def createContent
    @invader_movement_direction = InvaderMovementDirection::RIGHT
    @time_per_move = 1.0
    @time_of_last_move = 0.0

    setup_invaders
    self.physicsBody = SKPhysicsBody.bodyWithEdgeLoopFromRect(self.frame)
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

    ship.physicsBody = SKPhysicsBody.bodyWithRectangleOfSize(ship.frame.size)
    ship.physicsBody.dynamic = true
    ship.physicsBody.affectedByGravity = false
    ship.physicsBody.mass = 0.02

    ship
  end

  def setup_hud
    score_label = SKLabelNode.labelNodeWithFontNamed("Courier")
    score_label.name = SCORE_HUD_NAME
    score_label.fontSize = 15
    score_label.fontColor = SKColor.greenColor
    score_label.text = "Score: %4d" % 0
    score_label.position = CGPointMake(
      20 + score_label.frame.size.width / 2,
      self.size.height - (20 + score_label.frame.size.height / 2)
    )
    self.addChild(score_label)

    health_label = SKLabelNode.labelNodeWithFontNamed("Courier")
    health_label.name = HEALTH_HUD_NAME
    health_label.fontSize = 15
    health_label.fontColor = SKColor.redColor
    health_label.text = "Health: %.1f%%" % 100.0
    health_label.position = CGPointMake(
      self.size.width - health_label.frame.size.width / 2 - 20,
      self.size.height - (20 + health_label.frame.size.height / 2)
    )
    self.addChild(health_label)
  end

  def update(currentTime)
    self.process_user_motion_for_update(currentTime)
    self.move_invaders_for_update(currentTime)
  end

  def move_invaders_for_update(current_time)
    return if current_time - @time_of_last_move < @time_per_move

    self.determine_invader_movement_direction

    self.enumerateChildNodesWithName(INVADER_NAME, usingBlock: lambda { |node, stop|
      case @invader_movement_direction
      when InvaderMovementDirection::RIGHT
        node.position = CGPointMake(node.position.x + 10, node.position.y)
      when InvaderMovementDirection::LEFT
        node.position = CGPointMake(node.position.x - 10, node.position.y)
      when InvaderMovementDirection::DOWN_THEN_LEFT, InvaderMovementDirection::DOWN_THEN_RIGHT
        node.position = CGPointMake(node.position.x, node.position.y - 10)
      else
      end
    })

    @time_of_last_move = current_time

    nil
  end

  def process_user_motion_for_update(current_time)
    ship = self.childNodeWithName(SHIP_NAME)
    data = @moiton_manager.accelerometerData

    if data && data.acceleration.x.abs > 0.2
      ship.physicsBody.applyForce(CGVectorMake(40.0 * data.acceleration.x, 0))
    end
  end

  def determine_invader_movement_direction
    # for block??
    propsed_movement_direction = @invader_movement_direction

    self.enumerateChildNodesWithName(INVADER_NAME, usingBlock: lambda {|node, stop|
      case @invader_movement_direction
      when InvaderMovementDirection::RIGHT
        if CGRectGetMaxX(node.frame) >= node.scene.size.width - 1.0
          propsed_movement_direction = InvaderMovementDirection::DOWN_THEN_LEFT
          stop = true
        end
      when InvaderMovementDirection::LEFT
        if CGRectGetMinX(node.frame) <= 1.0
          propsed_movement_direction = InvaderMovementDirection::DOWN_THEN_RIGHT
          stop = true
        end
      when InvaderMovementDirection::DOWN_THEN_LEFT
        propsed_movement_direction = InvaderMovementDirection::LEFT
        stop = true
      when InvaderMovementDirection::DOWN_THEN_RIGHT
        propsed_movement_direction = InvaderMovementDirection::RIGHT
        stop = true
      end
    })

    if propsed_movement_direction != @invader_movement_direction
      @invader_movement_direction = propsed_movement_direction
    end

    nil
  end

end
