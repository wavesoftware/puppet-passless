module WaveSoftware::PassLess
  module SslDirResolver
    DEFAULT_PROC = Proc.new do
      Puppet.initialize_settings if Puppet.settings.app_defaults_initialized?.nil?
      Pathname.new(Puppet.settings[:ssldir])
    end
    
    def self.impl(proc)
      @proc = proc
    end

    def self.resolve
      @proc ||= DEFAULT_PROC
      @proc.call
    end
  end
end
