#! /usr/bin/env ruby

require "optparse"
require "yaml"

def main
  recipe_id = nil
  recipe_file = nil
  parser = OptionParser.new
  parser.on("--id=ID", Integer, "Specify recipe ID") do |id|
    recipe_id = id
  end
  parser.on("--recipe-file=FILE", "Specify recipe data file") do |path|
    recipe_file = path
  end

  begin
    parser.parse!
  rescue OptionParser::ParseError
    $stderr.puts $!.message
    exit 1
  end

  recipes = YAML.load_file(recipe_file)
  if recipe_id
    name, uri = recipes[recipe_id]
    puts "#{recipe_id}: #{name} #{uri}"
  else
    recipes.each do |id, (_name, _uri)|
      puts "#{id}: #{_name} #{_uri}"
    end
  end
end

main
