#noinspection RubyInstanceVariableNamingConvention
class KBPoint
  attr_accessor :x, :y

  # Either init(x,y) ot init([x,y])
  #noinspection RubyInstanceVariableNamingConvention
  def init(arg1, arg2 = 0)
    @x, @y = [arg1, arg2].flatten
    self
  end

  #        X
  #       XoX   return points located near current one
  #        X
  def crossPointsAround
    [KBPoint.new.init([x+1,y]),KBPoint.new.init([x-1,y]),KBPoint.new.init([x,y-1]),KBPoint.new.init([x,y+1])]
  end

  def isInFeild(x1,x2,y1,y2)
    x.between?(x1, x2) && y.between?(y1, y2)
  end

  #noinspection RubyInstanceVariableNamingConvention
  def initNextInLinePoint(firstPoint, secondPoint)
    @x = 2*secondPoint.x - firstPoint.x
    @y = 2*secondPoint.y - firstPoint.y
    self
  end

  def toArray
    [x,y]
  end

end
