module CsvExportable
  include CsvExportDefinitions
  extend ActiveSupport::Concern

  included do
    def handle_csv_export(records, headers, mappings, export_path, filename_prefix)
      if records.blank?
        flash[:alert] = "No #{filename_prefix.downcase.pluralize} available for export."
        redirect_to export_path and return
      end

      csv_data = CsvExport.new(records.to_a, headers, mappings).generate_csv
      if params[:date_range].present?
        send_data csv_data, filename: "#{filename_prefix}-#{Date.today}.csv"
      else
        handle_export_option(csv_data, export_path, filename_prefix)
      end
    end

    private

    def handle_export_option(csv_data, export_path, filename_prefix)
      case params[:export_option]&.first
      when 'download'
        send_data csv_data, filename: "#{filename_prefix}-#{Date.today}.csv"
      when 'email'
        EmployeeMailer.send_csv(current_employee, csv_data, filename_prefix).deliver_now
        flash[:notice] = "#{filename_prefix} list has been sent to your email."
        redirect_to export_path
      else
        flash[:alert] = 'No export option selected.'
        redirect_to export_path
      end
    end
  end
end
