#Implement a class called LineAnalyzer.
class LineAnalyzer
  attr_reader :highest_wf_count, :highest_wf_words, :content, :line_number

  def initialize(content, line_number)
    @content = content
    @line_number = line_number
    @highest_wf_count = 0
    @highest_wf_words = []
    calculate_word_frequency
  end 

  def calculate_word_frequency
    freq = {} 
    words = @content.split(" ")
    words.each do |word|
      word.downcase!
      freq[word] ||= 0
      freq[word] += 1
      @highest_wf_count = @highest_wf_count > freq[word] ? @highest_wf_count : freq[word]
    end 
    freq.each do |key, val| 
      if val == @highest_wf_count
        @highest_wf_words << key
      end
    end
  end
end

#  Implement a class called Solution. 
class Solution
  attr_reader :analyzers, :highest_count_across_lines, :highest_count_words_across_lines

  def initialize
    @analyzers = []
  end

  def analyze_file
    i = 1
    File.readlines("test.txt").each do |line|
      @analyzers << LineAnalyzer.new(line, i)
      i += 1
    end 
  end

  def calculate_line_with_highest_frequency
    @highest_count_across_lines ||= 0
    @analyzers.each do |cur| 
      if cur.highest_wf_count > @highest_count_across_lines
        @highest_count_across_lines = cur.highest_wf_count 
      end
    end
    @highest_count_words_across_lines ||= []
    @analyzers.each do |cur| 
      if cur.highest_wf_count == @highest_count_across_lines
        @highest_count_words_across_lines << cur
      end
    end
  end 

  def print_highest_word_frequency_across_lines
    out = ""
    @highest_count_words_across_lines.each do |cur| 
      out = out + "["
      cur.highest_wf_words.each do |word| 
        out = out + "\"#{word.downcase}\", "
      end
      out = out.chomp(", ")
      out += "] (appears in line #{cur.line_number})\n"
    end 
    puts out
  end
end
