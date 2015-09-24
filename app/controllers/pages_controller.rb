class PagesController < ApplicationController
  include PagesHelper

  def home

  end

  def api
    data = get_url(params['query'])

    if params['query'] == 'employees'
      data = get_employees( get_data(data) )
    else
      data = get_invoice_data( get_invoices(data) )
    end

    data = convert_hash_to_array(data, params['query'])

    render json: data
  end

end
