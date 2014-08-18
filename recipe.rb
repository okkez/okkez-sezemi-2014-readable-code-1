class Recipe
  attr_reader :id, :name, :uri, :user_id

  def initialize(id, name, uri, user_id)
    @id = id
    @name = name
    @uri = uri
    @user_id = user_id
  end

  def display
    puts "#{id}: #{name} #{uri}"
  end
end
