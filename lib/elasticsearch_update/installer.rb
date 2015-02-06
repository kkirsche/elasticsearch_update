require 'logger'

module ElasticsearchUpdate
  # This class is in charge of retrieving and downloading data.
  class Installer
    def initialize(password, extension)
      @log = Logger.new(STDOUT)
      @log.level = Logger::INFO

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
      command = 'echo ' + sudo_passwd + ' | sudo -S dpkg -i "' + file.path + '"'
      system(command)
    end

    def install_rpm_file(file)
      @log.info('Installing .deb file.')
      command = 'echo ' + sudo_passwd + ' | sudo -S rpm -i "' + file.path + '"'
      system(command)
    end
  end
end
