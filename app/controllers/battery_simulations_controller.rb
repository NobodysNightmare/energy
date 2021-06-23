class BatterySimulationsController < ApplicationController
  def new
  end

  def create
    collector = BatterySimulation::RollupCollector.new
    simulation.simulate do |**options|
      collector.update(**options)
    end

    @result = collector.result
  end

  private

  def simulation
    BatterySimulation.new(battery, site, start_date..end_date, step_size)
  end

  def battery
    BatterySimulation::Battery.new(
      simulation_params.fetch(:battery_capacity).to_i,
      simulation_params.fetch(:battery_charge_power).to_i,
      simulation_params.fetch(:battery_discharge_power).to_i,
      simulation_params.fetch(:battery_charge_efficiency).to_i / 100.0
    )
  end

  def site
    Site.find(simulation_params.fetch(:site_id))
  end

  def start_date
    Date.iso8601(simulation_params.fetch(:start))
  end

  def end_date
    Date.iso8601(simulation_params.fetch(:end))
  end

  def step_size
    simulation_params.fetch(:step_size).to_i.minutes
  end

  def simulation_params
    params.require(:simulation)
          .permit(:site_id, :start, :end, :step_size, :battery_capacity,
                  :battery_charge_power, :battery_discharge_power, :battery_charge_efficiency)
  end
end
