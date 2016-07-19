module RacersHelper
  def toRacer racer 
    return racer.is_a?(Racer) ? racer : Racer.new(racer)
  end
end
