require 'Chingu'

class Game < Chingu::Window
	attr_reader :WIDTH, :HEIGHT, :NAME

	def initialize
		# Window START
		@WIDTH, @HEIGHT, @NAME = 800, 600, "ChinguRoids 0.01 - Fractional"
		super(800, 600, false)
		self.caption = @NAME
		# Window END

		self.input = { :escape => :exit}

		push_game_state(Introduction)
	end
end

class Player < Chingu::GameObject
	def initialize(options = {})
		super
		@image = Gosu::Image["assets/player/player.png"]
		@speed = 5
		@width, @height = 32, 32
	end

	def move_left
		if(@x > @speed + (@width/2))
			@x -= @speed
		end
	end

	def move_right
		if(@x < 800 - @speed - (@width/2) )
			@x += @speed
		end
	end

	def move_up
		if(@y - @speed - (@height/2) > 0)
	 		@y -= @speed
	 	end 
	end

	def move_down
		if(@y + @speed + (@height/2) < 600)
	 		@y += @speed
	 	end
	end

	def fire
		Bullet.create(:x => @x, :y => @y-32)
	end
end

class Bullet < Chingu::GameObject
	def initialize(options)
		super(options.merge(:image => Gosu::Image["assets/player/laser.png"]))
	end
	def update
		@y -= 5
	end
end

class Introduction < Chingu::GameState
	def initialize
		super
		fill(Color::Red)
		@text = Chingu::Text.new("Welcome to ChinguRoids", :x => $window.WIDTH/4, :y => $window.HEIGHT/2, :font => "GeosansLight", :size => 30)
		@text.x = $window.WIDTH/2 - @text.width/2

		self.input = {:return => :next}
	end
	def next
		push_game_state(Play)
	end
	def draw
		@text.draw
	end
end

class Play < Chingu::GameState
	def initialize
		super 
		fill(Color::RED)
		@player = Player.create(:x => 400, :y => 300)
		@player.input = {:holding_left => :move_left, :holding_right => :move_right, :holding_up => :move_up, :holding_down => :move_down, :space => :fire}
	end

	def draw
		super
		Gosu::Image["assets/window/background.png"].draw(0, 0, 0)
	end

	def update
		super
		Bullet.destroy_if {|bullet| bullet.outside_window?}
	end
end

Game.new.show