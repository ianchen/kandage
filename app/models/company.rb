class Company < ActiveRecord::Base
  
  include HTTMultiParty

  def self.refresh
    parse_html_to_db(Nokogiri::HTML(sii_companies_html))
    parse_html_to_db(Nokogiri::HTML(otc_companies_html))
  end

  def refresh_m_data
    save_data(JSON.parse(get_raw_data(1)), 1)
    save_data(JSON.parse(get_raw_data(0)), 0)
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

  def save_data(raw_data, consolidated)
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

end
