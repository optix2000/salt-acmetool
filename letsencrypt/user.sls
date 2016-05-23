acme:
  user.present:
    - shell: /sbin/nologin
    - home: /var/lib/acme
    - system: true
    - createhome: false # Package makes homedir
