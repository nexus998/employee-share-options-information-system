# -*- encoding: utf-8 -*-
# stub: flog 4.6.5 ruby lib

Gem::Specification.new do |s|
  s.name = "flog".freeze
  s.version = "4.6.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "homepage_uri" => "http://ruby.sadi.st/", "source_code_uri" => "https://github.com/seattlerb/flog" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Ryan Davis".freeze]
  s.cert_chain = ["-----BEGIN CERTIFICATE-----\nMIIDPjCCAiagAwIBAgIBBjANBgkqhkiG9w0BAQsFADBFMRMwEQYDVQQDDApyeWFu\nZC1ydWJ5MRkwFwYKCZImiZPyLGQBGRYJemVuc3BpZGVyMRMwEQYKCZImiZPyLGQB\nGRYDY29tMB4XDTIxMTIyMzIzMTkwNFoXDTIyMTIyMzIzMTkwNFowRTETMBEGA1UE\nAwwKcnlhbmQtcnVieTEZMBcGCgmSJomT8ixkARkWCXplbnNwaWRlcjETMBEGCgmS\nJomT8ixkARkWA2NvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALda\nb9DCgK+627gPJkB6XfjZ1itoOQvpqH1EXScSaba9/S2VF22VYQbXU1xQXL/WzCkx\ntaCPaLmfYIaFcHHCSY4hYDJijRQkLxPeB3xbOfzfLoBDbjvx5JxgJxUjmGa7xhcT\noOvjtt5P8+GSK9zLzxQP0gVLS/D0FmoE44XuDr3iQkVS2ujU5zZL84mMNqNB1znh\nGiadM9GHRaDiaxuX0cIUBj19T01mVE2iymf9I6bEsiayK/n6QujtyCbTWsAS9Rqt\nqhtV7HJxNKuPj/JFH0D2cswvzznE/a5FOYO68g+YCuFi5L8wZuuM8zzdwjrWHqSV\ngBEfoTEGr7Zii72cx+sCAwEAAaM5MDcwCQYDVR0TBAIwADALBgNVHQ8EBAMCBLAw\nHQYDVR0OBBYEFEfFe9md/r/tj/Wmwpy+MI8d9k/hMA0GCSqGSIb3DQEBCwUAA4IB\nAQCKB5jfsuSnKb+t/Wrh3UpdkmX7TrEsjVmERC0pPqzQ5GQJgmEXDD7oMgaKXaAq\nx2m+KSZDrqk7c8uho5OX6YMqg4KdxehfSLqqTZGoeV78qwf/jpPQZKTf+W9gUSJh\nzsWpo4K50MP+QtdSbKXZwjAafpQ8hK0MnnZ/aeCsW9ov5vdXpYbf3dpg6ADXRGE7\nlQY2y1tJ5/chqu6h7dQmnm2ABUqx9O+JcN9hbCYoA5i/EeubUEtFIh2w3SpO6YfB\nJFmxn4h9YO/pVdB962BdBNNDia0kgIjI3ENnkLq0dKpYU3+F3KhEuTksLO0L6X/V\nYsuyUzsMz6GQA4khyaMgKNSD\n-----END CERTIFICATE-----\n".freeze]
  s.date = "2022-04-09"
  s.description = "Flog reports the most tortured code in an easy to read pain\nreport. The higher the score, the more pain the code is in.".freeze
  s.email = ["ryand-ruby@zenspider.com".freeze]
  s.executables = ["flog".freeze]
  s.extra_rdoc_files = ["History.rdoc".freeze, "Manifest.txt".freeze, "README.rdoc".freeze]
  s.files = ["History.rdoc".freeze, "Manifest.txt".freeze, "README.rdoc".freeze, "bin/flog".freeze]
  s.homepage = "http://ruby.sadi.st/".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--main".freeze, "README.rdoc".freeze]
  s.rubygems_version = "3.1.6".freeze
  s.summary = "Flog reports the most tortured code in an easy to read pain report".freeze

  s.installed_by_version = "3.1.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<sexp_processor>.freeze, ["~> 4.8"])
    s.add_runtime_dependency(%q<ruby_parser>.freeze, ["~> 3.1", "> 3.1.0"])
    s.add_runtime_dependency(%q<path_expander>.freeze, ["~> 1.0"])
    s.add_development_dependency(%q<minitest>.freeze, ["~> 5.0"])
    s.add_development_dependency(%q<rdoc>.freeze, [">= 4.0", "< 7"])
    s.add_development_dependency(%q<hoe>.freeze, ["~> 3.23"])
  else
    s.add_dependency(%q<sexp_processor>.freeze, ["~> 4.8"])
    s.add_dependency(%q<ruby_parser>.freeze, ["~> 3.1", "> 3.1.0"])
    s.add_dependency(%q<path_expander>.freeze, ["~> 1.0"])
    s.add_dependency(%q<minitest>.freeze, ["~> 5.0"])
    s.add_dependency(%q<rdoc>.freeze, [">= 4.0", "< 7"])
    s.add_dependency(%q<hoe>.freeze, ["~> 3.23"])
  end
end
