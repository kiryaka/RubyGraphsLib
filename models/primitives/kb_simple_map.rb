class KBSimpleMap
  INVALID = -1
  GRASS = 0
  #unwalkable started from next line
  UNWALKABLE = 200
  LINE1 = 201
  LINE2 = 202
  attr_accessor :width, :height, :tiles


  def loadFromFile(filePath)
    lines = File.readlines(filePath).map { |line| line.chomp }
    @height = lines.size
    @width = lines[0].size
    @tiles = Array.new(@width) do |x|
      Array.new(@height) do |y|
        case lines[y][x, 1]
          when '#'
            LINE1
          when 'x'
            LINE2
          else
            GRASS
        end
      end
    end
    self
  end

  def getTileOf(point, validationRequired = false)
    return INVALID if validationRequired && !point.isInFeild(0, @width-1, 0, @height-1)
    @tiles[point.x][point.y]
  end

end
