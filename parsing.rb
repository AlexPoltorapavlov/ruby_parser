require 'csv'
require 'time'
require 'translit'

class Parsing

  INFO_TYPE = { countres: ["OKSMList", 13],
                regions: ["OKATOList", 10],
                docs: ["Kod_documentaList", 0]}.freeze

  def initialize(path: 'data.csv')
    @data = CSV.read(path, headers: true)
  end

  def data_read
    @data
  end

  def data_write(path)
    @data = CSV.read(path)
  end

  def run
    parse_data(:countres)
    parse_data(:regions)
    parse_data(:docs)
  end

  def name_format(name, kind_of_info)
    name_rus = name
    start = INFO_TYPE[kind_of_info][1]
    name_rus = name_rus.slice(start...-6)
    name_rus =  Translit.convert(name_rus, :russian) if name_rus
    name_rus = name_rus.gsub(/(?<=[^ ])([A-ZА-Я])/, ' \1').strip if name_rus
  end

  def parse_data(kind_of_info)
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    CSV.open("output/#{kind_of_info.to_s}_#{timestamp}.csv", "w", col_sep: ";") do |csv|

    @data.each do |row|
      if row['extended link role'].include?(INFO_TYPE[kind_of_info][0])
        name = name_format(row['name'], kind_of_info)
        csv << [row['label'], name, row['name']]
      end
    end
  end
end
end

a = Parsing.new
a.run
