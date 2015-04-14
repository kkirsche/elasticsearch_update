module ElasticsearchUpdate
  class Download
    attr_accessor :base_url, :version, :extension, :url, :verify_url
    def initialize(args)
      self.base_url = 'download.elastic.co'
      self.version =  args[:version]
      self.extension =  args[:extension]
      self.url = 'https://' + @base_url +
        '/elasticsearch/elasticsearch/elasticsearch-' + @version + @extension
      self.verify_url = 'https://' + @base_url +
        '/elasticsearch/elasticsearch/elasticsearch-' + @version + @extension +
        '.sha1.txt'
    end

    def to_h
      Hash[instance_variables.map do |name|
        clean_name = name[1..-1].to_sym if name[0] == '@'
        [clean_name, instance_variable_get(name)]
      end]
    end

    def to_a
      array = []
      instance_variables.map do |name|
        clean_name = name[1..-1].to_sym if name[0] == '@'
        array.push([clean_name, instance_variable_get(name)])
      end

      array
    end
  end
end
