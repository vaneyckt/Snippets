require 'nokogiri'
require 'css_parser'

css_docs_dir = '/home/tom/Desktop/UnusedCSS/css_docs'
html_docs_dir = '/home/tom/Desktop/UnusedCSS/html_docs'

html_docs = []
Dir.new(html_docs_dir).each do |file_name|
  if !['.', '..'].include?(file_name)
    File.open("#{html_docs_dir}/#{file_name}", 'r') { |f| html_docs << Nokogiri::HTML(f) }
  end
end

Dir.new(css_docs_dir).each do |file_name|
  if !['.', '..'].include?(file_name)
    # load rules of current css file
    parser = CssParser::Parser.new
    parser.load_file!(file_name, css_docs_dir)

    # see if rule is used in any html doc
    parser.each_selector do |selector, rule|
      css_rule_is_unused = true

      html_docs.each do |html_doc|
        # nokogiri can't handle ':' charactes in a css rule and will throw an exception
        # the rescue statement is here to prevent this exception from crashing the program
        begin
          css_rule_is_unused = css_rule_is_unused && html_doc.search(selector).empty?
        rescue
        end
      end

      if css_rule_is_unused
        puts "unused rule in #{file_name}: #{selector} - #{rule}"
      end
    end
  end
end
