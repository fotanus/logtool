#!/usr/bin/env ruby

require File.join(File.dirname(File.expand_path(__FILE__)), "logtool", "block.rb")
require File.join(File.dirname(File.expand_path(__FILE__)), "logtool", "parser.rb")
require File.join(File.dirname(File.expand_path(__FILE__)), "logtool", "query.rb")

module LogTool
  def self.usage
<<USAGE
	Usage: logtool file mode mode_options

	File is the rails log file that should be parsed. Mode can be either gtk or query. For gtk, a window will open and let you explore the log file. For query, you can write a query that will be executed on the log entries.

	== Query mode ==
	  When using the query mode, mode_options should be in the following format: filter information [options]. The first parameter filters the log entries, the second one is the information you want to retrieve. The last one is the only optional one, where you can specify further options.
	  ==filter==
	  Boolean Operators: and, or, not
	  Value Operators ==, <=, >=, <, >
	  Values: ip, method, response, asset

	  ==information to retrieve==
	  ip, head, tail, method, time

	  ==options==
	  -l num: shows only the last num entries.

	  Examples:
	  logtool log/production.log query "ip == 127.0.0.1" head
	  logtool log/production.log query "(ip == 127.0.0.1) and not asset" head
	  logtool log/production.log query "(ip == 127.0.0.1) or (ip == 0.0.0.0) and not asset" head
	  logtool log/production.log query "response > 200" ip
USAGE
  end

  def self.fatal_error(err_msg=nil)
    puts err_msg if err_msg
    puts usage
    exit 1
  end

  def self.supported_modes
    %W(query)
  end

  def self.parse_args
    fatal_error if ARGV.size < 2

    options = {}
    options[:input_file] = ARGV[0]
    options[:mode] = ARGV[1]
    options[:mode_args] = ARGV[2..-1]

    fatal_error("Invalid mode") unless self.supported_modes.include?(options[:mode])

    return options
  end

  public
  def self.execute
    options = parse_args
    blocks = Parser.parse_blocks(options[:input_file])

    case options[:mode]
    when 'query' then
      query = Query.new(blocks, options)
      query.run
    else puts "Mode not implemented"; exit 1
    end
  end
end
