{% set email = salt['pillar.get']('letsencrypt:email', '') %}
{% set server = salt['pillar.get']('letsencrypt:server', 'live') %}
{% if server == 'live' %}
{% set server = 'https://acme-v01.api.letsencrypt.org/directory' %}
{% elif server == 'staging' %}
{% set server = 'https://acme-staging.api.letsencrypt.org/directory' %}
{% else %}
{% endif %}
{% set method = salt['pillar.get']('letsencrypt:method', 'proxy') %}
{% set key_type = salt['pillar.get']('letsencrypt:key_type', 'rsa') %}
{% set key_size = salt['pillar.get']('letsencrypt:key_size', 4096) %}
{%- set curve = salt['pillar.get']('letsencrypt:curve', 'nistp256') %}

/var/lib/acme/conf:
  file.directory:
    - user: acme
    - group: acme
    - clean: true
 # Workaround until saltstack/salt#27748 gets released
 # directory needs require to not clean stuff, but we need the directory first.
 # Fix will support require_in, so dependencies work properly
    - require:
      - file: /var/lib/acme
      - user: acme
      - file: /var/lib/acme/conf/responses
      - file: /var/lib/acme/conf/target

/var/lib/acme/conf/responses:
  file.managed:
    - user: acme
    - group: acme
    - template: jinja
    - source: salt://letsencrypt/files/responses.jinja
    - require:
 #      - file: /var/lib/acme/conf
      - pkg: acmetool
 # Workaround until saltstack/salt#27748 gets released
 # directory needs require to not clean stuff, but we need the directory first.
 # Fix will support require_in, so dependencies work properly
    - makedirs: True
    - defaults:
        email: "{{ email }}"
        server: "{{ server }}"
        method: "{{ method }}"
        key_type: "{{ key_type }}"
        key_size: "{{ key_size }}"
        curve: "{{ curve }}"

/var/lib/acme/conf/target:
  file.managed:
    - user: acme
    - group: acme
    - template: jinja
    - source: salt://letsencrypt/files/target.jinja
    - require:
#     - file: /var/lib/acme/conf
      - pkg: acmetool
 # Workaround until saltstack/salt#27748 gets released
 # directory needs require to not clean stuff, but we need the directory first.
 # Fix will support require_in, so dependencies work properly
    - makedirs: True
    - defaults:
        email: "{{ email }}"
        server: "{{ server }}"
        method: "{{ method }}"
        key_type: "{{ key_type }}"
        key_size: "{{ key_size }}"
        curve: "{{ curve }}"
