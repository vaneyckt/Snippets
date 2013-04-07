module ColorHelpers
  def self.colorDistance(color_a, color_b)
    color_a = rgbToLab(color_a)
    color_b = rgbToLab(color_b)

    d0 = color_b[0] - color_a[0]
    d1 = color_b[1] - color_a[1]
    d2 = color_b[2] - color_a[2]

    Math.sqrt((d0 * d0) + (d1 * d1) + (d2 * d2))
  end

  def self.rgbToLab(color)
    # rgb to xyz
    var_R = (color[0].to_f / 255.0)
    var_G = (color[1].to_f / 255.0)
    var_B = (color[2].to_f / 255.0)

    if (var_R > 0.04045)
      var_R = ((var_R + 0.055) / 1.055) ** 2.4
    else
      var_R = var_R / 12.92
    end

    if (var_G > 0.04045)
      var_G = ((var_G + 0.055) / 1.055) ** 2.4
    else
      var_G = var_G / 12.92
    end

    if (var_B > 0.04045)
      var_B = ((var_B + 0.055) / 1.055) ** 2.4
    else
      var_B = var_B / 12.92
    end

    var_R = var_R * 100.0
    var_G = var_G * 100.0
    var_B = var_B * 100.0

    x = var_R * 0.4124 + var_G * 0.3576 + var_B * 0.1805
    y = var_R * 0.2126 + var_G * 0.7152 + var_B * 0.0722
    z = var_R * 0.0193 + var_G * 0.1192 + var_B * 0.9505

    # xyz to lab
    var_X = x / 95.047
    var_Y = y / 100.000
    var_Z = z / 108.883

    if (var_X > 0.008856)
      var_X = var_X ** (1.0 / 3.0)
    else
      var_X = (7.787 * var_X) + (16.0 / 116.0)
    end

    if (var_Y > 0.008856)
      var_Y = var_Y ** (1.0 / 3.0)
    else
      var_Y = (7.787 * var_Y) + (16.0 / 116.0)
    end

    if (var_Z > 0.008856)
      var_Z = var_Z ** (1.0 / 3.0)
    else
      var_Z = (7.787 * var_Z) + (16.0 / 116.0)
    end

    l = (116.0 * var_Y) - 16.0
    a = 500.0 * (var_X - var_Y)
    b = 200.0 * (var_Y - var_Z)

    [l, a, b]
  end
end
