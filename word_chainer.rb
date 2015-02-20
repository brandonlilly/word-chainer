require 'set'

class WordChainer

  def initialize(dictionary_file_name)
    @dictionary = Set.new(File.readlines(dictionary_file_name).map(&:chomp))
  end

  def adjacent_words(word)
    @dictionary.select do |entry|
      next unless entry.length == word.length
      correct = (0...entry.length).count do |idx|
        entry[idx] == word[idx]
      end
      correct + 1 == word.length
    end
  end

  def run(source, target)
    @current_words = Set.new([source])
    @all_seen_words = {source => nil}
    until @current_words.include?(target)
      @current_words = explore_current_words(target)
    end
    path = build_path(target)
    puts "path: #{render_path(path)}"
  end

  def render_path(path)
    path.reverse.compact.join(' -> ')
  end

  def explore_current_words(target)
    new_current_words = Set.new
    @current_words.each do |current|
      adjacent_words(current).each do |adjacent|
        next if @all_seen_words.include?(adjacent)
        new_current_words << adjacent
        @all_seen_words[adjacent] = current
        return new_current_words if adjacent == target
      end
    end
    new_current_words
  end

  def build_path(target)
    path = [target]
    until path.last.nil?
      path << @all_seen_words[path.last]
    end
    path
  end

end

chainer = WordChainer.new('dictionary.txt')
chainer.run('mom', 'dad')
