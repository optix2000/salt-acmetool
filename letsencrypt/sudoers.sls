/etc/sudoers.d/acmetool:
    file.managed:
        - mode: 440
        - source: salt://letsencrypt/files/sudoers.jinja
        - template: jinja
        - user: root
        - group: root
        - require:
          - pkg: sudo
        - defaults:
            acmeuser: {{ salt['pillar.get']('letsencrypt:user', 'acme') }}
