#encoding:utf-8
require "optparse"

if RUBY_PLATFORM.downcase.include?("darwin")
  lib_extension = "dylib"
else
  lib_extension = "so"
end

rebuild_benchmark  = false

options  = {}
optparse = OptionParser.new do |opts|
  opts.on("-b", "--rebuild-benchmark", "re-compila o spec") do
    rebuild_benchmark = true
  end

  opts.on("-h", "--help") do
    puts opts
    exit
  end
end

optparse.parse!(ARGV)

if rebuild_benchmark
  %x[make clean]
  %x[make TEST=CompileAll -j12]
end

%x[export PATH=$PATH:~/llvm/Debug+Asserts/bin/:~/llvm/Debug+Asserts/lib/]

pwd_dir = "/Users/matheusvilela/llvm/projects/test-suite/External/SPEC"

Dir.entries(pwd_dir).each do |filename|
  spec_dir = File.join(pwd_dir, filename)
  next unless File.directory?(spec_dir)
  

  Dir.entries(spec_dir).each do |testname|
    test_dir = File.join(spec_dir, testname)
    next unless File.directory?(test_dir)

    testfile = File.join(test_dir, "Output", "#{testname}.linked.rbc")
    if File.exists?(testfile)

      use_fortran = false

      if testname == "436.cactusADM"
        use_fortran = true
        inputfile = "~/llvm/projects/test-suite-externals/speccpu2006/benchspec/CPU2006/436.cactusADM/data/train/input/benchADM.par"
        outputfile=""
        stdoutfile="cactusADM.out"
        stderrfile="cactusADM.err"
        arguments="#{inputfile} > #{stdoutfile} 2> #{stderrfile} "

      elsif testname == "454.calculix"
        use_fortran = true
        inputfile = "~/llvm/projects/test-suite-externals/speccpu2006/benchspec/CPU2006/454.calculix/data/train/input/stairs"
        outputfile=""
        stdoutfile="calculix.train.out"
        stderrfile="calculix.train.err"
        arguments="-i #{inputfile} > #{stdoutfile} 2> #{stderrfile} "

      elsif testname == "482.sphinx3"
        inputfile = "sphinx.ctl"
        outputfile=""
        stdoutfile="sphinx3.out"
        stderrfile="sphinx3.err"
        testdir= "~/llvm/projects/test-suite-externals/speccpu2006/benchspec/CPU2006/482.sphinx3/data/ref/input"
        copyfilestocurrentfolder = true
        additionalfilestocopy=["~/llvm/projects/test-suite-externals/speccpu2006/benchspec/CPU2006/482.sphinx3/data/all/input/*",
          "#{testdir}/beams.dat", "#{testdir}/args.an4"]
        arguments=" #{inputfile} #{testdir} args.an4 > #{stdoutfile} 2> #{stderrfile} "

      elsif testname == "453.povray"
        inputfile="~/llvm/projects/test-suite-externals/speccpu2006/benchspec/CPU2006/453.povray/data/train/input/SPEC-benchmark-train.ini"
        outputfile=""
        stdoutfile="povray.train.out"
        stderrfile="povray.train.err"						
        copyfilestocurrentfolder = true
        additionalfilestocopy=["~/llvm/projects/test-suite-externals/speccpu2006/benchspec/CPU2006/453.povray/data/all/input/*.inc",
          "~/llvm/projects/test-suite-externals/speccpu2006/benchspec/CPU2006/453.povray/data/train/input/SPEC-benchmark-train.pov"]
        arguments=" #{inputfile} > #{stdoutfile} 2> #{stderrfile} "

      elsif testname == "433.milc"
        inputfile="~/llvm/projects/test-suite-externals/speccpu2006/benchspec/CPU2006/433.milc/data/test/input/su3imp.in"
        outputfile=""
        stdoutfile="milc.test.out"
        stderrfile="milc.test.err"
        arguments=" < #{inputfile} > #{stdoutfile} 2> #{stderrfile} "

      elsif testname == "444.namd"
        inputfile="~/llvm/projects/test-suite-externals/speccpu2006/benchspec/CPU2006/444.namd/data/all/input/namd.input"
        outputfile="namd.out"
        stdoutfile="namd.all.out"
        stderrfile="namd.all.err"						
        arguments=" --input #{inputfile} --iterations 1 --output #{outputfile} > #{stdoutfile} 2> #{stderrfile} "

      elsif testname == "447.dealII"
        outputfile=""
        stdoutfile="dealII.test.out"
        stderrfile="dealII.test.err"						
        arguments=" 3 > #{stdoutfile} 2> #{stderrfile} "

      elsif testname == "450.soplex"
        inputfile="~/llvm/projects/test-suite-externals/speccpu2006/benchspec/CPU2006/450.soplex/data/train/input/train.mps"
        outputfile=""
        stdoutfile="soplex.test.out"
        stderrfile="soplex.test.err"					   
        arguments="-m1200 #{inputfile} > #{stdoutfile} 2> #{stderrfile} "

      elsif testname == "470.lbm"
        inputfile="~/llvm/projects/test-suite-externals/speccpu2006/benchspec/CPU2006/470.lbm/data/test/input/100_100_130_cf_a.of"
        outputfile=""
        stdoutfile="lbm.ref.out"
        stderrfile="lbm.ref.err"						
        arguments="1000 reference.dat 0 0 #{inputfile} > #{stdoutfile} 2> #{stderrfile} "

      elsif testname == "400.perlbench"
        inputfile="~/llvm/projects/test-suite-externals/speccpu2006/benchspec/CPU2006/400.perlbench/data/all/input/diffmail.pl"
        outputfile=""
        stdoutfile="perlbench.all.diffmail.out"
        stderrfile="dperlbench.ref.diffmail.err"						
        arguments=" -I/home/matheusv/llvm/projects/test-suite-externals/speccpu2006/benchspec/CPU2006/400.perlbench/data/all/input/lib #{inputfile} 4 800 10 17 19 300 > #{stdoutfile} 2> #{stderrfile}"

      elsif testname == "401.bzip2"
        inputfile="~/llvm/projects/test-suite-externals/speccpu2006/benchspec/CPU2006/401.bzip2/data/all/input/input.program"
        outputfile=""
        stdoutfile="bzip2.all.program.out"
        stderrfile="bzip2.all.program.err"						
        arguments=" #{inputfile} 280 > #{stdoutfile} 2> #{stderrfile} "

      elsif testname == "429.mcf"
        inputfile="~/llvm/projects/test-suite-externals/speccpu2006/benchspec/CPU2006/429.mcf/data/train/input/inp.in"
        outputfile=""
        stdoutfile="mcf.test.out"
        stderrfile="mcf.test.err"						
        arguments=" #{inputfile} > #{stdoutfile} 2> #{stderrfile} "

     elsif testname == "403.gcc"
       inputfile="~/llvm/projects/test-suite-externals/speccpu2006/benchspec/CPU2006/403.gcc/data/ref/input/166.i"
       outputfile=""
       stdoutfile="gcc.test.cccp.out"
       stderrfile="gcc.test.cccp.err"						
       arguments=" #{inputfile} -o cccp.s > #{stdoutfile} 2> #{stderrfile} "

      elsif testname == "445.gobmk"
        inputfile="~/llvm/projects/test-suite-externals/speccpu2006/benchspec/CPU2006/445.gobmk/data/train/input/arb.tst"
        outputfile=""
        stdoutfile="gobmk.arb.out"
        stderrfile="gobmk.arb.err"						
        arguments=" --quiet --mode gtp < #{inputfile} > #{stdoutfile} 2> #{stderrfile} "
        copyfilestocurrentfolder = true
        additionalfilestocopy=["~/llvm/projects/test-suite-externals/speccpu2006/benchspec/CPU2006/445.gobmk/data/all/input/golois",
          "~/llvm/projects/test-suite-externals/speccpu2006/benchspec/CPU2006/445.gobmk/data/all/input/games"]

      elsif testname == "456.hmmer"
        inputfile="~/llvm/projects/test-suite-externals/speccpu2006/benchspec/CPU2006/456.hmmer/data/test/input/bombesin.hmm"
        outputfile=""
        stdoutfile="hmmer.test.bombesin.out"
        stderrfile="hmmer.test.bombesin.err"	
        arguments=" --fixed 0 --mean 325 --num 45000 --sd 200 --seed 0 #{File.basename(inputfile)} > #{stdoutfile} 2> #{stderrfile} "
        copyfilestocurrentfolder=true
 
      elsif testname == "458.sjeng"
        inputfile="~/llvm/projects/test-suite-externals/speccpu2006/benchspec/CPU2006/458.sjeng/data/test/input/test.txt"
        outputfile=""
        stdoutfile="sjeng.test.out"
        stderrfile="sjeng.test.err"						
        arguments=" #{inputfile} > #{stdoutfile} 2> #{stderrfile} "

      elsif testname == "462.libquantum"
        outputfile=""
        stdoutfile="libquantum.test.out"
        stderrfile="libquantum.test.err"					
        arguments=" 143 25 > #{stdoutfile} 2> #{stderrfile} "

      elsif testname == "464.h264ref"
        inputfile="~/llvm/projects/test-suite-externals/speccpu2006/benchspec/CPU2006/464.h264ref/data/test/input/foreman_test_encoder_baseline.cfg"
        outputfile=""
        stdoutfile="h264ref.test.foreman_baseline.out"
        stderrfile="h264ref.test.foreman_baseline.err"						
        arguments=" -d #{File.basename(inputfile)} > #{stdoutfile} 2> #{stderrfile} "
        copyfilestocurrentfolder=true
        additionalfilestocopy="~/llvm/projects/test-suite-externals/speccpu2006/benchspec/CPU2006/464.h264ref/data/all/input/foreman_qcif.yuv"
 
      elsif testname == "471.omnetpp"
        inputfile="~/llvm/projects/test-suite-externals/speccpu2006/benchspec/CPU2006/471.omnetpp/data/test/input/omnetpp.ini"
        outputfile=""
        stdoutfile="omnetpp.test.log"
        stderrfile="omnetpp.test.err"						
        arguments=" #{File.basename(inputfile)} > #{stdoutfile} 2> #{stderrfile} "
        copyfilestocurrentfolder=true

      elsif testname == "473.astar"
        inputfile="~/llvm/projects/test-suite-externals/speccpu2006/benchspec/CPU2006/473.astar/data/test/input/lake.cfg"
        outputfile=""
        stdoutfile="astar.test.lake.out"
        stderrfile="astar.test.lake.err"						
        arguments=" #{File.basename(inputfile)} > #{stdoutfile} 2> #{stderrfile} "
        copyfilestocurrentfolder=true
        additionalfilestocopy="~/llvm/projects/test-suite-externals/speccpu2006/benchspec/CPU2006/473.astar/data/test/input/lake.bin"

      elsif testname == "483.xalancbmk"
        inputfolder="~/llvm/projects/test-suite-externals/speccpu2006/benchspec/CPU2006/483.xalancbmk/data/train/input"
        inputfile1="#{inputfolder}/allbooks.xml"
        inputfile2="#{inputfolder}/xalanc.xsl"
        outputfile=""
        stdoutfile="xalancbmk.test.out"
        stderrfile="xalancbmk.test.err"						
        arguments=" -v #{inputfile1} #{inputfile2} > #{stdoutfile} 2> #{stderrfile} "

      else
        puts "No entries for #{testname}"
        next
      end

      # Some programs requires write rights. To guarantee that we have write rights
      # we will copy these files to the current folder.
      if copyfilestocurrentfolder
        [inputfile, additionalfilestocopy].flatten.compact.each do |copyfile|
          copycmd = "cp -R #{copyfile} ."
          %x[#{copycmd}]
        end
      end

      branch_probs = {}
      # run llvm branch-prob pass
      output = %x[opt -branch-prob #{testfile} -analyze]
      current_function = ""
      output.each_line do |line|
        if (match = line.match(/Printing analysis .* for function '(.*)':/))
          current_function = match.captures.first
        elsif (match = line.match(/edge (.*) -> (.*) probability is.* (\d+\.?\d*)%/))
          edge1, edge2, prob = match.captures
          prob = prob.to_f/100.0
          branch_probs[current_function] ||= {}
          branch_probs[current_function][edge1] ||= {}
          branch_probs[current_function][edge1][edge2] ||= {}
          branch_probs[current_function][edge1][edge2]["llvm"] = prob
        end
      end

      # run our branch-prediction pass
      output = %x[opt -load ~/llvm/Debug+Asserts/lib/static-profiling.dylib -branch-prediction #{testfile} -analyze]
      current_function = ""
      output.each_line do |line|
        if (match = line.match(/Printing analysis .* for function '(.*)':/))
          current_function = match.captures.first
        elsif (match = line.match(/edge (.*) -> (.*) probability is.* (\d+\.?\d*)%/))
          edge1, edge2, prob = match.captures
          prob = prob.to_f/100.0
          branch_probs[current_function] ||= {}
          branch_probs[current_function][edge1] ||= {}
          branch_probs[current_function][edge1][edge2] ||= {}
          branch_probs[current_function][edge1][edge2]["wu"] = prob
        end
      end

      # run dynamic profiling
      %x[rm -f ./llvmprof.out]
      profile = %x[perl ~/llvm/utils/profile.pl #{testfile} #{arguments}]
      %x[rm -f ./llvmprof.out]
      current_function = ""
      last_line = nil
      current_bb = ""
      current_bb_freq = nil
      profile.each_line do |line|
        if (match = line.match(/;;; (\S+) called (\d+) times./))
          current_function, current_function_freq = match.captures
          current_function = current_function.gsub('%', '')
        elsif (match = line.match(/;;; Basic block executed (\d+) times./))
          current_bb      = last_line.split(' ').first.gsub(':', '')
          current_bb_freq = match.captures.first.to_f
        elsif (match = line.match(/;;; Out-edge counts: (.*)/))
          match.captures.first.scan(/\[(\d+\.\d+e\+\d+) -> (\S+)\]/) do |branch_freq, out_bb|
            branch_freq = branch_freq.to_f

            prob = branch_freq/current_bb_freq
            edge1 = current_bb
            edge2 = out_bb
            branch_probs[current_function] ||= {}
            branch_probs[current_function][edge1] ||= {}
            branch_probs[current_function][edge1][edge2] ||= {}
            branch_probs[current_function][edge1][edge2]["real"] = prob
          end
        end
        last_line = line
      end

      # calculate errors
      llvm_error = 0
      wu_error   = 0
      count      = 0
      branch_probs.each_pair do |fn, branches|
        branches.each_pair do |src_basic_block, dst_basic_blocks|
          dst_basic_blocks.each_pair do |dst_basic_block, profilers|
            hit_rate   = profilers["real"] || next
            llvm_error += (hit_rate - profilers["llvm"]).abs
            wu_error   += (hit_rate - profilers["wu"]).abs
            count      += 1
          end
        end
      end
      puts "llvm: #{ "%.2f" % ((llvm_error/count)*100.0)}%"
      puts "wu  : #{ "%.2f" % ((wu_error/count)*100.0)}%"
    end
  end
end
