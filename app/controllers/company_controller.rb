class CompanyController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def refresh 
    Company.refresh
    render :json => {:status => "success"} 
  end

  def refresh_m_data 
    company = Company.where(:symbol => params[:company_symbol]).first
    company.refresh_m_data
    render :json => {:status => "success"} 
  end
  
  def refresh_m_data_all
    companies = Company.all
    companies.each do |company|
      company.refresh_m_data
    end
    render :json => {:status => "success"} 
  end

  def refresh_q_data 
    company = Company.where(:symbol => params[:company_symbol]).first
    company.refresh_q_data
    render :json => {:status => "success"} 
  end
  
  def refresh_q_data_all
    companies = Company.all
    companies.each do |company|
      company.refresh_q_data
    end
    render :json => {:status => "success"} 
  end

  def refresh_y_data 
    company = Company.where(:symbol => params[:company_symbol]).first
    company.refresh_y_data
    render :json => {:status => "success"} 
  end
  
  def refresh_y_data_all
    companies = Company.all
    companies.each do |company|
      company.refresh_y_data
    end
    render :json => {:status => "success"} 
  end

end
