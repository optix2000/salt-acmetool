{% set domains = salt['pillar.get']('letsencrypt:domains', {}) -%}
/var/lib/acme/desired:
  file.directory:
    - user: acme
    - group: acme
    - clean: true
    - require:
      - file: /var/lib/acme
{%- for domain in domains %}
      - file: /var/lib/acme/desired/{{ domain }}
{%- endfor %}

{% for domain, val in domains.iteritems() -%}
/var/lib/acme/desired/{{ domain }}:
  file.managed:
      - user: acme
      - group: acme
      - template: jinja
      - source: salt://letsencrypt/files/desired.jinja
      - makedirs: True
      - defaults:
          san: {{ val.get('san', []) | yaml }}
          overrides: {{ val.get('overrides', {}) | yaml }}
          domain: {{ domain }}
{% endfor %}
