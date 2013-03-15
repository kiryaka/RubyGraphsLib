
require 'rubygems'
require 'kdtree'
require 'models/primitives/kb_simple_map'
require 'models/primitives/kb_line'
require 'models/primitives/kb_point'

# @!attribute [r] kdViewpoints
#   @return [Kdtree] Kdtree of viewpoints
class KBMap < KBSimpleMap
  attr_accessor :viewpoints, :lines, :kdLines, :kdViewpoints

  def initialize
    @viewpoints, @lines, @linepoints = [],[],[]
  end

  def loadFromFile(filePath)
    super
    findLinepoints
    defineLinesAndViewoints
    buildLineKdTree
    buildViewPointKdTree
    self
  end

  def buildLineKdTree
    points = []
    @lines.each_with_index {|line, index|
      points << (line.startPoint.toArray << index)
      points << (line.endPoint.toArray << index)
    }
    @kdLines = Kdtree.new(points)
  end

  def buildViewPointKdTree
    points = []
    @viewpoints.each_with_index { |point, index| points << (point.toArray << index) }
    @kdViewpoints = Kdtree.new(points)
  end

  def checkViewPoint(previousInLine, linePoint)
    possibleViewPoint = KBPoint.new.initNextInLinePoint(previousInLine, linePoint)
    @viewpoints << possibleViewPoint if getTileOf(possibleViewPoint) < UNWALKABLE
  end

  # @param line[KBLine]
  # @return KBLine
  def finishLineAndDefineViewPoints(line)
    previousPoint = p = line.startPoint
    loop do
      res = p.crossPointsAround.select do |crossPoint|
        getTileOf(crossPoint, true) == getTileOf(p) &&
            crossPoint.toArray != previousPoint.toArray
      end

      break if res.empty?

      checkViewPoint(res[0], p) if p == previousPoint
      previousPoint = p
      p = res[0]
    end

    checkViewPoint(previousPoint, p)
    line.addPoint p
  end

  def defineLinesAndViewoints
    usedLinePoints = []
    @linepoints.each do |p|
      next if usedLinePoints.find { |e| e.toArray.to_s == p.toArray.to_s }
      line = finishLineAndDefineViewPoints KBLine.new.addPoint(p)
      [line.startPoint, line.endPoint].each {|newPoint| usedLinePoints << newPoint}
      @lines << line
    end
    @linepoints = nil
  end

  def findLinepoints
    (0..@width-1).each do |x|
      (0..@height-1).each do |y|
        point = KBPoint.new.init(x, y)
        @linepoints << point if isCorner point
      end
    end
  end

  def isCorner(point)
    return false if getTileOf(point) < UNWALKABLE
    pointsMakeJoint = ->(points) { points.length == 2 && getTileOf(points[0]) != getTileOf(points[1]) }
    unwalkablePointsAround = point.crossPointsAround.select { |p| getTileOf(p, true) > UNWALKABLE }
    unwalkablePointsAround.length == 1 || pointsMakeJoint.call(unwalkablePointsAround)
  end

end