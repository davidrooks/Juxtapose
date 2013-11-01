$:.unshift File.join(File.dirname(__FILE__), 'lib')

require 'juxtapose_manager'

@juxtapose_manager

task :config  do |t|
  if ENV.has_key? 'ENV'
    env = ENV['ENV']
  else
    env = 'dev'
  end
  @juxtapose_manager = JuxtaposeManager.new("#{env}")
end

desc 'Create a baseline of screenshots to compare against'
task :get_baseline => [:config, :reset_baseline_folder, :get_baseline_images, :generate_baseline_thumbnails] do
  puts 'Done setting baseline!'
end

desc 'Get up to date screenshots to compare against baseline'
task :get_current => [:config, :reset_current_folder, :get_current_images] do
  puts 'Done getting current screenshots!'
end

task :reset_baseline_folder do
  @juxtapose_manager.reset_shots_folder 'baseline'
end

task :reset_current_folder do
  @juxtapose_manager.reset_shots_folder 'current'
end

task :save_images do
  @juxtapose_manager.save_images
end

task :get_baseline_images do
  @juxtapose_manager.get_images 'baseline'
end

task :get_current_images do
  @juxtapose_manager.get_images 'current'
end

task :crop_baseline_images do
  @juxtapose_manager.crop_images 'baseline'
end

task :crop_current_images do
  @juxtapose_manager.crop_images 'current'
end

task :generate_baseline_thumbnails do
  @juxtapose_manager.generate_thumbnails 'baseline'
end


task :generate_current_thumbnails do
  @juxtapose_manager.generate_thumbnails 'current'
end

desc 'Compare baseline images with current images'
task :compare_images => [:config] do
  the_same = @juxtapose_manager.compare_and_confirm_images_are_same
  if !the_same
    Rake::Task['generate_current_thumbnails'].execute
    sh "open -a \"/Applications/Firefox.app\" --args \"localhost:4567\""
  end
end

task :generate_gallery  => [:config]  do
  sh "ruby app.rb"
end
