# -*- coding: utf-8 -*-
require "csv"

class VehicleJourneyExport   
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :vehicle_journeys, :column_names, :route

  def initialize(attributes = {})    
    attributes.each { |name, value| send("#{name}=", value) }
  end
  
  def persisted?
    false
  end
  
  def to_csv(options = {})
    CSV.generate(options) do |csv|      
      vehicle_journey_at_stops_matrix = (vehicle_journeys.collect{ |vj| vj.vehicle_journey_at_stops.collect(&:departure_time).collect{|time| time.strftime("%H:%M")} }).transpose
      csv << column_names
      route.stop_points.each_with_index do |stop_point, index|
        csv << [stop_point.id, stop_point.stop_area.name] + vehicle_journey_at_stops_matrix[index]
      end
    end
  end

end
