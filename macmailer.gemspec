Gem::Specification.new do |s|
	s.name = "macmailer"
	s.version = "0.0.1"
	s.date = "2013-03-29"
	s.files = [ "lib/macmailer.rb" ]
	s.executables << "macmailer"
	s.add_dependency "trollop"
	s.summary = "Ruby x Mail.app"
	s.description = "Ruby binding and command-line interface for Apple's Mail.app"
	s.authors = [ "Jeremy Singer-Vine" ]
	s.email = "jsvine@gmail.com"
	s.homepage = "https://github.com/jsvine/macmailer"
end
