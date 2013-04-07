require './lib/ColorHelpers.rb'
require './lib/ImageHelpers.rb'

module SeamCarvingHelpers
  def self.computePixelEnergy(image)
    width = image.width
    height = image.height
    pixel_energy_image = ImageHelpers.getEmptyImage(width, height)

    for y in 0...height
      for x in 0...width
        pixel_energy_image[x,y] = 0
        pixel_energy_image[x,y] += ((x == 0 || x == (width-1))  ? 0 : ColorHelpers.colorDistance(image[x-1,y], image[x+1,y]))
        pixel_energy_image[x,y] += ((y == 0 || y == (height-1)) ? 0 : ColorHelpers.colorDistance(image[x,y-1], image[x,y+1]))
      end
    end
    pixel_energy_image
  end

  def self.computeVerticalSeamsEnergy(image)
    width = image.width
    height = image.height
    seams_energy_image = computePixelEnergy(image)

    for y in 1...height
      for x in 0...width
        seams_energy_image[x,y] += [seams_energy_image[x,y-1], seams_energy_image[x+1,y-1]].min                              if (x == 0)
        seams_energy_image[x,y] += [seams_energy_image[x,y-1], seams_energy_image[x-1,y-1]].min                              if (x == width-1)
        seams_energy_image[x,y] += [seams_energy_image[x,y-1], seams_energy_image[x-1,y-1], seams_energy_image[x+1,y-1]].min if (x != 0 && x != width-1)
      end
    end
    seams_energy_image
  end

  def self.computeHorizontalSeamsEnergy(image)
    width = image.width
    height = image.height
    seams_energy_image = computePixelEnergy(image)

    for x in 1...width
      for y in 0...height
        seams_energy_image[x,y] += [seams_energy_image[x-1,y], seams_energy_image[x-1,y+1]].min                              if (y == 0)
        seams_energy_image[x,y] += [seams_energy_image[x-1,y], seams_energy_image[x-1,y-1]].min                              if (y == height-1)
        seams_energy_image[x,y] += [seams_energy_image[x-1,y], seams_energy_image[x-1,y-1], seams_energy_image[x-1,y+1]].min if (y != 0 && y != height-1)
      end
    end
    seams_energy_image
  end

  def self.removeVerticalSeam(image)
    width = image.width
    height = image.height

    seam = {}
    seams_energy_image = computeVerticalSeamsEnergy(image)

    # find starting point for seam
    border = []
    for x in 0...width
      border << seams_energy_image[x,height-1]
    end
    seam[height-1] = border.find_index(border.min)

    # compute seam
    (height-1).downto(1) do |y|
      seam[y-1] = {seam[y] => seams_energy_image[seam[y],y-1], seam[y]+1 => seams_energy_image[seam[y]+1,y-1]}.min_by { |pixel, energy| energy }.first                                                 if (seam[y] == 0)
      seam[y-1] = {seam[y] => seams_energy_image[seam[y],y-1], seam[y]-1 => seams_energy_image[seam[y]-1,y-1]}.min_by { |pixel, energy| energy }.first                                                 if (seam[y] == width-1)
      seam[y-1] = {seam[y] => seams_energy_image[seam[y],y-1], seam[y]-1 => seams_energy_image[seam[y]-1,y-1], seam[y]+1 => seams_energy_image[seam[y]+1,y-1]}.min_by { |pixel, energy| energy }.first if (seam[y] != 0 && seam[y] != width-1)
    end

    # ImageHelpers.saveToFile(ImageHelpers.markVerticalSeam(image, seam), "mark_vertical_seam")
    ImageHelpers.removeVerticalSeam(image, seam)
  end

  def self.removeHorizontalSeam(image)
    width = image.width
    height = image.height

    seam = {}
    seams_energy_image = computeHorizontalSeamsEnergy(image)

    # find starting point for seam
    border = []
    for y in 0...height
      border << seams_energy_image[width-1,y]
    end
    seam[width-1] = border.find_index(border.min)

    # compute seam
    (width-1).downto(1) do |x|
      seam[x-1] = {seam[x] => seams_energy_image[x-1,seam[x]], seam[x]+1 => seams_energy_image[x-1,seam[x]+1]}.min_by { |pixel, energy| energy }.first                                                 if (seam[x] == 0)
      seam[x-1] = {seam[x] => seams_energy_image[x-1,seam[x]], seam[x]-1 => seams_energy_image[x-1,seam[x]-1]}.min_by { |pixel, energy| energy }.first                                                 if (seam[x] == height-1)
      seam[x-1] = {seam[x] => seams_energy_image[x-1,seam[x]], seam[x]-1 => seams_energy_image[x-1,seam[x]-1], seam[x]+1 => seams_energy_image[x-1,seam[x]+1]}.min_by { |pixel, energy| energy }.first if (seam[x] != 0 && seam[x] != height-1)
    end

    # ImageHelpers.saveToFile(ImageHelpers.markHorizontalSeam(image, seam), "mark_horizontal_seam")
    ImageHelpers.removeHorizontalSeam(image, seam)
  end

  def self.removeVerticalSeams(image, nb_seams)
    nb_seams.times do |t|
      puts "Removing vertical seam: #{t}"
      image = removeVerticalSeam(image)
    end
    image
  end

  def self.removeHorizontalSeams(image, nb_seams)
    nb_seams.times do |t|
      puts "Removing horizontal sean: #{t}"
      image = removeHorizontalSeam(image)
    end
    image
  end
end
