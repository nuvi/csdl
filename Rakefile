require "bundler/gem_tasks"
require "rake/testtask"
require 'rake/clean'

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

task :default => :test

task :build => [:generate_release]

GENERATED_FILES = %w(lib/csdl/boolean_lexer.rb
                     lib/csdl/boolean_parser.rb)

CLEAN.include(GENERATED_FILES)

desc 'Generate the Ragel lexer and Racc parser.'
task :generate => GENERATED_FILES do
  Rake::Task[:ragel_check].invoke
  GENERATED_FILES.each do |filename|
    content = File.read(filename)
    content = "# -*- encoding:utf-8; warn-indent:false; frozen_string_literal: true  -*-\n" + content

    File.open(filename, 'w') do |io|
      io.write content
    end
  end
end

task :regenerate => [:clean, :generate]

desc 'Generate the Ragel lexer and Racc parser in release mode.'
task :generate_release => [:clean_env, :regenerate]

task :clean_env do
  ENV.delete 'RACC_DEBUG'
end

task :ragel_check do
  require "cliver"
  Cliver.assert("ragel", "~> 6.7")
end

task :python_check do
  require "cliver"
  Cliver.detect('python3', '>= 3.0.0',
                detector: ["-c", "from pyeda.inter import *; import platform; print(platform.python_version())"])
end

rule '.rb' => '.rl' do |t|
  sh "ragel -F1 -R #{t.source} -o #{t.name}"
end

rule '.rb' => '.y' do |t|
  opts = [ t.source,
           "-o", t.name
         ]
  opts << "--debug" if ENV['RACC_DEBUG']

  sh "racc", *opts
end

task :test => [:generate]
