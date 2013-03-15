class KBLine
  attr_accessor :startPoint, :endPoint

  def initialize
    @startPoint = @endPoint = nil
  end

  # @param point[KBPoint]
  def addPoint(point)
    startPoint ? @endPoint = point : @startPoint = point
    self
  end

  def isReady
    startPoint && endPoint
  end

  def toArray
    [@startPoint.toArray, @endPoint.toArray]
  end

end