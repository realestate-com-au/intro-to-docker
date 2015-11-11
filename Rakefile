task "default" => "exercises/index.md"

file "exercises/index.md" => "index.html" do |t|
  puts "re-generating #{t.name}"
  slides_body = File.read("index.html")
    .sub(%r{.*<textarea id="source">(.*)</textarea>.*}m) { $1 }
  slides = slides_body.split("---\n")
  slides.each do |slide|
    slide.sub!(/.*^# /m, '# ')
  end
  File.open(t.name, "w") do |exercises|
    slides.each do |slide|
      next unless slide =~ /^# Try it:/
      exercises.puts slide
    end
  end
end
