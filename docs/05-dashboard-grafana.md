# 05 — Dashboard Grafana pour les alertes

## Accès

http://localhost:3000 — admin / admin

## Importer le dashboard Node Exporter Full

1. Menu gauche → **Dashboards → Import**
2. ID Grafana : **1860** (Node Exporter Full — dashboard officiel)
3. Cliquer **Load** → sélectionner datasource **Prometheus** → **Import**

## Configurer les annotations d'alertes

1. Dans un dashboard → **Settings (roue crantée)**
2. Onglet **Annotations → Add annotation query**
3. Datasource : **Prometheus**
4. Expr : `ALERTS{alertstate="firing"}`
5. Title : `{{ $labels.alertname }}`

→ Les alertes Firing apparaissent comme des barres verticales rouges sur les graphes.

## Créer un panel d'état des alertes

1. **Add panel → Stat**
2. Query : `count(ALERTS{alertstate="firing"})` → nombre d'alertes actives
3. Seuils : 0 = vert, 1 = orange, 5 = rouge

## Lier Alertmanager à Grafana (optionnel)

Dans `grafana-datasource.yml`, ajouter :

```yaml
  - name: Alertmanager
    type: alertmanager
    access: proxy
    url: http://alertmanager:9093
    jsonData:
      handleGrafanaManagedAlerts: false
      implementation: prometheus
```

→ Permet de voir les silences et alertes Alertmanager directement dans Grafana.
