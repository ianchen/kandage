class Company < ActiveRecord::Base
  
  include HTTMultiParty

  def self.refresh
    parse_html_to_db(Nokogiri::HTML(sii_companies_html))
    parse_html_to_db(Nokogiri::HTML(otc_companies_html))
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


end
