class Template
    attr_accessor :name, :generate_io
end

class Interface
    attr_accessor :name, :generate_xib, :generate_sb, :wireframe_sb
end

class Complexity
    attr_accessor :name, :generate_interactor, :generate_formatter
end

module Initializable

    def initialize(params)
        params.each do |key, value|
          instance_variable_set("@#{key}", value)
        end
    end

end

class Template 
    include Initializable

    def self.types
        [normal, rx]
    end

    def self.normal
        Template.new({
            name: "Module",
            generate_io: false
        })
    end

    def self.rx
        Template.new({
            name: "RxModule",
            generate_io: true
        })
    end
end

class Interface 
    include Initializable

    def self.types
        [xib, none, storyboard]
    end

    def self.default
        none
    end

    def self.storyboard
        Interface.new({
            name: "Storyboard",
            generate_xib: false,
            generate_sb: true,
            wireframe_sb: true
        })
    end

    def self.xib
        Interface.new({
            name: "XIB",
            generate_xib: true,
            generate_sb: false,
            wireframe_sb: false
        })
    end

    def self.none
        Interface.new({
            name: "None",
            generate_xib: false,
            generate_sb: false,
            wireframe_sb: true
        })
    end
end

class Complexity 
    include Initializable

    def self.types
        [simple, normal, hard]
    end

    def self.default
        normal
    end

    def self.normal
        Complexity.new({
            name: "Interactor",
            generate_interactor: true,
            generate_formatter: false
        })
    end

    def self.simple
        Complexity.new({
            name: "Simple",
            generate_interactor: false,
            generate_formatter: false
        })
    end

    def self.hard
        Complexity.new({
            name: "InteractorAndFormatter",
            generate_interactor: true,
            generate_formatter: true
        })
    end
end