#encoding:utf-8
require "optparse"

inputbenchmark = ""
optparse = OptionParser.new do |opts|
  opts.on("-i", "--input ENTRY", "arquivo de entrada") do |input|
    inputbenchmark = input
  end

  opts.on("-h", "--help") do
    puts opts
    exit
  end
end

optparse.parse!(ARGV)

if inputbenchmark.empty?
  puts optparse
  exit
end


#generate bc
%x[clang -emit-llvm -c #{inputbenchmark} -o #{inputbenchmark}.bc 2> /dev/null]

#profile
%x[rm ./llvmprof.out]
profile = %x[perl ~/llvm/utils/profile.pl #{inputbenchmark}.bc]
%x[rm ./llvmprof.out]

#parse profiling output
current_function = ""
last_line = nil
bb = ""
profile.each_line do |line|
  if (match = line.match(/;;; (\S+) called (\d+) times./))
    current_function, current_function_freq = match.captures
    current_function = current_function.gsub('%', '')
    puts "\n\n---- Block Freqs for #{current_function} ----"
  elsif (match = line.match(/;;; Basic block executed (\d+) times./))
    bb      = last_line.split(' ').first.gsub(':', '')
    bb_freq = match.captures.first
    puts " #{bb} = #{bb_freq}"
  elsif (match = line.match(/;;; Out-edge counts: (.*)/))
    match.captures.first.scan(/\[(\d+\.\d+e\+\d+) -> (\S+)\]/) do |branch_freq, out_bb|
      branch_freq = branch_freq.to_f.to_i
      puts "  #{bb} -> #{out_bb} = #{branch_freq}"
    end
  end
  last_line = line
end
