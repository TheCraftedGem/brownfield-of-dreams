namespace :db do
  desc "Apply a '0' value to all nil video positions"
  task :set_video_positions => :environment do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    Video.where(position: nil).update(position: 0)
  end
end
