# BrickEvent - Management of LEGO (and other exhibition) events
# Version Number
class SoftwareVersion

  def self.app_name
    "Bricking Bavaria Veranstaltungen"
  end

  def self.release_number
    "0.1"
  end

  def self.build_number
    build_number_file_name = "build_number"
    build_number = "dev"
    if File.exist?(build_number_file_name)
      build_number = IO.read(build_number_file_name)
    end
    build_number
  end

end
