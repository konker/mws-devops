current_dir = File.dirname(__FILE__)
log_level               :info
log_location            STDOUT
node_name               "konker"
client_key              "#{current_dir}/konker.pem"
validation_client_name  "morningwood-validator"
validation_key          "#{current_dir}/morningwood-validator.pem"
chef_server_url         "https://api.opscode.com/organizations/morningwood"
cache_type              'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path           ["#{current_dir}/../cookbooks"]
cookbook_copyright      "Konrad Markus"
cookbook_email          "konker@gmail.com"
cookbook_license        "MIT"
