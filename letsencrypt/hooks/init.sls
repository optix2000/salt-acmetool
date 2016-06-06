include:
 - ..sudoers
 - ...letsencrypt

/usr/lib/acme/hooks:
    file.recurse:
        - user: root
        - group: root
        - dir_mode: 755
        - file_mode: 755
        - source: salt://letsencrypt/hooks/files
        - require:
          - pkg: acmetool
          - file: /etc/sudoers.d/acmetool
