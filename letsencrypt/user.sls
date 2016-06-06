acme:
  user.present:
    - shell: /usr/sbin/nologin
    - home: /var/lib/acme
    - system: true
    - createhome: false # Package makes homedir
