# 03 — Alertmanager : Routing et configuration

## Copier le fichier exemple

```bash
cp configs/alertmanager.yml.example configs/alertmanager.yml
```

Éditer `configs/alertmanager.yml` et remplacer les champs `ton-email`.

---

## Concept de routing

```
Alerte reçue
     │
     ▼
Route principale (receiver: email-infra)
     │
     ├── severity=critical → receiver: critical-channel
     │        └── email + Slack
     │
     └── severity=warning → receiver: email-infra
              └── email groupé
```

---

## Tester Alertmanager sans email réel

Utiliser **webhook.site** pour capturer les notifications :

1. Aller sur https://webhook.site — copier l'URL unique
2. Dans `alertmanager.yml`, ajouter un receiver :

```yaml
receivers:
  - name: 'test-webhook'
    webhook_configs:
      - url: 'https://webhook.site/ton-uuid-ici'
        send_resolved: true
```

3. Changer le receiver par défaut en `test-webhook`
4. Déclencher une alerte — elle apparaît sur webhook.site en temps réel

---

## Grouping : éviter le flood d'alertes

```yaml
route:
  group_by: ['alertname', 'severity']
  group_wait: 30s      # Attendre 30s pour grouper les alertes similaires
  group_interval: 5m   # Entre deux envois pour le même groupe
  repeat_interval: 4h  # Rappeler si toujours active
```

Sans grouping, si 10 serveurs tombent en même temps → 10 emails.  
Avec grouping → 1 email groupé avec les 10 alertes.

---

## Inhibition : ne pas spammer

```yaml
inhibit_rules:
  - source_match:
      severity: 'critical'
    target_match:
      severity: 'warning'
    equal: ['instance']
```

Si une alerte **critical** est active pour une instance, supprimer les alertes **warning** pour cette même instance.

---

## API Alertmanager utile

```bash
# Voir les alertes actives
curl http://localhost:9093/api/v2/alerts | python3 -m json.tool

# Silencer une alerte pendant 2h (maintenance)
curl -XPOST http://localhost:9093/api/v2/silences \
  -H "Content-Type: application/json" \
  -d '{
    "matchers": [{"name": "instance", "value": "node-exporter:9100", "isRegex": false}],
    "startsAt": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'",
    "endsAt": "'$(date -u -d '+2 hours' +%Y-%m-%dT%H:%M:%SZ)'",
    "createdBy": "admin",
    "comment": "Maintenance planifiée"
  }'
```

---

## ➡️ Suite : `04-tester-alertes.md`
