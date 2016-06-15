require "jruby/profiler"

# HACK: This hack is here so we can read the set of invocations from
# the InvocationSet class. We need this to follow the stack trace.
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
        @methods = self.class.methodData(top_invocation)
        thread_name = getThreadName()
        prefix = ["Thread:#{thread_name}"]
        print_invocation_stack(out, prefix, top_invocation)
      end

    private

      def print_invocation_stack(out, prefix, invocation)
        serial = invocation.getMethodSerialNumber
        return if self.isThisProfilerInvocation(serial)

        method_data = @methods.get(serial)
        total_calls = method_data.totalCalls

        path_calls = invocation.getCount
        duration = invocation.getDuration / 1_000_000.0

        method_name =  self.methodName(serial)
        name = "#{method_name} (#{path_calls}/#{total_calls})"

        current = prefix + [name]
        out.puts("#{current.join(";")} #{duration}")

        invocation.children.entrySet.each do |entry|
          child_invocation = entry.value

          print_invocation_stack(out, current, child_invocation)
        end
      end
    end
  end
end
