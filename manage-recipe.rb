#! /usr/bin/env ruby

require "optparse"
require "yaml"

$LOAD_PATH.unshift(".")

require "recipe"
require "user"

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

  case
  when recipe_id && user_id
    recipe = recipes.detect do |_recipe|
      _recipe.id == recipe_id && _recipe.user_id == user_id
    end
    user = users.detect do |_user|
      _user.id == user_id
    end
    user.display
    recipe.display
  when recipe_id
    recipe = recipes.detect do |_recipe|
      _recipe.id == recipe_id
    end
    user = users.detect do |_user|
      _user.id == recipe.user_id
    end
    user.display
    recipe.display
  when user_id
    recipes = recipes.select do |_recipe|
      _recipe.user_id == user_id
    end
    user = users.detect do |_user|
      _user.id == user_id
    end
    user.display
    recipes.each(&:display)
  else
    recipes.group_by(&:user_id).each do |_user_id, _recipes|
      user = users.detect do |_user|
        _user.id == _user_id
      end
      user.display
      _recipes.each(&:display)
    end
  end
end

main
