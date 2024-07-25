require 'csv'

class CsvExport
  def initialize(records, headers, column_mappings)
    @records = records
    @headers = headers
    @column_mappings = column_mappings
  end

  def generate_csv
    CSV.generate(headers: true) do |csv|
      # Add headers
      csv << @headers

      # Add data
      @records.each do |record|
        csv << @column_mappings.map do |column|
          value = column[:method].call(record)
          format_value(value)
        end
      end
    end
  end

  private

  def format_value(value)
    if value.is_a?(Date) || value.is_a?(DateTime)
      value.strftime('%d %B, %Y')
    elsif value.respond_to?(:strftime)
      value.strftime('%d %B, %Y %H:%M:%S')
    else
      value
    end
  end
end
