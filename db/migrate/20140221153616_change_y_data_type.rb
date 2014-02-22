class ChangeYDataType < ActiveRecord::Migration
  def change
    change_column :y_data, :cash_flow_from_investing_activities, :double
  end
end
