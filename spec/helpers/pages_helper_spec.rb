require 'rails_helper'

def get_user
  email = 'test@site.com'
  pass  = 'password'
  org   = 'org-fbte'
  api_u = '72db99d0-05dc-0133-cefe-22000a93862b'
  api_p = '_cIOpimIoDi3RIviWteOTA'

  user = User.create(email: email, 
                     password: pass, 
                     organization: org, 
                     api_user: api_u,
                     api_pass: api_p 
                    )
end

RSpec.describe PagesHelper, type: :helper do

  describe '#get_url' do 

    before { controller.instance_variable_set(:@current_user, get_user) }

    it 'takes a string returns a string' do
      result = "http://api-impac-uat.maestrano.io/api/v1/get_widget?engine=hr/employee_details&metadata[organization_ids][]=org-fbte"
      

      string = helper.get_url('employees')
      expect(string).to eq(result)
    end

    it 'returns correct string' do 
      result = "http://api-impac-uat.maestrano.io/api/v1/get_widget?engine=invoices/list&metadata[organization_ids][]=org-fbte&metadata[entity]="

      string = helper.get_url('invoices')
      expect(string).to eq(result)

    end
  end

  describe '#get_country' do

    Geocoder.configure(:lookup => :test)

    Geocoder::Lookup::Test.add_stub(
      "vic", [
        {
          'address_components' => [{'short_name'=> 'AU',
                                    'types'=>['country']}
                                  ]
        }
      ]
    )

    Geocoder::Lookup::Test.add_stub(
      "MVL", [
        {
          'address_components' => [{'short_name'=> 'US',
                                    'types'=>['country']}
                                  ]
        }
      ]
    )

    Geocoder::Lookup::Test.add_stub(
      "nsw", [
        {
          'address_components' => [{'short_name'=> 'AU',
                                    'types'=>['country']}
                                  ]
        }
      ]
    )

    it 'takes a string and returns country' do
      expect(helper.get_country("vic")).to eq("AU")
    end

    it 'returns correct country from US state' do 
      expect(helper.get_country("MVL")).to eq("US")
    end

    it 'saves country after searching geocoder' do
      helper.get_country("nsw")
      expect(Country.find_by(query: "NSW")).to_not eq(nil)
    end
  end

  describe '#get_sale_country' do 
    it 'takes in a hash returns country' do 
      obj = {"s"=>"12 Lang Road", "s2"=>"-", "l"=>"Sydney", "r"=>"NSW", "z"=>"2000", "c"=>"AU"}
      expect(helper.get_sale_country(obj)).to eq("AU")
    end
  end

  describe '#get_invoice_data' do
    arr = []
    arr <<{"content" => {"entities" => [{"address" => {"c"=>"AU", "l"=>"NSW"}, "total_invoiced" => 2000}]}}
    arr <<{"content" => {"entities" => [{"address" => {"c"=>"US", "l"=>"FL"}, "total_invoiced" => 5000}]}}

    it 'takes in array of objects returns hash' do
      expect(helper.get_invoice_data(arr)).to be_an_instance_of(Hash) 
    end

    it 'returns correct hash' do 
      expect(helper.get_invoice_data(arr)).to eq({"AU"=>2000,"US"=>5000})
    end
  end

  describe '#convert_hash_to_array' do
    obj = {"US" => 20, "AU" => 3}

    it 'takes a hash returns an array' do
      expect(helper.convert_hash_to_array(obj, "employees")).to be_an_instance_of(Array)
    end

    it 'returns correct array' do
      expect(helper.convert_hash_to_array(obj, "employees")).to eq([["Country","Count"],["US",20],["AU",3]])
    end
  end

  describe '#get_data' do 

    before { controller.instance_variable_set(:@current_user, get_user) }

    string = "http://api-impac-uat.maestrano.io/api/v1/get_widget?engine=hr/employee_details&metadata[organization_ids][]=org-fbte"

    it 'takes a url string returns its response' do
      expect(helper.get_data(string)).to be_an_instance_of(Hash)
    end
  end

  describe '#get_employees' do 
    obj = {"content" => {"employees" => [{"address" => "20 ninth street, NSW Sydney, Australia"}]}}

    it 'takes a hash returns a hash' do
      expect(helper.get_employees(obj)).to be_an_instance_of(Hash)
    end

    it 'returns correct value' do
      expect(helper.get_employees(obj)).to eq({"Australia"=>1})
    end
  end

  describe '#get_invoices' do

    before { controller.instance_variable_set(:@current_user, get_user) }

    string = "http://api-impac-uat.maestrano.io/api/v1/get_widget?engine=hr/employee_details&metadata[organization_ids][]=org-fbte&metadata[entity]="

    it 'takes a string and returns an array' do
      result = helper.get_invoices(string)
      expect(result).to be_an_instance_of(Array)
    end

    it 'returns array containg hashs' do
      result = helper.get_invoices(string)
      expect(result[0]).to be_an_instance_of(Hash)
    end

  end

  describe '#check_local_db' do
    it 'takes a string and checks against database' do
      Country.create(query: "NSW", country_name: "AU")
      expect(check_local_db("nsw")).to eq("AU")
    end

    it 'returns nil if nothing found' do
      expect(check_local_db("nsw")).to eq(nil)
    end
  end

  describe '#save_to_db' do
    it 'saves a country to database' do
      save_to_db("nsw", "AU")
      expect(Country.count).to eq(1)
    end
  end

end
