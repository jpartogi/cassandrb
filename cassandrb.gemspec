# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cassandrb}
  s.version = '0.1.0'
  
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Joshua Partogi"]
  s.date = %q{2011-02-07}
  s.email = %q{joshua.partogi@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".gitignore",
     "LICENSE",
     "README.rdoc",
     "VERSION.yml",
     "cassandrb.gemspec",
     "lib/cassandrb.rb",
     "lib/cassandrb/connection.rb",
     "lib/cassandrb/railtie.rb",
     "lib/cassandrb/version.rb",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/scrum8/cassandrb}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Cassandra OBTM.}
  s.test_files = [
    "spec/spec_helper.rb",
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_dependency(%q<cassandra>, ">= 0.9.0")
      s.add_dependency(%q<activemodel>, ">= 3.0.0")
      s.add_dependency(%q<activesupport>, ">= 3.0.0")
    else
      s.add_dependency(%q<cassandra>, ">= 0.9.0")
      s.add_dependency(%q<activemodel>, ">= 3.0.0")
      s.add_dependency(%q<activesupport>, ">= 3.0.0")
    end
  else
    s.add_dependency(%q<cassandra>, ">= 0.9.0")
    s.add_dependency(%q<activemodel>, ">= 3.0.0")
    s.add_dependency(%q<activesupport>, ">= 3.0.0")
  end
end