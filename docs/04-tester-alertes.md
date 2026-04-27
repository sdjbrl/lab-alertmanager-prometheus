# 04 — Tester et déclencher les alertes

## Vérifier la stack

```bash
docker compose ps
# Tous les services doivent être "Up"
```

## 1. Vérifier les règles chargées

http://localhost:9090/alerts — toutes les règles doivent apparaître en **Inactive**.

## 2. Déclencher l'alerte ServiceDown

```bash
# Stopper node-exporter
docker compose stop node-exporter

# Attendre 2 minutes (for: 2m dans la règle)
# Observer sur :9090/alerts → Pending → Firing

# Redémarrer
docker compose start node-exporter
```

## 3. Utiliser le script de test

```bash
chmod +x scripts/trigger-alert-test.sh
./scripts/trigger-alert-test.sh
```

## 4. Vérifier dans Alertmanager

http://localhost:9093 → Onglet **Alerts** — l'alerte doit apparaître.

## 5. Vérifier la notification

- Si webhook.site : vérifier la réception sur le site
- Si email : vérifier la boîte mail configurée

---

## Tester les silences

```bash
# Silencer ServiceDown pendant 10 minutes
curl -XPOST http://localhost:9093/api/v2/silences \
  -H "Content-Type: application/json" \
  -d '{
    "matchers": [{"name": "alertname", "value": "ServiceDown", "isRegex": false}],
    "startsAt": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'",
    "endsAt": "'$(date -u -d '+10 minutes' +%Y-%m-%dT%H:%M:%SZ)'",
    "createdBy": "test",
    "comment": "Test silence"
  }'

# Re-déclencher ServiceDown → pas de notification (silenced)
docker compose stop node-exporter
# ...
docker compose start node-exporter
```

---

## Points jury E5

> *"Quelle est la différence entre Prometheus et Alertmanager ?"*

**Réponse :** Prometheus évalue les règles et détecte les alertes. Alertmanager reçoit ces alertes et gère le routing, le grouping et la déduplication avant d'envoyer les notifications. Cette séparation permet de router différemment selon la criticité sans modifier les règles Prometheus.
