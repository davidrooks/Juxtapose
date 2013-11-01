require 'sinatra'
require 'erb'
require 'pp'
require 'fileutils'

MATCH_FILENAME = /(\S+)_(\S+)_(\S+)\.\S+/
TEMPLATE_LOCATION = "gallery/gallery_template.erb"
TEMPLATE_BY_DOMAIN_LOCATION = "gallery/gallery_template.erb"
BOOTSTRAP_LOCATION = "gallery/bootstrap.min.css"

NEW_DIRECTORY = 'public/screenshots_current'
BASELINE_DIRECTORY = 'public/screenshots_baseline'
LABEL = 'dev'

def parse_directories
  dirs = {}
  categories = Dir.foreach(NEW_DIRECTORY).select do |category|
    if ['.', '..', 'thumbnails'].include? category
      # Ignore special dirs
      false
    elsif File.directory? "#{NEW_DIRECTORY}/#{category}" then
      # Ignore stray files
      true
    else
      false
    end
  end

  categories.each do |category|
    dirs[category] = {}
    Dir.foreach("#{NEW_DIRECTORY}/#{category}") do |filename|
      match = filename.split('_')
      if match.size == 3 then
        size = match[1].to_i
        group = match[2].split('.')[0]
        filepath = category + '/' + filename
        thumbnail = "thumbnails/#{category}/#{filename}"

        if dirs[category][size].nil? then
          dirs[category][size] = {:baseline => []}
        end
        size_dict = dirs[category][size]

        unless filename.include? LABEL
          size_dict[:diff] = {
              :name => 'baseline',
              :filename => NEW_DIRECTORY.gsub("public/", "") + '/' + filepath,
              :thumb => NEW_DIRECTORY.gsub("public/", "") + '/' + thumbnail
          }
          size_dict[:baseline] = {
              :name => 'baseline',
              :filename => BASELINE_DIRECTORY.gsub("public/", "") + '/' + filepath.gsub(group, LABEL),
              :thumb => BASELINE_DIRECTORY.gsub("public/", "") + '/' + thumbnail.gsub(group, LABEL)
          }
        end
      end
    end
  end

  return dirs
end


get '/' do
  @directories = parse_directories
  erb :gallery_template
end

post '/' do
  @old = 'public/' + params[:old_file]
  @new = 'public/' + params[:new_file]

  FileUtils.rm(@new)

  @new = 'public/' + params[:new_file].gsub('diff', LABEL)

  FileUtils.mv(@new, @old)

  @directories = parse_directories
  erb :gallery_template
end