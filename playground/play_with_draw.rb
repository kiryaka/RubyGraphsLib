require 'gosu'

include Gosu

currentDirPath = File.dirname(__FILE__)
['/../'].each { |newPath| $:.unshift currentDirPath + newPath }
DATAPATH = currentDirPath + '/../spec/support/dataFiles/'

require 'models/kb_map'

class String
  def to_hex
    "0x" + self.to_i.to_s(16)
  end
end

class Game < Window
  attr_reader :map
  CELL_WIDTH = 15

  def initialize
    super(640, 480, false)
    @map = KBMap.new.loadFromFile DATAPATH + 'maps/viewpoints.txt'
    @xPos = 1
    @yPos = 10
  end

  def update

  end

  def draw

    @map.tiles.each_with_index do |line, x|
      line.each_with_index do |tile, y|
        cell x, y, Color::BLUE if tile != 0

      end
    end

    cell @xPos, @yPos, Color::WHITE

    @map.viewpoints.each {|p| cell(p.x, p.y, Color::GREEN) }

    @map.lines.each { |line| drawLine line, Color::RED }

    @map.kdViewpoints.nearestk(@xPos, @yPos, 6).each_with_index do |i, index|
      point = @map.viewpoints[i]
      drawSimpleLine @xPos, @yPos, point.x, point.y, Color.from_hsv(360 - index*20, 1 - index*0.15, 1 - index*0.15)
    end

  end

  # @param line[KBLine]
  def drawLine(line, color)
    draw_line(line.startPoint.x*CELL_WIDTH, line.startPoint.y*CELL_WIDTH, color,
              line.endPoint.x*CELL_WIDTH, line.endPoint.y*CELL_WIDTH, color)
  end

  def drawSimpleLine(x1,y1,x2,y2, color)
    drawLine(KBLine.new.addPoint(KBPoint.new.init(x1,y1)).addPoint(KBPoint.new.init(x2,y2)), color)
  end

  def cell(x,y, c)
    width = 13
    draw_quad(
        x*CELL_WIDTH - CELL_WIDTH/2, y*CELL_WIDTH - CELL_WIDTH/2, c,
        x*CELL_WIDTH+width - CELL_WIDTH/2, y*CELL_WIDTH - CELL_WIDTH/2, c,
        x*CELL_WIDTH+width - CELL_WIDTH/2, y*CELL_WIDTH+width - CELL_WIDTH/2, c,
        x*CELL_WIDTH - CELL_WIDTH/2, y*CELL_WIDTH+width - CELL_WIDTH/2, c,
        0
    )
  end

  def button_down(id)
    @xPos+=1 if id == KbRight
    @xPos-=1 if id == KbLeft
    @yPos-=1 if id == KbUp
    @yPos+=1 if id == KbDown
    if id == KbEscape then close end
    arr = @map.kdViewpoints.nearestk(@xPos, @yPos, 6)
    p arr
  end
end

g = Game.new
g.show

