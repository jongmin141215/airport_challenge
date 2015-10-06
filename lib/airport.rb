require_relative 'plane'

class Airport

  attr_reader :capacity, :planes

  def initialize(capacity = 50)
    @capacity = capacity
    @planes = []
  end

  def clear_for_takeoff(plane)
    fail 'Too stormy' if weather_report == :stormy
    fail 'Airport empty' if empty?
    plane.take_off
    planes.delete(plane)
  end

  def clear_for_landing(plane)
    fail 'Too stormy' if weather_report == :stormy
    fail 'Airport full' if full?
    plane.land
    planes << plane
  end

  def weather_report(weather)
    weather.weather_report
  end

  private

  def empty?
    planes.empty?
  end

  def full?
    planes.size >= capacity
  end

end
