class Badges < Thor
  desc "set [BADGE NAME] [IMAGE PATH]","set the image of the specified badge with the image from the specified image path."
  method_options verbose: :boolean
  def set(badge_name,image_path)
    require File.expand_path("config/environment.rb")

    # Find the badge with the given name
    badge=Badge.find_by_name! badge_name

    # Set the image
    badge.image=File.open image_path
    badge.save!
    
    puts "Successfully set image of #{badge_name} badge." if options[:verbose]

  rescue Errno::ENOENT => e
    puts "Image file not found."
  rescue ActiveRecord::RecordNotFound => e
    puts "Cannot find a badge with the given name."
  end

  desc "autoset [BADGE NAME]","set the image of the specified badge with the image from the path: data/badge_images/[BADGE NAME].gif or .png"
  method_options verbose: :boolean
  def autoset(badge_name)
    image_path="data/badge_images/#{badge_name}.gif"
    if (!File.exist? image_path)
      image_path="data/badge_images/#{badge_name}.png"
    end
    set(badge_name,image_path)

    puts "Successfully set image of #{badge_name} badge with image path: #{image_path}." if options[:verbose]
  end

  desc "autosetall","set the image of all badges with the images from the paths with format: data/badge_images/[BADGE NAME].gif or .png"
  method_options verbose: :boolean
  def autosetall
    require File.expand_path("config/environment.rb")

    badges=Badge.all
    badges.each do |badge|
      autoset(badge.name)
    end
  end
end
