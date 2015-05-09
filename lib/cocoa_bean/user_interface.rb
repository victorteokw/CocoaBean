# coding: utf-8
module CocoaBean
  class UserInterface
    require 'byebug'
    require 'colored'

    # "normal" or "verbose"
    def self.level(level)
      @level = level
    end

    def self.exit(message)
      puts ('[✗] ' + message).red
      Kernel.exit
    end

    def self.happy(message)
      puts ('[✔] ' + message).green
    end

    def self.info(message)
      puts ('[✍] ' + message).gray
    end

    def self.warn(message)
      puts ('[!] ' + message).yellow
    end

    def self.verbose(message)
      puts message if @level == "verbose"
    end

  end
end
