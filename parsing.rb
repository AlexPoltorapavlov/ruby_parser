require 'csv'

class Parsing

  def initialize(path: 'data.csv')
    @data = CSV.read(path)
  end

  def data_read
    @data
  end

  def data_write(path)
    @data = CSV.read(path)
  end

  def load_file

  end
end

a = Parsing.new
p a.data
