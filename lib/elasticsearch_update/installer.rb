require 'logger'

module ElasticsearchUpdate
  # This class is in charge of retrieving and downloading data.
  class Installer
    attr_accessor :sudo_password, :extension
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

    def install_file(file)
      case @extension
      when '.zip'

      when '.deb'
        install_update_file(file, @extension)
      when '.rpm'
        install_update_file(file, @extension)
      when '.tar.gz'

      end
    end

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

    def unzip_file(file)
    end
  end
end
