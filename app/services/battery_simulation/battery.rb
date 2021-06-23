class BatterySimulation
  class Battery
    attr_accessor :current_charge
    attr_reader :capacity, :charge_power_limit, :discharge_power_limit, :charge_efficiency

    def initialize(capacity, charge_power_limit, discharge_power_limit, charge_efficiency)
      @capacity = capacity
      @charge_power_limit = charge_power_limit
      @discharge_power_limit = discharge_power_limit
      @charge_efficiency = charge_efficiency
      @current_charge = 0
    end

    def charge(energy, duration:)
      return 0 if energy.zero?

      input_power = energy * power_factor(duration)
      ratio = [charge_power_limit, input_power].min / input_power
      energy *= ratio

      acceptable_energy = capacity - current_charge
      available_energy = energy * charge_efficiency
      charged_energy = [available_energy, acceptable_energy].min
      self.current_charge += charged_energy
      [charged_energy, charged_energy / charge_efficiency]
    end

    def discharge(energy, duration:)
      return 0 if energy.zero?

      output_power = energy * power_factor(duration)
      ratio = [charge_power_limit, output_power].min / output_power
      energy *= ratio

      energy = [energy, current_charge].min
      self.current_charge -= energy
      energy
    end

    private

    def power_factor(duration)
      1.0.hour / duration
    end
  end
end
