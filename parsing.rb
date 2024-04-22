# frozen_string_literal: false

require 'csv'
require 'roo'
require 'time'
require 'net/http'

# Parsing
class Parsing
  INFO_TYPE = { countres: ['OKSMList', 13],
                regions: ['OKATOList', 10],
                docs: ['Kod_documentaList', 0] }.freeze

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

  def xlsx_to_csv
    # code
  end

  def actual_okato
    url = 'https://classifikators.ru/assets/downloads/oksm/oksm.xlsx'
    uri = URI(url)

    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new uri

      http.request request do |response|
        open 'input/oksm.xlsx', 'w' do |io|
          response.read_body do |chunk|
            io.write chunk
          end
        end
      end
    end
  end

  def name_format(name, kind_of_info)
    # code
  end

  def parse_data(kind_of_info)
    timestamp = Time.now.strftime('%Y%m%d%H%M%S')
    CSV.open("output/#{kind_of_info}_#{timestamp}.csv", 'w', col_sep: ';') do |csv|
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
a.actual_okato
