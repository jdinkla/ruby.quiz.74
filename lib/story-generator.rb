# (c) 2006 Joern Dinkla, www.dinkla.com
#

require 'markov-chain'

# A generator for stories. Fill the Markov chain with the methods add()
# or add_file() and generate a story with the method story().
#
class StoryGenerator

  attr_reader :mc
  
  # Initializes.
  #
  def initialize(mc = nil) 
    if mc.nil?
      @mc = MarkovChain.new()
    else
      @mc = mc 
    end
  end

  # Adds the words to the MarkovChain
  #
  def add(words) 
    @mc.add_elems(words)
  end

  # Adds a file to the MarkovChain.
  #
  def add_file(file) 
    puts "Reading file #{file}" if ( $VERBOSE )
    words = Words.parse_file(file)
    if ( $VERBOSE )
      puts "Read in #{words.length} words."
      puts "Inserting file #{file}"
      STDOUT.flush()
    end
    @mc.add_elems(words)
  end
  
  # Genereates a story with n words (".", "," etc. counting as a word) 
  #
  def story(n)
    elems = generate(n, ".")
    format(elems)
  end
  
  # Generates a story from the Markov Chain mc of length n and which starts with a
  # successor of word.
  #
  def generate(n, word)
    lexicon = @mc.nodes()
    word = lexicon[rand(lexicon.length)] if word.nil?
    elems = []
    
    1.upto(n) do |i|
      word = @mc.rand(word)
      # if no word is word, take a random one from the lexicon
      if word.nil?
        elems += ["."]
        word = lexicon[rand(lexicon.length)]
      end
      elems << word
      if ( i % LOG_WORDS_NUM == 0 && $VERBOSE )
        puts "Generated #{i} words." 
        STDOUT.flush()
      end
    end
    elems
  end
  
  # Formats the elements.
  #
  def format(elems)
    text = elems.join(" ")
    text.gsub!(/\ [.,!?;]\ /, '\1 ')
    text
  end

end
