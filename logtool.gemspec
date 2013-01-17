$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
	s.name = "logtool"
	s.version = "0.0.1"
	s.platform = Gem::Platform::RUBY
	s.authors = ["Felipe Tanus"]
	s.email = ["fotanus@jgmail.com"]
	s.homepage = "https://github.com/fotanus/logtool"
	s.summary = %q{logtool is a Rails log parser}
	s.description = %q{logtool is a Rails log parser that can accepts complex queries}
	s.files = `git ls-files`.split("\n")
	s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
	s.require_paths = ["lib"]
	s.extra_rdoc_files = [
		"README.md"
	]
end
