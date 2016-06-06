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
      - file: /var/lib/acme/conf/perm

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
        email: {{ email | yaml_encode }}
        server: {{ server | yaml_encode }}
        method: {{ method | yaml_encode }}
        key_type: {{ key_type | yaml_encode }}
        key_size: {{ key_size | yaml_encode}}
        curve: {{ curve | yaml_encode }}

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
        email: {{ email | yaml_encode }}
        server: {{ server | yaml_encode }}
        method: {{ method | yaml_encode }}
        key_type: {{ key_type | yaml_encode }}
        key_size: {{ key_size | yaml_encode}}
        curve: {{ curve | yaml_encode }}

/var/lib/acme/conf/perm:
  file.managed:
    - user: acme
    - group: acme
    - template: jinja
    - source: salt://letsencrypt/files/perm.jinja
    - require:
      - pkg: acmetool
    - makedirs: True
    - defaults:
        perms: {{ salt['pillar.get']('letsencrypt:perms', []) | yaml }}
