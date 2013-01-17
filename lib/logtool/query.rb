module LogTool
  class Query
    def initialize(blocks, options)
      @blocks = blocks
      @filter = parse_filter(options[:mode_args])
      @target_data = parse_target_data(options[:mode_args])
    end

    def target_data_type
      %W(ip head tail method time)
    end

    def parse_target_data(args)
      if target_data_type.include?(args[1])
        args[1]
      else
        LogTool::fatal_error("Undefined target data type: #{args[1]}")
      end
    end

    def keywords
      target_data_type + %W(ip and or not < > <= >= == != asset)
    end

    def ip_regexp
      /\d\d?\d?\.\d\d?\d?\.\d\d?\d?\.\d\d?\d?/
    end

    def parse_filter(options)
      filter = []
      options.first.split.each do |word|
        if keywords.include?(word) 
          filter << word
        elsif word =~ ip_regexp 
          filter << "\"#{word}\""
        elsif word =~ /\d+/ 
          filter << word
        else
          LogTool::fatal_error("Invalid filter keyword: #{word}")
        end
      end
      filter.join(' ')
    end

    def run
      @blocks.find_all{|b| b.test_for(@filter)}.each{|b| puts b.send(@target_data)}
    end

  end
end
