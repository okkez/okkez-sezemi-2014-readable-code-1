class User
  attr_reader :id, :name

  @@id = 0

  def initialize(name)
    @@id += 1
    @id = @@id
    @name = name
  end

  def display
    puts "#{@id}: #{@name}"
  end
end
