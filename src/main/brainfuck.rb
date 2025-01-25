Dir.glob(File.absolute_path(__FILE__).sub(/\.rb$/, "#{File::SEPARATOR}*.rb")).each(&method(:require))

