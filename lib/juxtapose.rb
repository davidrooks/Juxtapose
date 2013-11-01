require 'yaml'
require 'watir-webdriver'
require 'chunky_png'

class Juxtapose
  attr_accessor :config

  def initialize(config_name)
    @config = YAML::load(File.open("configs/#{config_name}.yml"))
  end

  def baseline_directory
    @config['directory']['baseline']
  end

  def current_directory
    @config['directory']['current']
  end

  def widths
    @config['screen_widths']
  end

  def browsers
    @config['browsers']
  end

  def domain
    @config['domain']
  end

  def base_domain
    domain[base_domain_label]
  end

  def base_domain_label
    domain.keys[0]
  end

  def paths
    @config['paths']
  end

  def start_browser(browser)
    @b = Watir::Browser.new :chrome, :switches => %w[--ignore-certificate-errors] if browser == 'chrome'
    @b = Watir::Browser.new :firefox if browser == 'firefox'
    @b = Watir::Browser.new :ie if browser == 'ie'
    @b = Watir::Browser.new :safari if browser == 'safari'
  end

  def close_browser
    @b.close
    @b = nil
  end

  def capture_page_image (url, width, file_name)
    if !defined? @b  or @b.nil?
      @b = Watir::Browser.new
    end
    @b.window.resize_to(width, 600)
    @b.goto url
    @b.screenshot.save file_name
  end


  def compare_images (base, compare, output)
    images = [
        ChunkyPNG::Image.from_file(base),
        ChunkyPNG::Image.from_file(compare)
    ]

    diff = []

    images.first.height.times do |y|
      images.first.row(y).each_with_index do |pixel, x|
        if  (y < images.last.height) and (x < images.last.width)
          diff << [x,y] unless pixel == images.last[x,y]
        end
      end
    end

    #puts "pixels (total):     #{images.first.pixels.length}"
    #puts "pixels changed:     #{diff.length}"
    #puts "pixels changed (%): #{(diff.length.to_f / images.first.pixels.length) * 100}%"

    x, y = diff.map{ |xy| xy[0] }, diff.map{ |xy| xy[1] }

    if (diff.length.to_f / images.first.pixels.length) * 100 != 0
      images.last.rect(x.min, y.min, x.max, y.max, ChunkyPNG::Color.rgb(0,255,0)) unless (x.nil? or y.nil?)

      images.last.save(output)
      return false
    end
    true
  end

  def self.crop_images (crop, height)
    `convert #{crop} -background none -extent 0x#{height} #{crop}`
  end

  def crop_images(crop, height)
    self.class.crop_images crop, height
  end

  def thumbnail_image(png_path, output_path)
    `convert #{png_path} -thumbnail 200 -crop 200x200+0+0 #{output_path}`
  end
end
