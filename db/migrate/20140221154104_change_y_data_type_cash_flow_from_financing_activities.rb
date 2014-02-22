class ChangeYDataTypeCashFlowFromFinancingActivities < ActiveRecord::Migration
  def change
    change_column :y_data, :cash_flow_from_financing_activities, :double
  end
end
