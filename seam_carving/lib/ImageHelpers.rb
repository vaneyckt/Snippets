require 'oily_png'

module ImageHelpers
  class Image
    attr_reader :width
    attr_reader :height
    attr_reader :pixels

    def initialize(width, height)
      @width = width
      @height = height
      @pixels = []
    end

    def [](x, y)
      index = (y * @width) + x
      @pixels[index]
    end

    def []=(x, y, value)
      index = (y * @width) + x
      @pixels[index] = value
    end
  end

  def self.getEmptyImage(width, height)
    image = Image.new(width, height)
  end

  def self.loadFromFile(file_name)
    chunky_image = ChunkyPNG::Image.from_file("#{file_name}.png")
    image = getEmptyImage(chunky_image.width, chunky_image.height)

    for y in 0...image.height
      for x in 0...image.width
        image[x,y] = ChunkyPNG::Color.to_truecolor_bytes(chunky_image[x,y])
      end
    end
    image
  end

  def self.saveToFile(image, file_name)
    canvas = ChunkyPNG::Canvas.new(image.width, image.height)

    for y in 0...image.height
      for x in 0...image.width
        r = (image[x,y].kind_of?(Array)) ? [[0, image[x,y][0].to_i].max, 255].min : [[0, image[x,y].to_i].max, 255].min
        g = (image[x,y].kind_of?(Array)) ? [[0, image[x,y][1].to_i].max, 255].min : [[0, image[x,y].to_i].max, 255].min
        b = (image[x,y].kind_of?(Array)) ? [[0, image[x,y][2].to_i].max, 255].min : [[0, image[x,y].to_i].max, 255].min
        canvas[x,y] = ChunkyPNG::Color.rgb(r, g, b)
      end
    end
    canvas.to_image.save("#{file_name}_#{(Time.now.to_f * 10000000).to_i}.png")
  end

  def self.markVerticalSeam(image, seam)
    width = image.width
    height = image.height
    new_image = getEmptyImage(width, height)

    for y in 0...height
      for x in 0...width
        new_image[x,y] = (seam[y] == x) ? [255, 0, 0] : image[x,y]
      end
    end
    new_image
  end

  def self.markHorizontalSeam(image, seam)
    width = image.width
    height = image.height
    new_image = getEmptyImage(width, height)

    for x in 0...width
      for y in 0...height
        new_image[x,y] = (seam[x] == y) ? [255, 0, 0] : image[x,y]
      end
    end
    new_image
  end

  def self.removeVerticalSeam(image, seam)
    width = image.width
    height = image.height
    new_image = getEmptyImage(width-1, height)

    for y in 0...height
      new_x = 0
      for x in 0...width
        if x != seam[y]
          new_image[new_x,y] = image[x,y]
          new_x += 1
        end
      end
    end
    new_image
  end

  def self.removeHorizontalSeam(image, seam)
    width = image.width
    height = image.height
    new_image = getEmptyImage(width, height-1)

    for x in 0...width
      new_y = 0
      for y in 0...height
        if y != seam[x]
          new_image[x,new_y] = image[x,y]
          new_y += 1
        end
      end
    end
    new_image
  end
end
