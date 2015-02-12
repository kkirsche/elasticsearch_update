require 'logger'

module ElasticsearchUpdate
  # == Installer
  # ElasticsearchUpdate::Installer class is used to install the downloaded
  # Elasticsearch update file.
  #
  # == Parameters
  #
  # Initilization requires a sudo +password+, file +extension+, and optional +test+ parameter.
  #
  # +password+ is String. Ex. 'test_password'
  #
  # +extension+ is String. Ex. '.deb'
  #
  # +test+ is a boolean identifying whether or not we are in a test
  # if we are, we set the Logger to logging FATAL errors only.
  #
  # == Example
  #
  #    ElasticsearchUpdate::Installer.new('test_password', '.deb')
  class Installer
    attr_accessor :sudo_password, :extension
    # == initialize
    # Allows us to create an instance of the Installer.
    #
    # == Parameters
    #
    # Initilization requires a sudo +password+, file +extension+, and optional +test+ parameter.
    #
    # +password+ is String. Ex. 'test_password'
    #
    # +extension+ is String. Ex. '.deb'
    #
    # +test+ is a boolean identifying whether or not we are in a test
    # if we are, we set the Logger to logging FATAL errors only.
    #
    # == Example
    #
    #    ElasticsearchUpdate::Installer.new('test_password', '.deb')
    def initialize(password, extension, test = false)
      @log = Logger.new(STDOUT)
      if test
        @log.level = Logger::FATAL
      else
        @log.level = Logger::INFO
      end

      @log.debug('Logger created for Installer.')

      @sudo_password = password
      @extension = extension
    end

    # == install_file
    # Uses the extension found in the @extension variable set on initilization
    # to determine what command should be used to install the update file.
    #
    # == Parameters
    #
    # install_file requires the update +file+ as a parameter.
    #
    # +file+ is File or Tempfile object. Ex. Tempfile.new('es_update_file')
    #
    # == Example
    #
    #    install_file(Tempfile.new('es_update_file'))
    def install_file(file)
      case @extension
      when '.zip'
        true
      when '.deb'
        install_update_file(file, @extension)
      when '.rpm'
        install_update_file(file, @extension)
      when '.tar.gz'
        true
      end
    end

    # == install_update_file
    # Uses the given file and extension to install the service version of
    # Elasticsearch from an RPM or DEB file.
    #
    # == Parameters
    #
    # install_update_file requires the update +file+ and +extension+ as a parameter.
    #
    # +file+ is File or Tempfile object. Ex. Tempfile.new('es_update_file')
    #
    # +extension+ is String. Ex. '.deb'
    #
    # == Example
    #
    #    install_update_file(Tempfile.new('es_update_file'), '.deb')
    def install_update_file(file, extension)
      @log.info('Installing' + extension + 'file.')
      command = 'echo ' + @sudo_password + ' | '
      case extension
      when '.deb'
        command += 'sudo -S dpkg -i "' + file.path + '"'
      when '.rpm'
        command += 'sudo -S rpm -i "' + file.path + '"'
      end
      Kernel.system(command)
    end

    # == unzip_file
    # In development. Nothing occurs.
    def unzip_file(file)
    end
  end
end
