#
# Author:: Mathieu Sauve-Frankel <msf@kisoku.net>
# Copyright:: Copyright (c) 2012 Mathieu Sauve-Frankel
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/provider'

class Chef
  class Provider
    class Accumulator < Chef::Provider

      def initialize(new_resource, run_context)
        super(new_resource, run_context)

        @target = nil
      end

      # TODO add whyrun support
      def whyrun_supported?
        false
      end

      def load_current_resource
        @current_resource = Chef::Resource::Accumulator.new(new_resource.name)

        @current_resource.target(new_resource.target)
        @current_resource.filter(&new_resource.filter)
        @current_resource.transform(&new_resource.transform)
        @current_resource.variable_name(new_resource.variable_name)

        @current_resource
      end

      def action_create
        resources = run_context.resource_collection.select &new_resource.filter
        target = run_context.resource_collection.find(new_resource.target)

        data = nil
        if new_resource.transform.nil?
          data = resources
        else
          data = new_resource.transform.call(resources)
        end

        if target.is_a? Chef::Resource::Template
          if new_resource.variable_name.nil?
            target.variables[:accumulator_data] = data
          else
            target.variables[new_resource.variable_name] = data
          end
        elsif target.is_a? Chef::Resource::File
          target.content = data
        else
          raise ArgumentError, "accumulator target resource must be template or file"
        end

        target.run_action(:create)
        if target.updated_by_last_action?
          new_resource.updated_by_last_action(true)
        end
      end
    end
  end
end
