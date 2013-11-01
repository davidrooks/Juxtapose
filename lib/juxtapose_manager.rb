require 'juxtapose'
#require 'image_size'

class JuxtaposeManager
  attr_reader :juxtapose

  def initialize(config)
    @juxtapose = Juxtapose.new(config)
  end

  def baseline_directory
    juxtapose.baseline_directory
  end

  def current_directory
    juxtapose.current_directory
  end

  def base_domain_label
    juxtapose.base_domain_label
  end

  def compare_and_confirm_images_are_same
    files = Dir.glob("#{juxtapose.baseline_directory}/*/*.png").sort

    res = true

    files.each do |baseline_file|
      current_file = baseline_file.gsub(juxtapose.baseline_directory, juxtapose.current_directory)
      diff = current_file.gsub(/([a-z]+).png$/, 'diff.png')
      res = false unless juxtapose.compare_images(baseline_file, current_file, diff)
    end
    res
  end

  def self.reset_shots_folder(dir)
      FileUtils.rm_rf("./#{dir}")
      FileUtils.mkdir("#{dir}")
  end

  def reset_shots_folder(directory)
    self.class.reset_shots_folder(juxtapose.baseline_directory) if directory == 'baseline'
    self.class.reset_shots_folder(juxtapose.current_directory) if directory == 'current'
  end

  def get_images(directory)
    directory = juxtapose.baseline_directory if directory == 'baseline'
    directory = juxtapose.current_directory if directory == 'current'

    juxtapose.paths.each do |label, path|
      puts "processing '#{label}' '#{path}'"
      if !path
        path = label
        label = path.gsub('/','_')
      end

      FileUtils.mkdir("#{directory}/#{label}")
      FileUtils.mkdir_p("#{directory}/thumbnails/#{label}")

      base_url = juxtapose.base_domain + path

      juxtapose.browsers.each do |browser|
        juxtapose.start_browser browser
        juxtapose.widths.each do |width|
          base_file_name = "#{directory}/#{label}/#{browser}_#{width}_#{juxtapose.base_domain_label}.png"
          juxtapose.capture_page_image base_url, width, base_file_name
        end
        juxtapose.close_browser
      end
    end
  end

  def self.crop_images(dir)
    files = Dir.glob("#{dir}/*/*.png").sort

    while !files.empty?
      compare = files.slice!(0, 1)
      base = ''
      File.open(base, "rb") do |fh|
        new_base_height = ImageSize.new(fh.read).size

        base_height = new_base_height[1]

        File.open(compare, "rb") do |fh|
          new_compare_height = ImageSize.new(fh.read).size
          compare_height = new_compare_height[1]

          if base_height > compare_height
            height = base_height
            crop = compare
          else
            height = compare_height
            crop = base
          end

          juxtapose.crop_images(crop, height)
        end
      end
    end
  end

  def crop_images(directory)
    self.class.crop_images juxtapose.current_directory if directory == 'current'
    self.class.crop_images juxtapose.baseline_directory if directory == 'baseline'
  end

  def generate_thumbnails(directory)
    directory = juxtapose.baseline_directory if directory == 'baseline'
    directory = juxtapose.current_directory if directory == 'current'
    Dir.glob("#{directory}/*/*.png").each do |filename|
      new_name = filename.gsub(/^#{directory}/, "#{directory}/thumbnails")
      juxtapose.thumbnail_image(filename, new_name)
    end
  end
end