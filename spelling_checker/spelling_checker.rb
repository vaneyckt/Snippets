# Spelling checker design by Peter Norvig: http://norvig.com/spell-correct.html
# Ruby code implementation by Brian Adkins: http://blog.lojic.com/2008/09/04/how-to-write-a-spelling-corrector-in-ruby/
# This is a refactor based on the design of Peter Norvig and the implementation of Brian Adkins
# Code @ https://github.com/vaneyckt/Snippets

def create_frequency_table
  text = File.read('big.txt')
  words = text.downcase.scan(/[a-z]+/)

  frequency_table = Hash.new(1)
  words.each { |word| frequency_table[word] += 1 }
  frequency_table
end

def find_known(words, frequency_table)
  known_words = []
  known_words = words.select { |word| frequency_table.has_key?(word) }
end

def find_edits_with_distance_1(word)
  n = word.length
  alphabet = 'abcdefghijklmnopqrstuvwxyz'

  edits_by_deletion = []
  edits_by_transposition = []
  edits_by_alteration = []
  edits_by_insertion = []

  (0...n).each   { |i| edits_by_deletion      << word[0...i] + word[i+1..-1] }
  (0...n-1).each { |i| edits_by_transposition << word[0...i] + word[i+1] + word[i] + word[i+2..-1] }

  n.times     { |i| alphabet.length.times { |l| edits_by_alteration << word[0...i] + alphabet[l] + word[i+1..-1] } }
  (n+1).times { |i| alphabet.length.times { |l| edits_by_insertion  << word[0...i] + alphabet[l] + word[i..-1] } }

  edits = edits_by_deletion + edits_by_transposition + edits_by_alteration + edits_by_insertion
end

def find_edits_with_distance_2(word)
  edits = []
  find_edits_with_distance_1(word).each do |e|
    edits += find_edits_with_distance_1(e)
  end
  edits
end

def find_correction(word, frequency_table)
  corrections = []
  corrections += find_known([word], frequency_table)                           if corrections.empty?
  corrections += find_known(find_edits_with_distance_1(word), frequency_table) if corrections.empty?
  corrections += find_known(find_edits_with_distance_2(word), frequency_table) if corrections.empty?
  suggested_correction = corrections.max_by { |correction| frequency_table[correction] }
end

input = ARGV[0]
frequency_table = create_frequency_table
correction = find_correction(input, frequency_table)
puts correction
