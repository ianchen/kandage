class CompanyController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def refresh 
    Company.refresh
    render :json => {:status => "success"} 
  end

end
