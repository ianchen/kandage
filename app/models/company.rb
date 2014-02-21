class Company < ActiveRecord::Base
  
  has_many :m_datas
  has_many :q_datas
  has_many :y_datas

  include HTTMultiParty

  def self.refresh
    parse_html_to_db(Nokogiri::HTML(sii_companies_html))
    parse_html_to_db(Nokogiri::HTML(otc_companies_html))
  end

  def refresh_m_data
    raw_data_consolidated = JSON.parse(get_raw_data(1))
    raw_data_unconsolidated = JSON.parse(get_raw_data(0))
   
    if raw_data_consolidated.size > 1
      save_m_data(raw_data_consolidated, 1)
    end 
    if raw_data_unconsolidated.size > 1
      save_m_data(raw_data_unconsolidated, 0)
    end 
  end

  def refresh_q_data
    raw_data_consolidated = JSON.parse(get_raw_data(1))
    raw_data_unconsolidated = JSON.parse(get_raw_data(0))
   
    if raw_data_consolidated.size > 1
      save_q_data(raw_data_consolidated, 1)
    end 
    if raw_data_unconsolidated.size > 1
      save_q_data(raw_data_unconsolidated, 0)
    end 
  end

  def refresh_y_data
    raw_data_consolidated = JSON.parse(get_raw_data(1))
    raw_data_unconsolidated = JSON.parse(get_raw_data(0))
   
    if raw_data_consolidated.size > 1
      save_y_data(raw_data_consolidated, 1)
    end 
    if raw_data_unconsolidated.size > 1
      save_y_data(raw_data_unconsolidated, 0)
    end 
  end


  private

  def self.parse_html_to_db(doc)
    doc.css("tr").each do |tr|
      next if tr.attr("class") != "odd" and tr.attr("class") != "even"

      tds = tr.css('td')
      symbol = tds[0].text[1..-1]
      name = tds[1].text
      company = where(:symbol => symbol).first

      if company.nil? 
        create(:symbol => symbol, :name => name)
      else
        company.symbol = symbol
        company.name = name
        company.save
      end
    end
  end

  def self.sii_companies_html
    result = self.post("http://mops.twse.com.tw/mops/web/ajax_t51sb01", :query => { 
      :encodeURIComponent => 1,
      :step => 1,
      :firstin => 1,
      :TYPEK => "sii"
    })

    result.body

  end

  def self.otc_companies_html
    result = self.post("http://mops.twse.com.tw/mops/web/ajax_t51sb01", :query => { 
      :encodeURIComponent => 1,
      :step => 1,
      :firstin => 1,
      :TYPEK => "otc"
    })

    result.body

  end

  def get_raw_data(consolidated) 
    time = Time.new
    result = Company.get(
      "http://statementdog.com/analysis/analysis_ajax/#{symbol}/2003/1/#{time.year}/#{time.month}/#{consolidated}", 
      :headers => { "X-Requested-With" => "XMLHttpRequest" })
    result.body
  end

  def save_m_data(raw_data, consolidated)
    raw_data[2]["data"].each do |m|
      m_data = MData.where(
        :company_id => id,
        :month => m[1], 
        :is_consolidated => consolidated
      ).first
      if m_data.nil?
        m_data = MData.new(
          :company => self,
          :month => m[1],
          :is_consolidated => consolidated,
          :month_average_price => raw_data[11]["data"][m[0]][1],
          :month_revenue => raw_data[12]["data"][m[0]][1],
          :month_revenue_per_share => raw_data[13]["data"][m[0]][1],
          :cash_dividend_yield => raw_data[16]["data"][m[0]][1],
          :cash_dividend_yield_three_year => raw_data[41]["data"][m[0]][1],
          :cash_dividend_yield_five_year => raw_data[42]["data"][m[0]][1],
          :cash_dividend_yield_three_year_sixteen_multiples => raw_data[43]["data"][m[0]][1],
          :cash_dividend_yield_three_year_twenty_multiples => raw_data[44]["data"][m[0]][1],
          :cash_dividend_yield_three_year_thirty_two_multiples => raw_data[45]["data"][m[0]][1],
          :cash_dividend_yield_five_year_sixteen_multiples => raw_data[46]["data"][m[0]][1],
          :cash_dividend_yield_five_year_twenty_multiples => raw_data[47]["data"][m[0]][1],
          :cash_dividend_yield_five_year_thirty_two_multiples => raw_data[48]["data"][m[0]][1]
        )
        m_data.save
      end
    end
  end

  def save_q_data(raw_data, consolidated)
    raw_data[3]["data"].each do |q|
      q_data = QData.where(
        :company_id => id,
        :quarter => q[1], 
        :is_consolidated => consolidated
      ).first
      if q_data.nil?
        q_data = QData.new(
          :company => self,
          :quarter => q[1],
          :is_consolidated => consolidated,
          :revenue => raw_data[61]["data"][q[0]][1], 
          :gross_profit => raw_data[62]["data"][q[0]][1], 
          :operating_profit => raw_data[63]["data"][q[0]][1], 
          :net_profit => raw_data[64]["data"][q[0]][1], 
          :eps => raw_data[65]["data"][q[0]][1], 
          :eps_four_quarter => raw_data[66]["data"][q[0]][1], 
          :average_eps_four_quarter => raw_data[67]["data"][q[0]][1], 
          :current_assets => raw_data[68]["data"][q[0]][1], 
          :long_term_investments => raw_data[69]["data"][q[0]][1], 
          :fixed_assets => raw_data[70]["data"][q[0]][1], 
          :total_assets => raw_data[71]["data"][q[0]][1], 
          :current_liabilities => raw_data[72]["data"][q[0]][1], 
          :long_term_liabilities => raw_data[73]["data"][q[0]][1], 
          :total_liabilities => raw_data[74]["data"][q[0]][1], 
          :net_asset_value => raw_data[75]["data"][q[0]][1], 
          :share_capital => raw_data[76]["data"][q[0]][1], 
          :book_value_per_share => raw_data[77]["data"][q[0]][1], 
          :cash_flow_from_operating_activities => raw_data[78]["data"][q[0]][1], 
          :cash_flow_from_investing_activities => raw_data[79]["data"][q[0]][1], 
          :cash_flow_from_financing_activities => raw_data[80]["data"][q[0]][1], 
          :free_cash_flow => raw_data[81]["data"][q[0]][1], 
          :net_cash_flow => raw_data[82]["data"][q[0]][1], 
          :debt_cash_flow => raw_data[83]["data"][q[0]][1], 
          :ratio_of_liabilities_to_assets => raw_data[84]["data"][q[0]][1], 
          :quick_ratio => raw_data[85]["data"][q[0]][1], 
          :current_ratio => raw_data[86]["data"][q[0]][1], 
          :interest_protection_multiples => raw_data[87]["data"][q[0]][1], 
          :ratio_of_cash_from_operating_activities_to_current_liabilities => raw_data[88]["data"][q[0]][1], 
          :ratio_of_cash_from_operating_activities_to_liabilities => raw_data[89]["data"][q[0]][1], 
          :ratio_of_cash_from_operating_activities_to_net_profit => raw_data[90]["data"][q[0]][1], 
          :account_receivable_turnover => raw_data[91]["data"][q[0]][1], 
          :inventory_turnover => raw_data[92]["data"][q[0]][1], 
          :fixed_property_and_equipment => raw_data[93]["data"][q[0]][1], 
          :total_assets_turnover => raw_data[94]["data"][q[0]][1], 
          :gross_profit_margin => raw_data[95]["data"][q[0]][1], 
          :operating_profit_margin => raw_data[96]["data"][q[0]][1], 
          :net_profit_margin => raw_data[97]["data"][q[0]][1], 
          :roa => raw_data[98]["data"][q[0]][1], 
          :roe => raw_data[99]["data"][q[0]][1], 
          :roa_four_quarter => raw_data[100]["data"][q[0]][1], 
          :roe_four_quarter => raw_data[101]["data"][q[0]][1], 
          :reinvestment_rate => raw_data[102]["data"][q[0]][1], 
          :cash_and_cash_equivalent => raw_data[135]["data"][q[0]][1], 
          :temporary_investment => raw_data[136]["data"][q[0]][1], 
          :account_and_notes_receivable => raw_data[137]["data"][q[0]][1], 
          :inventory => raw_data[138]["data"][q[0]][1], 
          :short_term_borrowing => raw_data[139]["data"][q[0]][1], 
          :short_term_notes_payable => raw_data[140]["data"][q[0]][1], 
          :accounts_and_notes_payable => raw_data[141]["data"][q[0]][1], 
          :accounts_recevied_in_advanve => raw_data[142]["data"][q[0]][1], 
          :long_term_liabilities_due_within_one_year => raw_data[143]["data"][q[0]][1], 
          :prepayments => raw_data[144]["data"][q[0]][1], 
          :short_term_financing_borrowing => raw_data[145]["data"][q[0]][1], 
          :long_and_short_term_financing_borrowing => raw_data[146]["data"][q[0]][1], 
          :ratio_of_short_term_borrowing_to_current_liabilities => raw_data[147]["data"][q[0]][1], 
          :ratio_of_long_and_short_term_borrowing_to_current_liabilities => raw_data[148]["data"][q[0]][1], 
          :ratio_of_cash_flow_from_operaing_activitie_to_revenue => raw_data[149]["data"][q[0]][1], 
          :ratio_of_accounts_receivable_and_inventory_to_total_assets => raw_data[150]["data"][q[0]][1], 
          :accounts_receivable_balance => raw_data[151]["data"][q[0]][1], 
          :inventory_balance => raw_data[152]["data"][q[0]][1], 
          :ratio_of_cash_and_short_term_investment_to_total_assets => raw_data[153]["data"][q[0]][1], 
          :operating_cash_inflow_per_share => raw_data[154]["data"][q[0]][1], 
          :investing_cash_outflow_per_share => raw_data[155]["data"][q[0]][1], 
          :financing_cash_inflow_per_share => raw_data[156]["data"][q[0]][1], 
          :free_cash_inflow_per_share => raw_data[157]["data"][q[0]][1], 
          :net_cash_inflow_per_share => raw_data[158]["data"][q[0]][1], 
          :days_payable_outstanding => raw_data[159]["data"][q[0]][1], 
          :pretax_income => raw_data[160]["data"][q[0]][1], 
          :pretax_income_ratio => raw_data[161]["data"][q[0]][1] 
        )
        q_data.save
      end
    end
  end

  def save_y_data(raw_data, consolidated)
    raw_data[4]["data"].each do |y|
      y_data = YData.where(
        :company_id => id,
        :year => y[1], 
        :is_consolidated => consolidated
      ).first
      if y_data.nil?
        y_data = YData.new(
          :company => self,
          :year => y[1],
          :is_consolidated => consolidated,
          :revenue => raw_data[181]["data"][y[0]][1], 
          :gross_profit => raw_data[182]["data"][y[0]][1], 
          :operating_profit => raw_data[183]["data"][y[0]][1], 
          :net_profit => raw_data[184]["data"][y[0]][1], 
          :eps => raw_data[185]["data"][y[0]][1], 
          :current_assets => raw_data[186]["data"][y[0]][1], 
          :long_term_investments => raw_data[187]["data"][y[0]][1], 
          :fixed_assets => raw_data[188]["data"][y[0]][1], 
          :total_assets => raw_data[189]["data"][y[0]][1], 
          :current_liabilities => raw_data[190]["data"][y[0]][1], 
          :long_term_liabilities => raw_data[191]["data"][y[0]][1], 
          :total_liabilities => raw_data[192]["data"][y[0]][1], 
          :net_asset_value => raw_data[193]["data"][y[0]][1], 
          :share_capital => raw_data[194]["data"][y[0]][1], 
          :book_value_per_share => raw_data[195]["data"][y[0]][1], 
          :cash_flow_from_operating_activities => raw_data[196]["data"][y[0]][1], 
          :cash_flow_from_investing_activities => raw_data[197]["data"][y[0]][1], 
          :cash_flow_from_financing_activities => raw_data[198]["data"][y[0]][1], 
          :free_cash_flow => raw_data[199]["data"][y[0]][1], 
          :net_cash_flow => raw_data[200]["data"][y[0]][1], 
          :debt_cash_flow => raw_data[201]["data"][y[0]][1], 
          :ratio_of_liabilities_to_assets => raw_data[202]["data"][y[0]][1], 
          :quick_ratio => raw_data[203]["data"][y[0]][1], 
          :current_ratio => raw_data[204]["data"][y[0]][1], 
          :interest_protection_multiples => raw_data[205]["data"][y[0]][1], 
          :ratio_of_cash_from_operating_activities_to_current_liabilities => raw_data[206]["data"][y[0]][1], 
          :ratio_of_cash_from_operating_activities_to_liabilities => raw_data[207]["data"][y[0]][1], 
          :ratio_of_cash_from_operating_activities_to_net_profit => raw_data[208]["data"][y[0]][1], 
          :account_receivable_turnover => raw_data[209]["data"][y[0]][1], 
          :inventory_turnover => raw_data[210]["data"][y[0]][1], 
          :fixed_property_and_equipment => raw_data[211]["data"][y[0]][1], 
          :total_assets_turnover => raw_data[212]["data"][y[0]][1], 
          :gross_profit_margin => raw_data[213]["data"][y[0]][1], 
          :operating_profit_margin => raw_data[214]["data"][y[0]][1], 
          :net_profit_margin => raw_data[215]["data"][y[0]][1], 
          :roa => raw_data[216]["data"][y[0]][1], 
          :roe => raw_data[217]["data"][y[0]][1], 
          :cash_and_cash_equivalent => raw_data[225]["data"][y[0]][1], 
          :temporary_investment => raw_data[226]["data"][y[0]][1], 
          :account_and_notes_receivable => raw_data[227]["data"][y[0]][1], 
          :inventory => raw_data[228]["data"][y[0]][1], 
          :short_term_borrowing => raw_data[229]["data"][y[0]][1], 
          :short_term_notes_payable => raw_data[230]["data"][y[0]][1], 
          :accounts_and_notes_payable => raw_data[231]["data"][y[0]][1], 
          :accounts_recevied_in_advanve => raw_data[232]["data"][y[0]][1], 
          :long_term_liabilities_due_within_one_year => raw_data[233]["data"][y[0]][1], 
          :prepayments => raw_data[234]["data"][y[0]][1], 
          :short_term_financing_borrowing => raw_data[235]["data"][y[0]][1], 
          :long_and_short_term_financing_borrowing => raw_data[236]["data"][y[0]][1], 
          :ratio_of_short_term_borrowing_to_current_liabilities => raw_data[237]["data"][y[0]][1], 
          :ratio_of_long_and_short_term_borrowing_to_current_liabilities => raw_data[238]["data"][y[0]][1], 
          :ratio_of_cash_flow_from_operaing_activitie_to_revenue => raw_data[239]["data"][y[0]][1], 
          :ratio_of_accounts_receivable_and_inventory_to_total_assets => raw_data[240]["data"][y[0]][1], 
          :accounts_receivable_balance => raw_data[241]["data"][y[0]][1], 
          :inventory_balance => raw_data[242]["data"][y[0]][1], 
          :ratio_of_cash_and_short_term_investment_to_total_assets => raw_data[243]["data"][y[0]][1], 
          :operating_cash_inflow_per_share => raw_data[244]["data"][y[0]][1], 
          :investing_cash_outflow_per_share => raw_data[245]["data"][y[0]][1], 
          :financing_cash_inflow_per_share => raw_data[246]["data"][y[0]][1], 
          :free_cash_inflow_per_share => raw_data[247]["data"][y[0]][1], 
          :net_cash_inflow_per_share => raw_data[248]["data"][y[0]][1], 
          :days_payable_outstanding => raw_data[249]["data"][y[0]][1], 
          :pretax_income => raw_data[250]["data"][y[0]][1], 
          :pretax_income_ratio => raw_data[251]["data"][y[0]][1], 
          :ratio_of_dividend_to_free_cash => raw_data[252]["data"][y[0]][1], 
          :average_ratio_of_dividend_to_free_cash_due_within_five_years => raw_data[253]["data"][y[0]][1], 


        )
        y_data.save
      end
    end
  end


end
