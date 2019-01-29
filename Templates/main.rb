#!/usr/bin/env ruby

require 'fileutils'
require './generator'
require './parameters'

PATH = "VIPER Templates"
RESOURCES = "Resources"


def generate_xib(template, interface, complexity, source_folder, destination_folder)
    return unless interface.generate_xib
    generator = Generator.new("#{source_folder}/___FILEBASENAME___ViewController.xib.erb", template, interface, complexity)
    generator.save "#{destination_folder}/___FILEBASENAME___ViewController.xib"
end

def generate_sb(template, interface, complexity, source_folder, destination_folder)
    return unless interface.generate_sb
    generator = Generator.new("#{source_folder}/___FILEBASENAME___.storyboard.erb", template, interface, complexity)
    generator.save "#{destination_folder}/___FILEBASENAME___.storyboard"
end

def generate_interfaces(template, interface, complexity, source_folder, destination_folder)
    generator = Generator.new("#{source_folder}/___FILEBASENAME___Interfaces.swift.erb", template, interface, complexity)
    generator.save "#{destination_folder}/___FILEBASENAME___Interfaces.swift"
end

def generate_wireframe(template, interface, complexity, source_folder, destination_folder)
    generator = Generator.new("#{source_folder}/___FILEBASENAME___Wireframe.swift.erb", template, interface, complexity)
    generator.save "#{destination_folder}/___FILEBASENAME___Wireframe.swift"
end

def generate_presenter(template, interface, complexity, source_folder, destination_folder)
    generator = Generator.new("#{source_folder}/___FILEBASENAME___Presenter.swift.erb", template, interface, complexity)
    generator.save "#{destination_folder}/___FILEBASENAME___Presenter.swift"
end

def generate_interactor(template, interface, complexity, source_folder, destination_folder)
    return unless complexity.generate_interactor
    generator = Generator.new("#{source_folder}/___FILEBASENAME___Interactor.swift.erb", template, interface, complexity)
    generator.save "#{destination_folder}/___FILEBASENAME___Interactor.swift"
end

def generate_formatter(template, interface, complexity, source_folder, destination_folder)
    return unless complexity.generate_formatter
    generator = Generator.new("#{source_folder}/___FILEBASENAME___Formatter.swift.erb", template, interface, complexity)
    generator.save "#{destination_folder}/___FILEBASENAME___Formatter.swift"
end

def generate_view(template, interface, complexity, source_folder, destination_folder)
    generator = Generator.new("#{source_folder}/___FILEBASENAME___ViewController.swift.erb", template, interface, complexity)
    generator.save "#{destination_folder}/___FILEBASENAME___ViewController.swift"
end

def generate(template, interface, complexity)
    source_folder = "#{RESOURCES}/Templates"
    destination_folder = "#{PATH}/#{template.name}.xctemplate/#{interface.name}#{complexity.name}"
    generate_xib(template, interface, complexity, source_folder, destination_folder)
    generate_sb(template, interface, complexity, source_folder, destination_folder)
    generate_interfaces(template, interface, complexity, source_folder, destination_folder)
    generate_wireframe(template, interface, complexity, source_folder, destination_folder)
    generate_presenter(template, interface, complexity, source_folder, destination_folder)
    generate_interactor(template, interface, complexity, source_folder, destination_folder)
    generate_formatter(template, interface, complexity, source_folder, destination_folder)
    generate_view(template, interface, complexity, source_folder, destination_folder)
end

def generate_info_plist(template)
    generator = Generator.new("#{RESOURCES}/TemplateInfo.plist.erb", template, Interface, Complexity)
    generator.save "#{PATH}/#{template.name}.xctemplate/TemplateInfo.plist"
end

def copy_images(template)
    source = "#{RESOURCES}/Images/."
    destination = "#{PATH}/#{template.name}.xctemplate"
    FileUtils.cp_r source, destination
end

Template.types.each do |template|
    generate_info_plist template
    copy_images template
    
    Interface.types.each do |interface|
        Complexity.types.each do |complexity|

            generate(template, interface, complexity)

        end
    end
end