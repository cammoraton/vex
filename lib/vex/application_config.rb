Dir[File.dirname(__FILE__) + '/parser/*.rb'].each {|file| require file }

module Vex
  class ApplicationConfig
    include Vex::Dsl::ClassFactory
    
    def initialize(file)
      raise "Exception!" unless FileTest::exist?(file)
      @filename = file
      @models = Array.new
    end
    
    def load
      parse_file
      @models.each do |model|
        #object.execute
      end
    end
    
    private
    def parse_file
      block_header = nil
      lines = Array.new
      file = File.open(@filename, "r")
      file.each_line do |line|
        if line.match(/\[.*\]/)
          delegate(block_header, lines) unless block_header.nil?
          block_header = line.strip.chomp.gsub(/[\[|\]]/, '')
          lines = Array.new
        else
          lines.push(line.chomp.strip) unless line.chomp.strip.match(/^#/) or line.chomp.strip.length < 1
        end
      end
      delegate(block_header, lines) unless block_header.nil?
      file.close
    end
    
    def delegate(block_header, lines)
      case block_header
      when "main"
        object = Vex::Parser::Main.new(lines)
      when "hierarchy"
        object = Vex::Parser::Hierarchy.new(lines)
      else
        object = Vex::Parser::Model.new(block_header, lines)
        @models.push(object)
      end
      #object.parse
      return nil
    end
  end
end