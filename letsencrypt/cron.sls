acmetool-cron:
    cron.present:
        - name: /usr/bin/acmetool reconcile --batch
        - user: {{ salt['pillar.get']('letsencrypt:user', 'acme') }}
        - minute: 42
        - hour: 12
        - comment: 'acmetool - Checks and requests for certificates'
