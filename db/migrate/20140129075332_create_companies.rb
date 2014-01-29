class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.column :symbol, "INT"
      t.column :name, "VARCHAR(64) NOT NULL" 
    end
  end
end
