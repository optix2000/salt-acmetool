include:
 - .repo
 - .user
 - .config
 - .target

acmetool:
  pkg.installed: []

acme-dir-perms:
  file.directory:
    - name: /var/lib/acme
    - user: acme
    - group: acme
    - require:
      - user: acme
      - pkg: acmetool
