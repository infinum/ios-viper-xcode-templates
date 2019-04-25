require 'erb'
require 'fileutils'

class Generator
    include ERB::Util
    attr_accessor :template, :interface, :complexity
  
    def initialize(template_file, template, interface, complexity)
      @template_file = IO.read template_file
      @template = template
      @interface = interface
      @complexity = complexity
    end
  
    def render()
      ERB.new(@template_file, nil, "-").result(binding)
    end
  
    def save(file_name)
      dirname = File.dirname(file_name)
      unless File.directory?(dirname)
        FileUtils.mkdir_p(dirname)
      end
      IO.write(file_name, render)
    end

end