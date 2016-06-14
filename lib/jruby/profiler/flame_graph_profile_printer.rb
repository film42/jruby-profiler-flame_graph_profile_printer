require "jruby/profiler"
require "set"

class ::Java::OrgJrubyRuntimeProfileBuiltin::InvocationSet
  def get_invocations
    field = ::Java::OrgJrubyRuntimeProfileBuiltin::InvocationSet.java_class.declared_field(:invocations)
    field.accessible = true
    field.value(self)
  end
end

module JRuby
  module Profiler
    class FlameGraphProfilePrinter < ::Java::OrgJrubyRuntimeProfileBuiltin::ProfilePrinter
      VERSION = "0.1.0"

      def printHeader(out)
      end

      def printFooter(out)
      end

      def printProfile(out, is_first=false)
        top_invocation = getTopInvocation
        # top_serial_number = ti.getMethodSerialNumber
        thread_name = getThreadName()
        prefix = ["Thread:#{thread_name}"]

        @methods = self.class.methodData(top_invocation);

        print_invocation_stack(out, prefix, top_invocation)
      end

    private

      def print_invocation_stack(out, prefix, invocation)
        serial = invocation.getMethodSerialNumber
        return if self.isThisProfilerInvocation(serial)

        method_data = @methods.get(serial)

        method_name =  self.methodName(serial)
        num_calls = method_data.totalCalls
        name = "#{method_name} (#{num_calls})"
        duration = method_data.totalTime / 1000000.0

        current = prefix + [name]
        out.puts("#{current.join(";")} #{duration}")

        invocation.children.entrySet.each do |entry|
          serial = entry.key
          child_invocation = entry.value

          print_invocation_stack(out, current, child_invocation)
        end

      end
    end
  end
end
