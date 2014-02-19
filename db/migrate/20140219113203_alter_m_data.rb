class AlterMData < ActiveRecord::Migration
  def change
    rename_column :m_data, :company, :company_id
    rename_column :q_data, :company, :company_id
    rename_column :y_data, :company, :company_id
  end
end
