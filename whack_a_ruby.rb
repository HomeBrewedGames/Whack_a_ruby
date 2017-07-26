require 'gosu'
require_relative 'library/RubyIcon.rb'

class WhackARuby < Gosu::Window
	def initialize
		@window_width = 800
		@window_height = 600
		@number_of_rubies = 10
		@rubies = Array.new
		@number_of_rubies.times do #make an array of RubyIcon
			@rubies << RubyIcon.new(@window_width, @window_height)
		end
		@hammer_image = Gosu::Image.new('images/hammer.png')
		@score = 0

		super(@window_width,@window_height)
		self.caption = 'Catch The Pussy!'
	end
	def button_down(button)
		case button
			when Gosu::Kb1 then @rubies.each do |ruby_icon| ruby_icon.accelerate end
			when Gosu::Kb2 then @rubies.each do |ruby_icon| ruby_icon.decelerate end
		end
	end

	def update
		@rubies.each do |ruby_icon|
			ruby_icon.move_based_on_velocity
		  ruby_icon.bounce_off_edges
			ruby_icon.decrease_visiblity

			#check for collisions between the rubies and the hammer. Increment Score as needed.
			position = ruby_icon.get_current_position_on_screen
			if Gosu.distance(mouse_x, mouse_y, position[:x_axis], position[:y_axis]) < 50 &&
					ruby_icon.is_visible? then
				@score += 1
			end
		end

		#once a ruby is hit, remove it from the array so it stops being drawn
		#and so hitting it only gets counted once for score instead of repeatedly
		@rubies.reject! { |ruby_icon|
			Gosu.distance(mouse_x, mouse_y, ruby_icon.get_current_position_on_screen[:x_axis],
			ruby_icon.get_current_position_on_screen[:y_axis]) < 50 && ruby_icon.is_visible?
		}

		#spawn a new ruby every time one dies off
		until @rubies.size == @number_of_rubies
				@rubies << RubyIcon.new(@window_width, @window_height)
		end
	end

	def draw
		@rubies.each do |ruby_icon|
			if ruby_icon.is_visible? then
				image = ruby_icon.get_image
				ruby_icon_position = ruby_icon.get_current_position_on_screen
				ruby_width_radius = ruby_icon.get_width_radius
				ruby_height_radius = ruby_icon.get_height_radius
				image.draw(ruby_icon_position[:x_axis] - ruby_width_radius, ruby_icon_position[:y_axis] - ruby_height_radius, 1)
			end
		end
		@hammer_image.draw(mouse_x - 40, mouse_y - 10, 1)
	end
end

window = WhackARuby.new
window.show





