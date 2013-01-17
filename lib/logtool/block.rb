module LogTool
  class Block
    attr_accessor :text, :ip, :method, :response, :asset, :time

    def to_s
      @text
    end

    def is_asset?
      @asset
    end

    def head
      @text.split("\n").first
    end

    def tail
      @text.split("\n").last
    end

    def self.head
      #$1 = method, $2 = IP
      /^Started (GET|POST|PUT|DELETE) ".+?" for (\d\d?\d?.\d\d?\d?.\d\d?\d?.\d\d?\d?) at .*$/
    end

    def self.head_2_3 # old rails head
      #$1 = IP, $2 = method
      /^Processing .+? \(for (\d\d?\d?.\d\d?\d?.\d\d?\d?.\d\d?\d?) at .*?(GET|POST|PUT|DELETE).*$/
    end

    def self.tail
      # $1 = response
      time = /\d+(ms|s)/
        /^Completed (\d\d\d) .+? in (\d+ms)$/
    end

    def self.asset_tail
      # $1 = response, $2 = time
      time = /\d+(ms|s)/
        /^Served asset [0-9a-zA-Z\/._]+ - (\d\d\d) .*? \((\d+ms)\)$/
    end

    def test_for(query)
      eval query
    rescue => e
      LogTool::fatal_error("Bad filter. #{e.message}")
    end
  end
end
