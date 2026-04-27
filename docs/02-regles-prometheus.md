# 02 — Écrire des règles d'alerte Prometheus

## Métriques node-exporter disponibles

### CPU
```promql
# % CPU utilisé (1 - idle)
100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```

### RAM
```promql
# % RAM utilisée
(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100
```

### Disque
```promql
# % espace disponible par partition
(node_filesystem_avail_bytes{fstype!~"tmpfs|overlay"} / node_filesystem_size_bytes) * 100
```

### Service UP/DOWN
```promql
# 0 = down, 1 = up
up{job="node-exporter"}
```

---

## Exercices pratiques

### Exercice 1 : Alerte RAM critique à 90%

Compléter la règle :

```yaml
- alert: ???
  expr: ???
  for: ???
  labels:
    severity: ???
  annotations:
    summary: ???
```

Solution dans `configs/alert-rules.yml` (règle `HighMemoryUsage`).

### Exercice 2 : Tester une règle dans Prometheus

1. Aller sur http://localhost:9090/alerts
2. Vérifier que toutes les règles sont en état **Inactive**
3. Dans l'onglet **Graph**, taper :
   ```promql
   (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100
   ```
4. Observer la valeur actuelle — est-elle proche du seuil 85% ?

### Exercice 3 : Simuler une alerte

```bash
# Remplir la RAM avec un processus temporaire
stress --vm 1 --vm-bytes 80% --timeout 120s &

# Observer l'alerte passer en Pending puis Firing sur :9090/alerts
```

---

## Recharger la config Prometheus sans restart

```bash
curl -X POST http://localhost:9090/-/reload
```

---

## ➡️ Suite : `03-alertmanager-routing.md`
