#! /usr/bin/env ruby

require "optparse"
require "yaml"

$LOAD_PATH.unshift(".")

require "recipe"
require "user"

def main
  recipe_files = nil
  parser = OptionParser.new
  parser.on("--recipe-files=FILE1,FILE2,FILE3", Array, "Specify recipe data file") do |paths|
    recipe_files = paths
  end

  begin
    parser.parse!
  rescue OptionParser::ParseError
    $stderr.puts $!.message
    exit 1
  end

  users = []
  recipes = []
  recipe_files.each do |recipe_file|
    hash = YAML.load_file(recipe_file)
    user_name = hash.keys.first
    user_recipes = hash.values.first
    user = User.new(user_name)
    users << user
    user_recipes.each do |id, (name, uri)|
      recipes << Recipe.new(id, name, uri, user.id)
    end
  end

  recipes.each do |recipe|
    user = users.detect do |_user|
      _user.id == recipe.user_id
    end
    puts [user.id, user.name, recipe.id, recipe.name, recipe.uri].join(",")
  end
end

main
