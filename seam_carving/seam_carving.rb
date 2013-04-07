# Ruby code implementation of the Seam Carving algorithm
# Inspiration provided by http://jeremykun.com/2013/03/04/seam-carving-for-content-aware-image-scaling/
# Code @ https://github.com/vaneyckt/Snippets

require './lib/ImageHelpers.rb'
require './lib/SeamCarvingHelpers.rb'

image = ImageHelpers.loadFromFile("holiday_beach")
image = SeamCarvingHelpers.removeVerticalSeams(image, 100)
image = SeamCarvingHelpers.removeHorizontalSeams(image, 0)
ImageHelpers.saveToFile(image, "holiday_beach_seam_carved")
