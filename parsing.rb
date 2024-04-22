require 'csv'
require 'time'

class Parsing

  def initialize(path: 'data.csv')
    @data = CSV.read(path, headers: true)
  end

  def data_read
    @data
  end

  def data_write(path)
    @data = CSV.read(path)
  end

  def parse_countres
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    CSV.open("countres_#{timestamp}.csv", "w") do |csv|

    @data.each do |row|
      if row['extended link role'].include?('OKSMList')
        csv << [row['label'], row['defenition'], row['name']]
      end
    end
  end
end
end

a = Parsing.new
a.parse_countres
