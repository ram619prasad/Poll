# Roles creation
#
[:admin, :user, :owner].each do |role|
  Role.create! name: role.to_s
end

# Users creation
#
# Admin
admin = User.create! email: 'admin@web2labs.net', password: 'web2labs', username: 'admin'
admin.add_role :admin
# User
user = User.create! email: 'user@web2labs.net', password: 'web2labs', username: 'user'
user.add_role :user

# Locations creation
india = Location.create! country: 'India'
# TCS - India locations
main_offices = ['TCS - New Delhi', 'Corporate', 'TCS - Pune', 'TCS - Bhopal', 'TCS - Kochi', 'TCS - Jamshedpur', 'TCS - Guwahati', 'TCS - Chennai', 'TCS - Goa', 'TCS - Bhubaneswar', 'Leave', 'TCS - Bangalore', 'TCS - Indore', 'TCS - Mumbai', 'TCS - Vadodara', 'TCS - SEEPZ', 'TCS - Hyderabad', 'TCS - Kolkata', 'TCS - Trivandrum', 'Working from Home', 'Client Place', 'TCS - Nagpur', 'TCS - Lucknow', 'TCS - Coimbatore', 'TCS - Ahmedabad']

country = Location.find_by_country('India')
country_id = country.id
country_name = country.country
main_offices.each do |office|
  Location.create! location: office, country: country_name, parent_id: country_id
end

# Chennai Locations
chennai_locations = ['185 LLOYDS ROAD-51', '185 LLOYDS ROAD-52', '188 LLOYDS ROAD-80', '188 LLOYDS ROAD-81', 'AMBATTUR', 'Ambattur BPO', 'CATHEDRAL ROAD-00', 'CATHEDRAL ROAD-01', 'CATHEDRAL ROAD-02', 'CATHEDRAL ROAD-03', 'CHN-Fortune-Non STP', 'CIL -  Chennai', 'CIL -  Manapakkam', 'CMC - CHENNAI', 'CMC Pondicherry', 'CMC-CHENNAI', 'Chennai - ILP Center', 'Chennai - TEK Tower', 'Chennai DLF IT Park', 'Chennai Non STPI', 'Chennai One - SEZ', 'Chennai PSK Sites', 'Chennai ResearchPark', 'Chennai SEZ Unit 2', 'Chennai-ILP-OMR', 'Coonoor TQ', 'Digital Zone', 'GTL - Chennai', 'HABIBULLAH ROAD', 'HP-CENTER,CHENNAI', 'Neyveli', 'PETERS ROAD-03', 'SBI Chennai', 'SCB Captive-Non STP', 'SEZ-CHE-Non-STP', 'SHOLINGANALLUR', 'STP-CHEN-AMBATTUR', 'STP-CHEN-Habibullah', 'STP-CHEN-LLOYDS RD', 'STP-CHEN-SHOLGNLR', 'STP-CHEN-TIDEL PARK', 'Siruseri - EB1', 'Siruseri - EB2', 'Siruseri - Unit 2', 'Siruseri SEZ-Unit 2', 'Siruseri-Chennai', 'Siruseri-EB4', 'Siruseri-EB5', 'Siruseri-EB6', 'Spencer Plaza STP', 'Spencer Plaza1 NSTP', 'TIDEL PARK CHEN', 'TRIL - Infopark - SEZ', 'VSNL - Chennai', 'Velachery', 'Velachery BPO']

chennai_id = Location.find_by_location('TCS - Chennai').id
chennai_locations.each do |location|
  Location.create! location: location, country: country_name, parent_id: chennai_id
end

# Hyderabad Locations
hyderabad_locations = ['AP PSK Sites', 'APIGRS, Hyderabad', 'APSWAN', 'Adibatla Unit1 SEZ', 'Adibatla, Hyd', 'BOB-HYD-NON STP', 'CBI, Hyderabad', 'CMC - Gachibowli', 'CMC - HYDERABAD', 'CMC - VISAKHAPATNAM', 'CMC HYD CORP NSTP', 'CMC-Gachibowli SEZ', 'CMC-HYDERABAD CORP', 'CMC-Vizag', 'CMC_HYD_CORP_Non_STP', 'Ericsson', 'Gachibowli-Xerox STP', 'Hyderabad - Non STP', 'Hyderabad ILP Centre', 'KLK BUILDING, HYD', 'Kohinoor Park, HYD', 'Lucent, HYD', 'Madhapur-Hyderabad', 'PSK Tirupathi', 'SynergyPark-SEZ-U1', 'SynergyPark-SEZ-U2', 'SynergyPark-SEZ-U3', 'SynergyPark-SEZ-U4', 'TTL, Hyderabad', 'TTSL-Gyanpeeth', 'UG Solutions', 'VISAKHAPATNAM', 'VIZAG', 'VSNL - Hyderabad', 'Vellore', 'Waverock SEZ']

hyderabad_id = Location.find_by_location('TCS - Hyderabad').id
hyderabad_locations.each do |location|
  Location.create! location: location, country: country_name, parent_id: hyderabad_id
end
