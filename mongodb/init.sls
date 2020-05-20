# -*- coding: utf-8 -*-
# vim: ft=sls

    {%- if grains.kernel|lower in ('linux', 'darwin',) %}

include:
  - .install
  - .config
  - .service

    {%- else %}

m-not-available-to-install:
  test.show_notification:
    - text: |
        This formula is unavailable for {{ salt['grains.get']('finger', grains.os_family) }}

    {%- endif %}
