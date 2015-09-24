module PagesHelper

  # get_url
  #
  # takes in a string query to determine the search
  # returns formated and complete url string
  def get_url(query)
    url     = "http://api-impac-uat.maestrano.io/api/v1/get_widget?"
    meta    = "&metadata[organization_ids][]=org-fbte"
    search  = ""
    meta2   = ""

    if query == "employees"
      search = "engine=hr/employee_details"
    else
      search = "engine=invoices/list"
      meta2  = "&metadata[entity]="
    end

    return "#{url}#{search}#{meta}#{meta2}"
  end

  # get_data
  #
  # string passed in is a complete url
  # HTTParty uses string to query url
  # returns response from HTTParty
  def get_data(str)
    user  = "72db99d0-05dc-0133-cefe-22000a93862b"
    pass  = "_cIOpimIoDi3RIviWteOTA"
    auth  = {username: user, password: pass}

    data = HTTParty.get(str, basic_auth: auth)

  end

  # get_employees
  #
  # takes in a hash in the format of 
  # {"content" => {"employees" => [{"address" => "20 ninth street, NSW Sydney, Australia"}]}}
  # extrats the country adds it into a new hash which keeps track
  # of the occurance of the country
  # 
  # eg. {"AU" => 2, "US" => 5}
  def get_employees(data)
    employees = {}

    data["content"]["employees"].each do |worker|
      str = worker["address"]
      str = str.split(",").last.lstrip

      #adds the country name as key in hash if doesnt exist
      #adds +1 to the value for country
      employees[str] = 0 unless employees[str]
      employees[str] += 1
    end

    return employees
  end

  # get_invoices
  # takes in a url string
  #
  # gets hash for customers
  # gets hash for suppliers
  # returns array with the two hashes
  # [ {obj}, {obj} ]
  def get_invoices(data)
    inv_array = []
    customer  = get_data( data + 'customers' )
    suppliers = get_data( data + 'suppliers' )

    return inv_array << customer << suppliers
  end


  # get_invoice_data
  #
  # takes in an array of objects
  # [{"content"=>{"entities"=>[{"address"=> {"c"=>"AU", "l"=>"NSW"}, "total_invoiced" => 2000}]}},
  #  {"content"=>{"entities"=>[{"address"=> {"c"=>"US", "l"=>"FL"}, "total_invoiced"=>5000}]}}]
  #
  # gets country adds it as key in hash then updates amount value
  # returns hash with country and amount
  # eg {"Australia"=> 2000, "United States"=> 5000}
  def get_invoice_data(inv_array)
    sale_data = {}

    inv_array.each do |invoice|
      invoice["content"]["entities"].each do |sale|
        country = get_sale_country(sale["address"])

        #only assign country and amount if country exists
        unless country.empty?
          sale_data[country] = 0 unless sale_data[country]
          sale_data[country] += sale["total_invoiced"] 
        end
      end
    end

    return sale_data
  end

  # get_sale_detail
  #
  # checks if any attributes for address exists
  # then gets geocode 
  def get_sale_country(address)
    country = ""

    if address["c"] != "-"
      country = address["c"]
    elsif address["r"] != "-"
      #if address["r"] contains only numbers do not want
      country = get_country(address["r"]) unless address["r"] =~ /\d+$/
    elsif address["l"] != "-"
      country = get_country(address["l"])
    end

    return country
  end

  # get_country
  #
  # takes in a string that is part of an address
  # checks string against db if no results
  # geocode tries to figure out country
  # eg str = "NSW"
  #
  # returns country
  # eg "Australia"
  def get_country(str)
    data = check_local_db(str)

    if data.nil? 
      data = Geocoder.search(str)

      #has to parse through geocode data to find correct result
      data.first.address_components.each do |obj|
        data = obj["short_name"] if obj["types"][0] == "country"
      end

      save_to_db(str, data)
    end

    return data
  end

  # check_local_db
  #
  # Database created because geocoder is slow
  # check local database for a match of the string
  # if it finds result it returns country otherwise nil
  def check_local_db(str)
    result = Country.find_by(query: str.upcase)

    return result = result ? result.country_name : nil
  end

  # save_to_db
  #
  # saves a country with passed in parameters
  # str = string eg. "NSW"
  # data = string eg. "AU"
  def save_to_db(str, data)
    Country.create(query: str.upcase, country_name: data)
  end

  # convert_hash_to_array
  # hash = eg. {"US" => 20, "AU" => 3}
  # type = eg. "employees"
  #
  # takes in a hash converts it to array and appends
  # another array to the front of array
  # format is used by geo maps
  #
  # return eg. [ ["Country", "Count"], ["US", 20], ["AU", 3] ]
  def convert_hash_to_array(hash, type)
    type = type == "employees" ? "Count" : "Amount"
    hash.to_a.unshift(["Country", type])
  end

end
