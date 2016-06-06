/etc/nginx/apps/{{ grains.fqdn }}/letsencrypt:
  file.managed:
    - source: salt://letsencrypt/files/nginx-include
    - require:
      - file: /etc/nginx/apps/{{ grains.fqdn }}
{% for domain in salt['pillar.get']('letsencrypt:domains', {}) %}
/etc/nginx/apps/{{ domain }}/letsencrypt:
  file.managed:
    - source: salt://letsencrypt/files/nginx-include
    - require:
      - file: /etc/nginx/apps/{{ domain }}
{% endfor %}
