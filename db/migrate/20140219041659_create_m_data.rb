class CreateMData < ActiveRecord::Migration
  def change
    create_table :m_data do |t|
      t.column :company, "INT"
      t.column :month, "INT" 
      t.column :is_consolidated, "INT" 
      t.column :month_average_price, "FLOAT" 
      t.column :month_revenue, "FLOAT" 
      t.column :month_revenue_per_share, "FLOAT" 
      t.column :cash_dividend_yield, "FLOAT" 
      t.column :cash_dividend_yield_three_year, "FLOAT" 
      t.column :cash_dividend_yield_five_year, "FLOAT" 
      t.column :cash_dividend_yield_three_year_sixteen_multiples, "FLOAT" 
      t.column :cash_dividend_yield_three_year_twenty_multiples, "FLOAT" 
      t.column :cash_dividend_yield_three_year_thirty_two_multiples, "FLOAT" 
      t.column :cash_dividend_yield_five_year_sixteen_multiples, "FLOAT" 
      t.column :cash_dividend_yield_five_year_twenty_multiples, "FLOAT" 
      t.column :cash_dividend_yield_five_year_thirty_two_multiples, "FLOAT" 

    end
  end
end
