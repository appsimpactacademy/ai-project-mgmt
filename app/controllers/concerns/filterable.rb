# app/controllers/concerns/filterable.rb
module Filterable
  extend ActiveSupport::Concern

  included do
    before_action :set_filters, only: :index
  end

  private

  def set_filters
    @date_range = params.dig(:q, :date_range) || ""
  end

  def filter_by_date_range(resources)
    if @date_range.present?
      start_date, end_date = @date_range.split(' to ').map(&:to_date)
      resources.created_between(start_date, end_date)
    else
      resources
    end
  end
end
