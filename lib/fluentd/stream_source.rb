#
# Fluentd
#
# Copyright (C) 2011-2012 FURUHASHI Sadayuki
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#
module Fluentd


  module StreamSource
    include AgentGroup

    attr_reader :stream_source

    def setup_internal_bus(bus)
      @stream_source_parent = bus
      @stream_source = bus
    end

    def configure(conf)
      super

      if error_conf = conf.elements.find {|e| e.name == 'error' }
        type = error_conf['type'] || 'redirect'
        @error_stream = conf.plugin.new_output(type)
        configure_agent(@error_stream, error_conf, @stream_source_parent)
        @stream_source = Collectors::ErrorStreamCollector.new(@stream_source_parent, @error_stream)
      end
    end
  end


end
