require 'active_support/all'
require 'active_model'

require 'cassandra/0.7'

require 'cassandrb/criteria'
require 'cassandrb/extensions'

module Cassandrb
  extend ActiveSupport::Autoload
  
  autoload :Model
  autoload :Columns
  autoload :AttributeMethods

  class << self

    def config=(hash)
      @config = hash.symbolize_keys
    end

    def config
      @config ||= {}
    end

    def client=(client)
      Thread.current[:cassandra_client] = client
    end

    def client
      Thread.current[:cassandra_client] ||= Cassandra.new(self.keyspace, self.servers.to_s)
    end

    def configure(config_file, environment = 'development')
      config_file = File.expand_path(config_file)
      config_hash = YAML.load(ERB.new(File.read(config_file)).result).with_indifferent_access
      self.config = config_hash || {}

      environment = environment.to_sym
      env_config = config[environment]
      extract_config(env_config)
    rescue Errno::ENOENT
      raise Cassandrb::MissingConfiguration.new(config_file)        
    end

    def keyspace=(keyspace)
      @keyspace= keyspace
    end

    def keyspace
      @keyspace ||= 'Keyspace1'
    end

    def servers=(servers=[])
      @servers = servers
    end

    def servers
      @servers ||= ['localhost:9160']
    end

    private
      def extract_config(env_config)
        self.keyspace= env_config[:keyspace]

        servers = env_config[:servers]

        tmp = Array.new
        servers.each do |server|
          tmp << "#{server[:host]}:#{server[:port]}"
        end
        self.servers= tmp
      end

  end

  class MissingConfiguration < StandardError
    def initialize(file_path)
      super("missing_configuration")
    end
  end
end

require 'cassandrb/railtie' if defined? Rails::Railtie