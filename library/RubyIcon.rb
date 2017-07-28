require 'Gosu'

class RubyIcon
	def initialize(window_width, window_height)
		@window_width = window_width
		@window_height = window_height
		@image = Gosu::Image.new('images/ruby.png')
		@width = 50
		@height = 50
		@width_radius = 25
		@height_radius = 25
		@rate_of_acceleration = 1
		@visible = rand(0..30)
		@always_visible = true
		@should_move = false

		set_initial_starting_position
		set_initial_velocity
  end
  private def set_initial_velocity
		@current_velocity = {
				:x_axis => rand(-5..5),
		    :y_axis => rand(-5..5)}

		#prevent the game from spawning the ruby going in only one direction
		#when this happens, it gets stuck just bouncing back and forth instead
		#of moving all over the screen
		while @current_velocity[:x_axis] == 0 do
			@current_velocity[:x_axis] = rand(-5..5)
		end
		while @current_velocity[:y_axis] == 0 do
			@current_velocity[:y_axis] = rand(-5..5)
		end
	end
  private def set_initial_starting_position
		@current_position_on_screen = {
			:x_axis => rand(@window_width),
			:y_axis => rand(@window_height)
		}
	end

	def decrease_visiblity
		if @always_visible == false
			@visible -= 1
			@visible = 30 if @visible < -10 && rand(1..100) == 1
		end
	end

	#functions used for drawing the ruby icon elsewhere
	def get_image
		@image
	end
	def get_current_position_on_screen
		@current_position_on_screen
	end
	def get_width_radius
		@width_radius
	end
	def get_height_radius
		@height_radius
	end
	def is_visible?
		return true if @visible > 0
		return false
	end

	#functions for moving the ruby icon around
	def move_based_on_velocity
		if @should_move
			@current_position_on_screen[:x_axis] += @current_velocity[:x_axis]
			@current_position_on_screen[:y_axis] += @current_velocity[:y_axis]
		end
	end
	def bounce_off_edges
		reverse_direction_x if is_touching_an_edge_x?
		reverse_direction_y if is_touching_an_edge_y?
	end
	def accelerate
		#check the direction it's heading in, then adjust velocity to move faster in that direction
		more_left if is_moving_to_the_left?
		more_right if is_moving_to_the_right?
		more_up if is_moving_up?
		more_down if is_moving_down?
	end
	def decelerate
		#check the direction it's heading in, then adjust velocity to move faster in that direction
		#check that it's speed in that given direction isn't 1. Otherwise, the ruby can decelerate to 0
		#and the deceleration to 0 just introduces a bug into the game because then it can't be started
		#moving again.
		more_right if is_moving_to_the_left? && @current_velocity[:x_axis] != -1
		more_left if is_moving_to_the_right? && @current_velocity[:x_axis] != 1
		more_down if is_moving_up? && @current_velocity[:y_axis] != -1
		more_up if is_moving_down? && @current_velocity[:y_axis] != 1
	end

	#abstracted helper functions to make other code more readable in the other methods
	#These are here instead of inside methods because, in Ruby, if I define a method inside
	#another method, it gets redefined every time the parent method is called. Performance Hit.
	private def is_touching_an_edge_x?
		true if @current_position_on_screen[:x_axis] + @width_radius > @window_width ||
				@current_position_on_screen[:x_axis] - @width_radius < 0
	end
	private def is_touching_an_edge_y?
		true if @current_position_on_screen[:y_axis] + @height_radius > @window_height ||
				@current_position_on_screen[:y_axis] - @height_radius < 0
	end
	private def reverse_direction_x
		@current_velocity[:x_axis] *= -1
	end
	private def reverse_direction_y
		@current_velocity[:y_axis] *= -1
	end

	private def is_moving_to_the_right?
		@current_velocity[:x_axis] > 0
	end
	private def is_moving_to_the_left?
		@current_velocity[:x_axis] < 0
	end
	private def is_moving_up?
		@current_velocity[:y_axis] < 0
	end
	private def is_moving_down?
		@current_velocity[:y_axis] > 0
	end

	private def more_left
		@current_velocity[:x_axis] -= @rate_of_acceleration
	end
	private def more_right
		@current_velocity[:x_axis] += @rate_of_acceleration
	end
	private def more_up
		@current_velocity[:y_axis] -= @rate_of_acceleration
	end
	private def more_down
		@current_velocity[:y_axis] += @rate_of_acceleration
	end

end







