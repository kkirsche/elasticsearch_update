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
        install_deb_file(file)
      when '.rpm'
        install_rpm_file(file)
      when '.tar.gz'

      end
    end

    def install_deb_file(file)
      @log.info('Installing .deb file.')
      command = 'echo ' + @sudo_password + ' | sudo -S dpkg -i "' + file.path + '"'
      Kernel.system(command)
    end

    def install_rpm_file(file)
      @log.info('Installing .rpm file.')
      command = 'echo ' + @sudo_password + ' | sudo -S rpm -i "' + file.path + '"'
      Kernel.system(command)
    end
  end
end
