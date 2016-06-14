require "jruby/profiler"

module JRuby
  module Profiler
    class FlameGraphProfilePrinter < ::Java::OrgJrubyRuntimeProfileBuiltin::ProfilePrinter
      VERSION = "0.1.0"

      # @param [IO] out
      def printHeader(out)
      end

      # @param [IO] out
      def printFooter(out)
      end

      # @param [IO] out Where we want to write our output
      # @param [Boolean] is_first (false) Does nothing, at the moment
      def printProfile(out, is_first=false)
        ti = getTopInvocation
        top_serial_number = ti.getMethodSerialNumber
        thread_name = getThreadName()
        prefix = ["Thread:#{thread_name}"]

        methods = self.class.methodData(ti);
        methods.entrySet.each do |entry|
          serial = entry.key
          method_data = entry.value

          # Only print the stack of "root" methods. People called by
          # the top most invocation.
          if method_data.parents.to_a == [top_serial_number]
            print_stack(out, prefix, methods, serial)
          end
        end
      end

    private

      def print_stack(out, prefix, methods, serial)
        return if self.isThisProfilerInvocation(serial)

        method_data = methods.get(serial)
        method_name =  self.methodName(serial)

        num_calls = method_data.totalCalls
        name = "#{method_name} (#{num_calls})"
        duration = method_data.totalTime / 1000000.0

        current = prefix + [name]
        out.puts("#{current.join(";")} #{duration}")

        method_data.children.to_a.each do |child_serial|
          print_stack(out, current, methods, child_serial)
        end
      end
    end
  end
end
