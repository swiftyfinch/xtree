PATH_TO_APP = ARGV[0]

# Calculate sha
SHA = %x[shasum -a 256 '#{PATH_TO_APP}'].split(' ').first
puts SHA

# Replace sha
text = File.read(ENV['HOMEBREW_CASK_FILE'])
updated_text = text.gsub(/sha256 '.*'/, "sha256 '#{SHA}'")
File.write(ENV['HOMEBREW_CASK_FILE'], updated_text)
