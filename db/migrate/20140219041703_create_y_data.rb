class CreateYData < ActiveRecord::Migration
  def change
    create_table :y_data do |t|
      t.column :company, "INT"
      t.column :year, "INT" 
      t.column :is_consolidated, "INT" 
      t.column :revenue, "FLOAT" 
      t.column :gross_profit, "FLOAT" 
      t.column :operating_profit, "FLOAT" 
      t.column :net_profit, "FLOAT" 
      t.column :eps, "FLOAT" 
      t.column :current_assets, "FLOAT" 
      t.column :long_term_investments, "FLOAT" 
      t.column :fixed_assets, "FLOAT" 
      t.column :total_assets, "FLOAT" 
      t.column :current_liabilities, "FLOAT" 
      t.column :long_term_liabilities, "FLOAT" 
      t.column :total_liabilities, "FLOAT" 
      t.column :net_asset_value, "FLOAT" 
      t.column :share_capital, "FLOAT" 
      t.column :book_value_per_share, "FLOAT" 
      t.column :cash_flow_from_operating_activities, "FLOAT" 
      t.column :cash_flow_from_investing_activities, "FLOAT" 
      t.column :cash_flow_from_financing_activities, "FLOAT" 
      t.column :free_cash_flow, "FLOAT" 
      t.column :net_cash_flow, "FLOAT" 
      t.column :debt_cash_flow, "FLOAT" 
      t.column :ratio_of_liabilities_to_assets, "FLOAT" 
      t.column :quick_ratio, "FLOAT" 
      t.column :current_ratio, "FLOAT" 
      t.column :interest_protection_multiples, "FLOAT" 
      t.column :ratio_of_cash_from_operating_activities_to_current_liabilities, "FLOAT" 
      t.column :ratio_of_cash_from_operating_activities_to_liabilities, "FLOAT" 
      t.column :ratio_of_cash_from_operating_activities_to_net_profit, "FLOAT" 
      t.column :account_receivable_turnover, "FLOAT" 
      t.column :inventory_turnover, "FLOAT" 
      t.column :fixed_property_and_equipment, "FLOAT" 
      t.column :total_assets_turnover, "FLOAT" 
      t.column :gross_profit_margin, "FLOAT" 
      t.column :operating_profit_margin, "FLOAT" 
      t.column :net_profit_margin, "FLOAT" 
      t.column :roa, "FLOAT" 
      t.column :roe, "FLOAT" 
      t.column :cash_and_cash_equivalent, "FLOAT" 
      t.column :temporary_investment, "FLOAT" 
      t.column :account_and_notes_receivable, "FLOAT" 
      t.column :inventory, "FLOAT" 
      t.column :short_term_borrowing, "FLOAT" 
      t.column :short_term_notes_payable, "FLOAT" 
      t.column :accounts_and_notes_payable, "FLOAT" 
      t.column :accounts_recevied_in_advanve, "FLOAT" 
      t.column :long_term_liabilities_due_within_one_year, "FLOAT" 
      t.column :prepayments, "FLOAT" 
      t.column :short_term_financing_borrowing, "FLOAT" 
      t.column :long_and_short_term_financing_borrowing, "FLOAT" 
      t.column :ratio_of_short_term_borrowing_to_current_liabilities, "FLOAT" 
      t.column :ratio_of_long_and_short_term_borrowing_to_current_liabilities, "FLOAT" 
      t.column :ratio_of_cash_flow_from_operaing_activitie_to_revenue, "FLOAT" 
      t.column :ratio_of_accounts_receivable_and_inventory_to_total_assets, "FLOAT" 
      t.column :accounts_receivable_balance, "FLOAT" 
      t.column :inventory_balance, "FLOAT" 
      t.column :ratio_of_cash_and_short_term_investment_to_total_assets, "FLOAT" 
      t.column :operating_cash_inflow_per_share, "FLOAT" 
      t.column :investing_cash_outflow_per_share, "FLOAT" 
      t.column :financing_cash_inflow_per_share, "FLOAT" 
      t.column :free_cash_inflow_per_share, "FLOAT" 
      t.column :net_cash_inflow_per_share, "FLOAT" 
      t.column :days_payable_outstanding, "FLOAT" 
      t.column :pretax_income, "FLOAT" 
      t.column :pretax_income_ratio, "FLOAT" 
      t.column :ratio_of_dividend_to_free_cash, "FLOAT" 
      t.column :average_ratio_of_dividend_to_free_cash_due_within_five_years, "FLOAT" 

    end
  end
end