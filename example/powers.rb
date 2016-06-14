require require "jruby/profiler/flame_graph_profile_printer"

def ok
  3 ** 3
end

def test
  ok ** 3
end

result = JRuby::Profiler.profile do
  # Do some expensive stuff.
  10_000.times do
     test ** 3
  end
end

printer = JRuby::Profiler::FlameGraphProfilePrinter.new(result)
printer.printProfile(STDOUT)
