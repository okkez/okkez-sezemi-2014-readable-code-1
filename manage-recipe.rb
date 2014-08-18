#! /usr/bin/env ruby

require "optparse"
require "yaml"

def main
  recipe_id = nil
  recipe_files = nil
  user_id = nil
  parser = OptionParser.new
  parser.on("--recipe-id=ID", Integer, "Specify recipe ID") do |id|
    recipe_id = id
  end
  parser.on("--recipe-files=FILE1,FILE2,FILE3", Array, "Specify recipe data file") do |paths|
    recipe_files = paths
  end
  parser.on("--user-id=ID", Integer, "User ID") do |id|
    user_id = id
  end

  begin
    parser.parse!
  rescue OptionParser::ParseError
    $stderr.puts $!.message
    exit 1
  end

  data = {}
  users = []
  recipe_files.each do |recipe_file|
    hash = YAML.load_file(recipe_file)
    name = hash.keys.first
    recipes = hash.values.first
    users << name
    if data["#{users.size}:#{name}"]
      data["#{users.size}:#{name}"].update(recipes)
    else
      data["#{users.size}:#{name}"] = recipes
    end
  end

  case
  when recipe_id && user_id
    key = "#{user_id}:#{users[user_id - 1]}"
    recipes = data[key]
    puts key
    _name, _uri = recipes[recipe_id]
    puts "#{recipe_id}: #{_name} #{_uri}"
  when recipe_id
    user, recipes = data.detect do |user_name, _recipes|
      _recipes[recipe_id]
    end
    _name, _uri = recipes[recipe_id]
    puts user
    puts "#{recipe_id}: #{_name} #{_uri}"
  when user_id
    key = "#{user_id}:#{users[user_id - 1]}"
    recipes = data[key]
    puts key
    recipes.each do |id, (_name, _uri)|
      puts "#{id}: #{_name} #{_uri}"
    end
  else
    data.each do |user_name, _recipes|
      puts user_name
      _recipes.each do |id, (_name, _uri)|
        puts "#{id}: #{_name} #{_uri}"
      end
    end
  end
end

main
