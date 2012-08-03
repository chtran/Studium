input_name = ARGV[0]
output_name = ARGV[1]
input = File.open input_name, "r"
lines = IO.readlines input
data = ""
lines.each do |line|
  if line=~/(\d+)-(\d+): (\w+)/
    range = $1.to_i..$2.to_i
    range.each do |num|
      data+= "%03d" % num
      data+= ". #{$3[num%10-1]}"
      data+= "\n"
    end
  end
end
puts data
puts output_name
output = File.open(output_name, "w+")
output << data
output.close
