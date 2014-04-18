Description
===========

Accumulate resources and inject them into a file or template.

Accumulator is a Chef primitive that allows you to collect Chef::Resource
objects from the current run_context, optionally tranform this collection and
then provide as input for a target Template or File resource

Cookbooks using Accumulator
===========================

- [mail_alias](https://github.com/kisoku/chef-mail_alias)
- [sysctl](https://github.com/spheromak/sysctl-cookbook/tree/accumulator)

License and Authors
-------------------

Author:: Mathieu Sauve-Frankel (<msf@kisoku.net>)

Copyright:: Copyright (c) 2012 Mathieu Sauve-Frankel

License:: Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
