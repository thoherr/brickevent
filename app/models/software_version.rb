##
# Defines the Software Version Number of this Application
#

class SoftwareVersion

  @@appname_filename = "APPNAME"
  @@release_filename = "RELEASE"
  @@buildnumber_filename = "BUILDNUMBER"
  @@revision_filename = "REVISION"

  @@appname_default = "MyApp"
  @@release_default = "0.0"
  @@buildnumber_default = "developer build"
  @@revision_default = "dirty"

  # the overall version string as "release (buildnumber, revision)"
  def self.versionstring
    "#{self.release} (#{self.buildnumber}, #{self.revision})"
  end

  # the name of this application, read from the APPNAME file
  def self.appname
    appname = @@appname_default
    if File.exist?(@@appname_filename)
      appname = IO.read(@@appname_filename)
    end
    appname.strip
  end

  # the software release, read from the RELEASE file
  def self.release
    release = @@release_default
    if File.exist?(@@release_filename)
      release = IO.read(@@release_filename)
    end
    release.strip
  end

  # the build number, read from the BUILDNUMBER file
  def self.buildnumber
    buildnumber = @@buildnumber_default
    if File.exist?(@@buildnumber_filename)
      buildnumber = IO.read(@@buildnumber_filename)
    end
    buildnumber.strip
  end

  # the git revision, read from the REVISION file created by our build system, truncated to 6 characters
  def self.revision
    self.full_revision[0..5]
  end

  # the git revision, read from the REVISION file created by our build system
  def self.full_revision
    revision = @@revision_default
    if File.exist?(@@revision_filename)
      revision = IO.read(@@revision_filename)
    end
    revision.strip
  end

end
