# 01 — Concepts : Pipeline d'alerte Prometheus

## Vue d'ensemble

```
Métriques → Prometheus → Règles d'alerte → Alertmanager → Notification
              (scrape)   (évaluation)        (routing)      (email/Slack)
```

**Prometheus** collecte les métriques toutes les 15s. Il évalue aussi les règles d'alerte toutes les 15s.

**Alertmanager** reçoit les alertes firing, les groupe, les route vers les bons canaux, et supprime les doublons.

---

## États d'une alerte

| État | Description |
|---|---|
| **Inactive** | Condition non remplie — tout va bien |
| **Pending** | Condition remplie mais pas encore assez longtemps (< `for:`) |
| **Firing** | Alerte active → envoyée à Alertmanager |

Le paramètre `for: 5m` évite les faux positifs (un pic CPU de 2 secondes ne génère pas d'alerte).

---

## Anatomie d'une règle d'alerte

```yaml
- alert: DiskSpaceCritical          # Nom de l'alerte
  expr: |                            # Expression PromQL — condition
    (node_filesystem_avail_bytes /
     node_filesystem_size_bytes) * 100 < 10
  for: 2m                            # Doit être vrai pendant 2 minutes
  labels:
    severity: critical               # Labels pour le routing Alertmanager
  annotations:
    summary: "Disque critique"       # Titre court
    description: "Seulement {{ $value }}% disponible"  # Détail avec variables
```

---

## Variables dans les annotations

| Variable | Description |
|---|---|
| `{{ $value }}` | Valeur numérique déclenchant l'alerte |
| `{{ $labels.instance }}` | Label "instance" de la métrique |
| `{{ $labels.job }}` | Label "job" |
| `{{ $labels.mountpoint }}` | Pour les métriques disque |

---

## ➡️ Suite : `02-regles-prometheus.md`
