require File.join(File.dirname(File.expand_path(__FILE__)), "block.rb")

module LogTool
  class Parser

    def self.open_log(file_path)
      yield File.open(file_path)
    rescue Errno::ENOENT
      puts "#{file_path}: No such file or directory"
      exit 1
    rescue Errno::EACCES
      puts "#{file_path}: Permission denied"
      exit 2
    end

    def self.parse_blocks(file_path)
      blocks = []
      block = nil
      open_log(file_path) do |fh|
        fh.read.split("\n").each do |line|
          if line =~ Block.head
            blocks << block if block
            block = Block.new
            block.method = $1
            block.ip = $2
            block.text = line + "\n"
          elsif line =~ Block.head_2_3
            blocks << block if block
            block = Block.new
            block.method = $2
            block.ip = $1
            block.text = line + "\n"
          elsif block and line =~ Block.tail
            block.response = $1
            block.time = $2
            block.text += line + "\n"
            block.freeze
          elsif block and line =~ Block.asset_tail
            block.response = $1
            block.time = $2
            block.text += line + "\n"
            block.freeze
          else
            block.text += line + "\n" if block and !block.frozen?
          end
        end
      end
      return blocks
    end
  end
end
