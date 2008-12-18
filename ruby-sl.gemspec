# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ruby-sl}
  s.version = "0.11"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Yutaka HARA"]
  s.date = %q{2008-12-18}
  s.description = %q{}
  s.email = %q{yutaka.hara+github@gmail.com}
  s.extra_rdoc_files = ["README", "ChangeLog"]
  s.files = ["README", "ChangeLog", "Rakefile", "lib/sl.rb"]
  s.has_rdoc = false
  s.homepage = %q{http://github.com/yhara/ruby-sl/tree/master}
  s.rdoc_options = ["--title", "ruby-sl documentation", "--charset", "utf-8", "--opname", "index.html", "--line-numbers", "--main", "README", "--inline-source", "--exclude", "^(examples|extras)/"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
